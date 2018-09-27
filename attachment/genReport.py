#Copyright ReportLab Europe Ltd. 2000-2017
#see license.txt for license details
"""
Tests for the text Label class.
"""
from reportlab.lib.testutils import setOutDir,setOutDir,makeSuiteForClasses, outputfile, printLocation
setOutDir(__name__)

import os, sys, copy, time
from os.path import join, basename, splitext
import unittest
from reportlab.lib import colors
from reportlab.lib.units import cm
from reportlab.lib.pagesizes import A4
from reportlab.lib.styles import getSampleStyleSheet, ParagraphStyle
from reportlab.pdfgen.canvas import Canvas
from reportlab.graphics.shapes import *
from reportlab.graphics.charts.textlabels import Label
from reportlab.platypus.flowables import Spacer, PageBreak
from reportlab.platypus.paragraph import Paragraph
from reportlab.platypus.xpreformatted import XPreformatted
from reportlab.platypus.frames import Frame
from reportlab.platypus.doctemplate import PageTemplate, BaseDocTemplate
from reportlab.platypus import Image

from reportlab.platypus.figures import Figure

from PIL import Image
import numpy
from numpy import *
import matplotlib
import matplotlib.pyplot as plt
from reportlab.lib.utils import ImageReader

import reportlab.lib, reportlab.platypus
from reportlab.lib.units import inch, cm

from reportlab.pdfbase import pdfmetrics
from reportlab.pdfbase.ttfonts import TTFont

# TTFontpath = {'zen':'/usr/share/fonts/truetype/wqy/wqy-zenhei.ttc','micro':'/usr/share/fonts/truetype/wqy/wqy-microhei.ttc'}
TTFontpath = {'zen':'./wqy-zenhei.ttc','micro':'./wqy-microhei.ttc'}

pdfmetrics.registerFont(TTFont('micro', TTFontpath['micro']))
pdfmetrics.registerFont(TTFont('zen', TTFontpath['zen']))
# pdfmetrics.registerFont(TTFont('zen', '/usr/share/fonts/truetype/wqy/wqy-zenhei.ttc'))
# pdfmetrics.registerFont(TTFont('micro', '/usr/share/fonts/truetype/wqy/wqy-microhei.ttc'))

zhfont1 = matplotlib.font_manager.FontProperties(fname=TTFontpath['micro'])
zhfont1 = matplotlib.font_manager.FontProperties(fname=TTFontpath['zen'])
# zhfont1 = matplotlib.font_manager.FontProperties(fname='/usr/share/fonts/truetype/wqy/wqy-microhei.ttc')
# zhfont2 = matplotlib.font_manager.FontProperties(fname='/usr/share/fonts/truetype/wqy/wqy-zenhei.ttc')
zhfontlegend = zhfont1
zhfontlegend.set_size(22)

class flowable_fig(reportlab.platypus.Flowable):
    def __init__(self, imgdata):
        reportlab.platypus.Flowable.__init__(self)
        self.img = reportlab.lib.utils.ImageReader(imgdata)
    def draw(self):
        #self.canv.drawImage(self.img, 0, 0, height = -3*inch, width=5*inch)
        self.canv.drawImage(self.img, 0.5 * A4[0]-3.5*inch, 0*inch, height = -3*inch, width = 5*inch)

def myMainPageFrame(canvas, doc):
    "The page frame used for all PDF documents."

    canvas.saveState()

    canvas.setFont('Times-Roman', 12)
    pageNumber = canvas.getPageNumber()
    canvas.drawString(10*cm, cm, str(pageNumber))

    canvas.restoreState()


class MyDocTemplate(BaseDocTemplate):
    "The document template used for all PDF documents."

    _invalidInitArgs = ('pageTemplates',)

    def __init__(self, filename, **kw):
        frame1 = Frame(inch, inch, A4[0]-2*inch, A4[1]-2*inch, id='F1')
        self.allowSplitting = 0
        BaseDocTemplate.__init__(self, filename, **kw)
        template = PageTemplate('normal', [frame1], myMainPageFrame)
        self.addPageTemplates(template)

        top_margin = A4[1] - inch
        bottom_margin = inch
        left_margin = inch
        right_margin = A4[0] - inch
        frame_width = right_margin - left_margin

# class LabelTestCase(unittest.TestCase):
#     "Test Label class."

#     def _test0(self):
#         "Perform original test function."

#         pdfPath = outputfile('test_charts_textlabels.pdf')
#         c = Canvas(pdfPath)

#         label = Label()
#         demoLabel = label.demo()
#         demoLabel.drawOn(c, 0, 0)

#         c.save()


    # def _makeProtoLabel(self):
    #     "Return a label prototype for further modification."

    #     protoLabel = Label()
    #     protoLabel.dx = 0
    #     protoLabel.dy = 0
    #     protoLabel.boxStrokeWidth = 0.1
    #     protoLabel.boxStrokeColor = colors.black
    #     protoLabel.boxFillColor = colors.yellow
    #     # protoLabel.text = 'Hello World!' # Does not work as expected.

    #     return protoLabel


    # def _makeDrawings(self, protoLabel, text=None):
    #     # Set drawing dimensions.
    #     w, h = drawWidth, drawHeight = 400, 100

    #     drawings = []

    #     for boxAnchors in ('sw se nw ne', 'w e n s', 'c'):
    #         boxAnchors = boxAnchors.split(' ')

    #         # Create drawing.
    #         d = Drawing(w, h)
    #         d.add(Line(0, h*0.5, w, h*0.5, strokeColor=colors.gray, strokeWidth=0.5))
    #         d.add(Line(w*0.5 ,0, w*0.5, h, strokeColor=colors.gray, strokeWidth=0.5))

    #         labels = []
    #         for boxAnchor in boxAnchors:
    #             # Modify label, put it on a drawing.
    #             label = copy.deepcopy(protoLabel)
    #             label.boxAnchor = boxAnchor
    #             args = {'ba':boxAnchor, 'text':text or 'Hello World!'}
    #             label.setText('(%(ba)s) %(text)s (%(ba)s)' % args)
    #             labels.append(label)

    #         for label in labels:
    #             d.add(label)

    #         drawings.append(d)

    #     return drawings


def getMyImage(x, y, xlabel, ylabel, title, legendstr = ''):
    fig = plt.figure(figsize = (16,16))
    if y.size == y.shape[0]:
        plt.plot(x,y, label = legendstr)
    else:
        for i in range(y.shape[1]):
            plt.plot(x, y[:,i], label = legendstr[i])
    plt.xlabel(xlabel,fontsize = 24, fontproperties=zhfont1)
    plt.ylabel(ylabel,fontsize = 24, fontproperties=zhfont1)
    plt.title(title,fontsize = 28, fontproperties=zhfont1)
    if legendstr != '': 
        plt.legend(loc='best', ncol=y.size//y.shape[0], prop = zhfontlegend, shadow=True, fancybox=True).get_frame().set_alpha(0.4)
    # plt.legend() mode="expand",
    # plt.legend((u'测试',),loc='upper right', prop = zhfontle)
    # plt.show()
    imgdata = Image.io.BytesIO()
    fig.savefig(imgdata, format='png')
    imgdata.seek(0)  
    return flowable_fig(imgdata)



def run():

    st = sys.argv
    if (len(st) > 1):
        filename = st[1].split('.')[0]
    else:
        print("Please input log file name!")
        return
    # filename = 'ttest2'
    # filename = 'simlog'

    story = []
    styleSheet = getSampleStyleSheet()
    bt = styleSheet['BodyText']
    cbt = styleSheet['BodyText']
    h1 = styleSheet['Heading1']
    ch1 = styleSheet['Heading1']
    h2 = styleSheet['Heading2']
    ch2 = styleSheet['Heading2']
    h3 = styleSheet['Heading3']
    
    cbt.fontName = 'micro'
    ch1.fontName ='zen'
    ch2.fontName ='zen'
    
    pytime0 = time.time()


    print("Start log reading ...")
    data = numpy.loadtxt(open(filename+'.csv',"rb"),delimiter=",",skiprows=0) 
    pytime1 = time.time()
    print("Log read complete! Time cost: %2.2fs" % (pytime1 - pytime0))
    print("Start data analysize ...")

    #0  int32_t time_boot_ms; /*< Time stamp*/
    #1  float voltage_up; /*< The voltage of above ESC*/
    #2  float voltage_down; /*< The voltage of following ESC.*/
    #3  float current_up; /*< The current of above ESC*/
    #4  float current_down; /*< The curent of following ESC*/
    #5  float temperature; /*< Temperature*/
    #6  float humidity; /*< Humidity*/
    #7  float total_current; /*< The total of currents*/
    #8  uint16_t esc_pwm_up; /*< PWM of the above ESC.*/
    #9  uint16_t esc_pwm_down; /*< PWM of following ESC.*/
    #10  uint16_t fan_pwm; /*< PWM of fan.*/
    #11  uint16_t pull; /*< Pull*/
    #12  uint16_t torque; /*< Torque*/
    #13  uint16_t rotating_speed_up; /*< The above motor speed*/
    #14  uint16_t rotating_speed_down; /*< The following motor speed*/
    #15  uint16_t rc_in; /*< The value of remote control throttle*/
    #16  uint8_t system_status; /*< 0: Normal 1:Abnormal*/
    #17  uint8_t mode; /*< 1:Real-time mode 2:Remote-control mode 3:Script mode*/
    simt = (data[:,0] - data[0,0]) / 1000.0
    total_time = simt[-1] - simt[0]
    datanum = simt.size

    pwm = data[:, 8:11]
    volt = data[:, 1:3]
    curr = data[:,[3,4,7]]
    Thrust = data[:, 11]
    Torque = data[:, 12]
    speed = data[:, 13:15]*0.060
    # curr = hstack((data[:, 3:5], (data[:,7]).reshape(simt.size,1)))

    pytime2 = time.time()
    print("Data analysize complete! Time cost: %2.2fs" % (pytime2 - pytime1))

    print("Start report generating ...")
    
    story.append(Paragraph('电机测试报告', ch1))
    story.append(Paragraph('一、基本测试结果', ch2))
#     story.append(Paragraph("""随便说几句话， This should display "Hello World" labels
# written as black text on a yellow box relative to the origin of the crosshair
# axes. The labels indicate their relative position being one of the nine
# canonical points of a box: sw, se, nw, ne, w, e, n, s or c (standing for
# <i>southwest</i>, <i>southeast</i>... and <i>center</i>).""", cbt))
    story.append(Paragraph('1. PWM曲线', cbt))
    # story.append(Spacer(0, 0.5*cm))
    story.append(getMyImage(simt, pwm, '时间(s)', 'PWM', '电机和风扇PWM输入曲线',['上电机','下电机','风扇']))
    story.append(Spacer(0,3*inch+0.5*cm))

    story.append(Paragraph('2. 电压曲线', cbt))
    # story.append(Spacer(0, 0.5*cm))
    story.append(getMyImage(simt, volt, '时间(s)', '电压(V)', '电调电压曲线',['上电机电调电压','下电机电调电压']))
    story.append(Spacer(0,3*inch+0.5*cm))
    story.append(PageBreak())

    #=========== p2
    story.append(Paragraph('3. 电流曲线', cbt))
    story.append(getMyImage(simt, curr, '时间(s)', '电压(V)', '电调电压曲线',['上电机电调电流','下电机电调电流','总电流']))
    story.append(Spacer(0,3*inch+0.5*cm))

    story.append(Paragraph('4. 温度曲线', cbt))
    story.append(getMyImage(simt, data[:,5], '时间(s)', '温度(度)', '温度曲线'))
    story.append(Spacer(0,3*inch+0.5*cm))

    story.append(Paragraph('5. 湿度曲线', cbt))
    story.append(getMyImage(simt, data[:,5], '时间(s)', '湿度(%)', '湿度曲线'))
    # story.append(Spacer(0,3*inch+0.5*cm))
    story.append(PageBreak())

    #============ p3
    story.append(Paragraph('6. 电机转速曲线', cbt))
    story.append(getMyImage(simt, speed, '时间(s)', '转速(kRPM)', '电机转速曲线',['上电机转速','下电机转速']))
    story.append(Spacer(0,3*inch+0.5*cm))

    story.append(Paragraph('7. 拉力曲线', cbt))
    story.append(getMyImage(simt, Thrust, '时间(s)', '拉力(N)', '拉力曲线'))
    story.append(Spacer(0,3*inch+0.5*cm))

    story.append(Paragraph('8. 扭矩曲线', cbt))
    story.append(getMyImage(simt, Torque, '时间(s)', '扭矩(Nm)', '扭矩曲线'))
    story.append(PageBreak())

    #============= p4


    pytime3 = time.time()
    print("Report generation complete! Time cost: %4.2fs" % (pytime3 - pytime2))
    print("Total time cost: %4.2fs" % (pytime3 - pytime0))
    path = outputfile('MotorTestReport.pdf')
    doc = MyDocTemplate(path)
    doc.multiBuild(story) 


def makeSuite():
    return makeSuiteForClasses(LabelTestCase)


#noruntests
if __name__ == "__main__":
    run()
    # unittest.TextTestRunner().run(makeSuite())
    # printLocation()







 # Round 1a
#         story.append(Paragraph('Helvetica 10pt', h3))
#         story.append(Spacer(0, 0.5*cm))

#         w, h = drawWidth, drawHeight = 400, 100
#         protoLabel = self._makeProtoLabel()
#         protoLabel.setOrigin(drawWidth*0.5, drawHeight*0.5)
#         protoLabel.textAnchor = 'start'
#         protoLabel.fontName = 'Helvetica'
#         protoLabel.fontSize = 10
#         drawings = self._makeDrawings(protoLabel)
#         for d in drawings:
#             story.append(d)
#             story.append(Spacer(0, 1*cm))

#         story.append(PageBreak())

#         # Round 1b
#         story.append(Paragraph('Helvetica 18pt', h3))
#         story.append(Spacer(0, 0.5*cm))

#         w, h = drawWidth, drawHeight = 400, 100
#         protoLabel = self._makeProtoLabel()
#         protoLabel.setOrigin(drawWidth*0.5, drawHeight*0.5)
#         protoLabel.textAnchor = 'start'
#         protoLabel.fontName = 'Helvetica'
#         protoLabel.fontSize = 18
#         drawings = self._makeDrawings(protoLabel)
#         for d in drawings:
#             story.append(d)
#             story.append(Spacer(0, 1*cm))

#         story.append(PageBreak())

#         # Round 1c
#         story.append(Paragraph('Helvetica 18pt, multi-line', h3))
#         story.append(Spacer(0, 0.5*cm))

#         w, h = drawWidth, drawHeight = 400, 100
#         protoLabel = self._makeProtoLabel()
#         protoLabel.setOrigin(drawWidth*0.5, drawHeight*0.5)
#         protoLabel.textAnchor = 'start'
#         protoLabel.fontName = 'Helvetica'
#         protoLabel.fontSize = 18
#         drawings = self._makeDrawings(protoLabel, text='Hello\nWorld!')
#         for d in drawings:
#             story.append(d)
#             story.append(Spacer(0, 1*cm))

#         story.append(PageBreak())

#         story.append(Paragraph('Testing text (and box) anchors', h2))
#         story.append(Paragraph("""This should display labels as before,
# but now with a fixes size and showing some effect of setting the
# textAnchor attribute.""", bt))
#         story.append(Spacer(0, 0.5*cm))

#         # Round 2a
#         story.append(Paragraph("Helvetica 10pt, textAnchor='start'", h3))
#         story.append(Spacer(0, 0.5*cm))

#         w, h = drawWidth, drawHeight = 400, 100
#         protoLabel = self._makeProtoLabel()
#         protoLabel.setOrigin(drawWidth*0.5, drawHeight*0.5)
#         protoLabel.width = 4*cm
#         protoLabel.height = 1.5*cm
#         protoLabel.textAnchor = 'start'
#         protoLabel.fontName = 'Helvetica'
#         protoLabel.fontSize = 10
#         drawings = self._makeDrawings(protoLabel)
#         for d in drawings:
#             story.append(d)
#             story.append(Spacer(0, 1*cm))

#         story.append(PageBreak())

#         # Round 2b
#         story.append(Paragraph("Helvetica 10pt, textAnchor='middle'", h3))
#         story.append(Spacer(0, 0.5*cm))

#         w, h = drawWidth, drawHeight = 400, 100
#         protoLabel = self._makeProtoLabel()
#         protoLabel.setOrigin(drawWidth*0.5, drawHeight*0.5)
#         protoLabel.width = 4*cm
#         protoLabel.height = 1.5*cm
#         protoLabel.textAnchor = 'middle'
#         protoLabel.fontName = 'Helvetica'
#         protoLabel.fontSize = 10
#         drawings = self._makeDrawings(protoLabel)
#         for d in drawings:
#             story.append(d)
#             story.append(Spacer(0, 1*cm))

#         story.append(PageBreak())

#         # Round 2c
#         story.append(Paragraph("Helvetica 10pt, textAnchor='end'", h3))
#         story.append(Spacer(0, 0.5*cm))

#         w, h = drawWidth, drawHeight = 400, 100
#         protoLabel = self._makeProtoLabel()
#         protoLabel.setOrigin(drawWidth*0.5, drawHeight*0.5)
#         protoLabel.width = 4*cm
#         protoLabel.height = 1.5*cm
#         protoLabel.textAnchor = 'end'
#         protoLabel.fontName = 'Helvetica'
#         protoLabel.fontSize = 10
#         drawings = self._makeDrawings(protoLabel)
#         for d in drawings:
#             story.append(d)
#             story.append(Spacer(0, 1*cm))

#         story.append(PageBreak())

#         # Round 2d
#         story.append(Paragraph("Helvetica 10pt, multi-line, textAnchor='start'", h3))
#         story.append(Spacer(0, 0.5*cm))

#         w, h = drawWidth, drawHeight = 400, 100
#         protoLabel = self._makeProtoLabel()
#         protoLabel.setOrigin(drawWidth*0.5, drawHeight*0.5)
#         protoLabel.width = 4*cm
#         protoLabel.height = 1.5*cm
#         protoLabel.textAnchor = 'start'
#         protoLabel.fontName = 'Helvetica'
#         protoLabel.fontSize = 10
#         drawings = self._makeDrawings(protoLabel, text='Hello\nWorld!')
#         for d in drawings:
#             story.append(d)
#             story.append(Spacer(0, 1*cm))

#         story.append(PageBreak())
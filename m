Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751936AbaAQBgt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 20:36:49 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:26081 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751833AbaAQBgo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 20:36:44 -0500
X-AuditID: cbfee690-b7f266d00000287c-38-52d8892b0249
From: Jingoo Han <jg1.han@samsung.com>
To: "=?ISO-8859-1?Q?'Lothar_Wa=DFmann'?=" <LW@KARO-electronics.de>,
        "'Dmitry Torokhov'" <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org,
        "'Simon Budig'" <simon.budig@kernelconcepts.de>,
        "'Rob Herring'" <robh+dt@kernel.org>,
        "'Pawel Moll'" <pawel.moll@arm.com>,
        "'Mark Rutland'" <mark.rutland@arm.com>,
        "'Ian Campbell'" <ijc+devicetree@hellion.org.uk>,
        "'Kumar Gala'" <galak@codeaurora.org>,
        "'Rob Landley'" <rob@landley.net>,
        "'Thierry Reding'" <thierry.reding@gmail.com>,
        "'Grant Likely'" <grant.likely@linaro.org>,
        "'Jonathan Cameron'" <jic23@kernel.org>,
        "'Shawn Guo'" <shawn.guo@linaro.org>,
        "'Silvio F'" <silvio.fricke@gmail.com>,
        "'Guennadi Liakhovetski'" <g.liakhovetski@gmx.de>,
        "'Fugang Duan'" <B38611@freescale.com>,
        "'Sachin Kamat'" <sachin.kamat@linaro.org>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <1389859338-11685-1-git-send-email-LW@KARO-electronics.de>
 <1389859338-11685-4-git-send-email-LW@KARO-electronics.de>
 <20140117002649.GA837@core.coreip.homeip.net>
In-reply-to: <20140117002649.GA837@core.coreip.homeip.net>
Subject: Re: [PATCHv2 3/3] Input: edt-ft5x06: Add DT support
Date: Fri, 17 Jan 2014 10:36:42 +0900
Message-id: <000101cf1324$932c0600$b9841200$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 8BIT
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac8TGtPEHZIot/7TQ4yPYEyy9TeZWgACOlhw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrEKsWRmVeSWpSXmKPExsVy+t8zI13tzhtBBrPeslqc2LyL0WL+kXOs
	FocXvWC0eL9xHpNF/5uFrBYH/uxgtDj3aiWjxeWFl1gtHjStYrJY2LaExeLmp2+sFpd3zWGz
	OPBkOZvF0usXmSwmTF/LYrHu5XQWi9a9R9gtTv7pZbR4um4Js8XWYy4WW3+lWPzcNY/FQcxj
	zbw1jB6X+3qZPP4d7mfy2DnrLrvHh49xHiuXf2HzmD/9EbPHplWdbB7bDp5g9Hi1eiarx51r
	e9g8+rasYvT4vEkugDeKyyYlNSezLLVI3y6BK+PIbLOCOTwVL7+1szQw7ufsYuTkkBAwkVi3
	djIrhC0mceHeerYuRi4OIYFljBKHmyexwBT9e7SFBSKxiFFizsNdjBDOL0aJy0dmgFWxCahJ
	fPlymB3EFhEolJh55x7YWGaBPjaJ3kl2EA2bGSUO7NjLDJLgFLCS+Ht6P1iRsICNxKyepWA2
	i4CqxL/nq8BsXgFbidmPz0HZghI/Jt9jgRiqI7G/dRobhK0t8eTdBaAaDqBT1SUe/dWFuMEI
	aMx5qBIRiX0v3oEdLSHQzSnRdryTBWKXgMS3yYdYIHplJTYdYIb4WFLi4IobLBMYJWYh2TwL
	yeZZSDbPQrJiASPLKkbR1ILkguKk9CITveLE3OLSvHS95PzcTYyQ9DRhB+O9A9aHGJOB1k9k
	lhJNzgemt7ySeENjMyMLUxNTYyNzSzPShJXEedUeJQUJCaQnlqRmp6YWpBbFF5XmpBYfYmTi
	4JRqYExe9KcwLvZx5xuVOw07Z0VJfch5HDN7yYIpMqpeu3w39Oep9f2ytBfgunGf81FTZt+u
	rzPcN0+ur+r9+T4sbmnug/nlzo/4zhx9O3Xa/CmmKq+5Bc7cm9jrteFtEu+D6RH6p61vFfru
	DNLMmqw18euNLYbz9zltPbCbjfW1Ov+q/gYZ/fv87/YosRRnJBpqMRcVJwIAAYnZdGUDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPJsWRmVeSWpSXmKPExsVy+t9jAV2tzhtBBucuWVuc2LyL0WL+kXOs
	FocXvWC0eL9xHpNF/5uFrBYH/uxgtDj3aiWjxeWFl1gtHjStYrJY2LaExeLmp2+sFpd3zWGz
	OPBkOZvF0usXmSwmTF/LYrHu5XQWi9a9R9gtTv7pZbR4um4Js8XWYy4WW3+lWPzcNY/FQcxj
	zbw1jB6X+3qZPP4d7mfy2DnrLrvHh49xHiuXf2HzmD/9EbPHplWdbB7bDp5g9Hi1eiarx51r
	e9g8+rasYvT4vEkugDeqgdEmIzUxJbVIITUvOT8lMy/dVsk7ON453tTMwFDX0NLCXEkhLzE3
	1VbJxSdA1y0zB+hvJYWyxJxSoFBAYnGxkr4dpgmhIW66FjCNEbq+IUFwPUYGaCBhHWPGkdlm
	BXN4Kl5+a2dpYNzP2cXIySEhYCLx79EWFghbTOLCvfVsXYxcHEICixgl5jzcxQjh/GKUuHxk
	BlgVm4CaxJcvh9lBbBGBQomZd+6xgtjMAn1sEr2T7CAaNjNKHNixlxkkwSlgJfH39H6wImEB
	G4lZPUvBbBYBVYl/z1eB2bwCthKzH5+DsgUlfky+xwIxVEdif+s0NghbW+LJuwtANRxAp6pL
	PPqrC3GDEdCY81AlIhL7XrxjnMAoNAvJpFlIJs1CMmkWkpYFjCyrGEVTC5ILipPScw31ihNz
	i0vz0vWS83M3MYKT3zOpHYwrGywOMQpwMCrx8EqI3wgSYk0sK67MPcQowcGsJMI7Px4oxJuS
	WFmVWpQfX1Sak1p8iDEZ6NGJzFKiyfnAxJxXEm9obGJmZGlkZmFkYm5OmrCSOO+BVutAIYH0
	xJLU7NTUgtQimC1MHJxSDYweZTPe60dGLNjTrDl/5wm/DdevdO598O9J8h9hFq1TO7xcpxlN
	WfCF+Wvs37LrC9+rsnsssSqZk1dwLn8L264kmX0bVQMX8obsdb2QtChrRoXc7ol/JvYna+Ud
	crEWqGd42hP35JJD6Yqyi+rVJtpBB3qn9J2cFfD9hPCy5w8D5099PZXRKT5DiaU4I9FQi7mo
	OBEA/8pIQsIDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, January 17, 2014 9:27 AM, Dmitry Torokhov wrote:
> On Thu, Jan 16, 2014 at 09:02:18AM +0100, Lothar Waﬂmann wrote:
> >
> > Signed-off-by: Lothar Waﬂmann <LW@KARO-electronics.de>
> > ---
> >  .../bindings/input/touchscreen/edt-ft5x06.txt      |   29 +++++
> >  drivers/input/touchscreen/edt-ft5x06.c             |  121 +++++++++++++++++---
> >  2 files changed, 132 insertions(+), 18 deletions(-)
> >  create mode 100644 Documentation/devicetree/bindings/input/touchscreen/edt-ft5x06.txt
> >

[.....]

> > +	if (gpio_is_valid(tsdata->reset_pin)) {
> >  		/* this pulls reset down, enabling the low active reset */
> > -		error = devm_gpio_request_one(&client->dev, reset_pin,
> > +		error = devm_gpio_request_one(&client->dev, tsdata->reset_pin,
> >  					GPIOF_OUT_INIT_LOW,
> >  					"edt-ft5x06 reset");
> >  		if (error) {
> >  			dev_err(&client->dev,
> >  				"Failed to request GPIO %d as reset pin, error %d\n",
> > -				reset_pin, error);
> > +				tsdata->reset_pin, error);
> >  			return error;
> >  		}
> >
> > -		mdelay(50);
> > -		gpio_set_value(reset_pin, 1);
> > -		mdelay(100);
> > +		mdelay(5);
> > +		gpio_set_value(tsdata->reset_pin, 1);
> > +		mdelay(300);
> 
> Hmm, this change seems unrelated to DT support.

Right, modifying delay timing is not related to DT support.
In this case, this patch should be split, and the patch should
address the reason why delay timing is modified.
Also, 300 msec is a huge delay. Thus, comment will be helpful.

Best regards,
Jingoo Han


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751520AbaAPHuL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 02:50:11 -0500
Received: from mail.karo-electronics.de ([81.173.242.67]:54055 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750836AbaAPHuI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 02:50:08 -0500
Date: Thu, 16 Jan 2014 08:49:43 +0100
From: Lothar =?UTF-8?B?V2HDn21hbm4=?= <LW@KARO-electronics.de>
To: Mark Rutland <mark.rutland@arm.com>
Cc: "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <Pawel.Moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Jonathan Cameron <jic23@kernel.org>, Shawn Guo <shawn.guo@linaro.org>,
        Silvio F <silvio.fricke@gmail.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Jingoo Han <jg1.han@samsung.com>, Fugang Duan <B38611@freescale.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Simon Budig <simon.budig@kernelconcepts.de>
Subject: Re: [PATCH 2/2] Input: edt-ft5x06: Add DT support
Message-ID: <20140116084943.17da0226@ipc1.ka-ro>
In-Reply-To: <20140113134441.GD1273@e106331-lin.cambridge.arm.com>
References: <1389608224-9975-1-git-send-email-LW@KARO-electronics.de>
	<1389608224-9975-2-git-send-email-LW@KARO-electronics.de>
	<20140113134441.GD1273@e106331-lin.cambridge.arm.com>
Organization: Ka-Ro electronics GmbH
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Mark Rutland wrote:
> On Mon, Jan 13, 2014 at 10:17:04AM +0000, Lothar Waßmann wrote:
> > This patch allows the edt-ft5x06 multitouch panel driver to be
> > configured via DT.
> > 
> > Signed-off-by: Lothar Waßmann <LW@KARO-electronics.de>
> > ---
> >  .../bindings/input/touchscreen/edt-ft5x06.txt      |   31 ++++
> >  drivers/input/touchscreen/edt-ft5x06.c             |  145 +++++++++++++++----
> >  2 files changed, 145 insertions(+), 31 deletions(-)
> >  create mode 100644 Documentation/devicetree/bindings/input/touchscreen/edt-ft5x06.txt
> > 
> > diff --git a/Documentation/devicetree/bindings/input/touchscreen/edt-ft5x06.txt b/Documentation/devicetree/bindings/input/touchscreen/edt-ft5x06.txt
> > new file mode 100644
> > index 0000000..629dbdd
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/input/touchscreen/edt-ft5x06.txt
> > @@ -0,0 +1,31 @@
> > +* EDT FT5x06 Multiple Touch Controller
> > +
[...]
> > +- threshold: allows setting the "click"-threshold in the range from 20 to 80.
> > +- gain: sensitivity (0..31) (lower value -> higher sensitivity)
> > +- offset: edge compensation (0..31)
> > +- report_rate: report rate (3..14)
> 
> s/_/-/ on property names please. Also, it may make sense to prefix these
> as they're rather generic sounding names.
> 
> Could you elaborate on these a litle please? What units are each of
> these in? Why does it make sense to have them in the dt?
> 
I just converted them from being passed via platform_data. I have no
idea what they actually control and what units they use. I could not
even find a manual where they are documented.
Maybe Simon Budig can help out here as the original driver author.


Lothar Waßmann
-- 
___________________________________________________________

Ka-Ro electronics GmbH | Pascalstraße 22 | D - 52076 Aachen
Phone: +49 2408 1402-0 | Fax: +49 2408 1402-10
Geschäftsführer: Matthias Kaussen
Handelsregistereintrag: Amtsgericht Aachen, HRB 4996

www.karo-electronics.de | info@karo-electronics.de
___________________________________________________________

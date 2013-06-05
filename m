Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751450Ab3FEEZF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 00:25:05 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:47697 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750854Ab3FEEYg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 00:24:36 -0400
From: "J, KEERTHY" <j-keerthy@ti.com>
To: Lee Jones <lee.jones@linaro.org>, Stephen Warren <swarren@wwwdotorg.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "rob@landley.net" <rob@landley.net>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "wim@iguana.be" <wim@iguana.be>,
        "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "gg@slimlogic.co.uk" <gg@slimlogic.co.uk>,
        "Kristo, Tero" <t-kristo@ti.com>
Subject: RE: [PATCH v2] mfd: DT bindings for the palmas family MFD
Thread-Topic: [PATCH v2] mfd: DT bindings for the palmas family MFD
Thread-Index: AQHOYQBsAZZhG5yimUKsMK4ElU7bxZkk8ggAgAGUXUA=
Date: Wed, 5 Jun 2013 04:24:02 +0000
Message-ID: <DC88CAD03C0052499C1907B327FC63229E8DF9@DBDE04.ent.ti.com>
References: <1370335309-6319-1-git-send-email-j-keerthy@ti.com>
 <20130604121434.GN3370@gmail.com>
In-Reply-To: <20130604121434.GN3370@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.170.142]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r554PFEv025004

Hello Lee Jones,

> -----Original Message-----
> From: Lee Jones [mailto:lee.jones@linaro.org]
> Sent: Tuesday, June 04, 2013 5:45 PM
> To: J, KEERTHY
> Cc: linux-kernel@vger.kernel.org; linux-doc@vger.kernel.org;
> devicetree-discuss@lists.ozlabs.org; swarren@wwwdotorg.org;
> broonie@opensource.wolfsonmicro.com; rob.herring@calxeda.com;
> rob@landley.net; sameo@linux.intel.com; wim@iguana.be;
> lgirdwood@gmail.com; gg@slimlogic.co.uk; Kristo, Tero; Ian Lartey
> Subject: Re: [PATCH v2] mfd: DT bindings for the palmas family MFD
> 
> On Tue, 04 Jun 2013, J Keerthy wrote:
> 
> > From: Graeme Gregory <gg@slimlogic.co.uk>
> >
> > Add the various binding files for the palmas family of chips. There
> is
> > a top level MFD binding then a seperate binding for regulators IP
> blocks on chips.
> >
> > Signed-off-by: Graeme Gregory <gg@slimlogic.co.uk>
> > Signed-off-by: J Keerthy <j-keerthy@ti.com>
> > Signed-off-by: Ian Lartey <ian@slimlogic.co.uk>
> > ---
> > Changes from v1:
> > * Corrected ti,ldo6_vibrator property ---> ti,ldo6-vibrator
> > * Added the irq.h header file inclusion for defining type of
> interrupt
> >
> >  Documentation/devicetree/bindings/mfd/palmas.txt   |   49
> +++++++++++++++
> >  .../devicetree/bindings/regulator/palmas-pmic.txt  |   65
> ++++++++++++++++++++
> >  2 files changed, 114 insertions(+), 0 deletions(-)  create mode
> > 100644 Documentation/devicetree/bindings/mfd/palmas.txt
> >  create mode 100644
> > Documentation/devicetree/bindings/regulator/palmas-pmic.txt
> 
> Is there a driver to go with this patch, or was the documentation an
> afterthought in this case? If the latter is true I'd be happy to apply
> this patch with an Ack from Stephen or one of the other previous
> reviewers.

Well that's the latter case :-). 

Stephen,

Can this be taken?

> 
> --
> Lee Jones
> Linaro ST-Ericsson Landing Team Lead
> Linaro.org â”‚ Open source software for ARM SoCs Follow Linaro: Facebook
> | Twitter | Blog

Regards,
Keerthy
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753011Ab3FJJ1o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 05:27:44 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:36981 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751388Ab3FJJ1n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 05:27:43 -0400
From: "J, KEERTHY" <j-keerthy@ti.com>
To: Lee Jones <lee.jones@linaro.org>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "swarren@nvidia.com" <swarren@nvidia.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "rob@landley.net" <rob@landley.net>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "wim@iguana.be" <wim@iguana.be>,
        "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "gg@slimlogic.co.uk" <gg@slimlogic.co.uk>,
        "Kristo, Tero" <t-kristo@ti.com>, Ian Lartey <ian@slimlogic.co.uk>
Subject: RE: [PATCH v3] mfd: DT bindings for the palmas family MFD
Thread-Topic: [PATCH v3] mfd: DT bindings for the palmas family MFD
Thread-Index: AQHOYncuRwuUiYCq9keu21yMCEaQUZknvHwAgAABHgCABvaWkA==
Date: Mon, 10 Jun 2013 09:27:12 +0000
Message-ID: <DC88CAD03C0052499C1907B327FC63229EAB5B@DBDE04.ent.ti.com>
References: <1370496441-24620-1-git-send-email-j-keerthy@ti.com>
 <20130606070210.GR3370@gmail.com> <20130606070610.GS3370@gmail.com>
In-Reply-To: <20130606070610.GS3370@gmail.com>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r5A9Rpcs002925

Hello Grant/Lee Jones,

> -----Original Message-----
> From: Lee Jones [mailto:lee.jones@linaro.org]
> Sent: Thursday, June 06, 2013 12:36 PM
> To: J, KEERTHY
> Cc: linux-kernel@vger.kernel.org; grant.likely@secretlab.ca; linux-
> doc@vger.kernel.org; devicetree-discuss@lists.ozlabs.org;
> swarren@wwwdotorg.org; swarren@nvidia.com; rob.herring@calxeda.com;
> rob@landley.net; sameo@linux.intel.com; wim@iguana.be;
> lgirdwood@gmail.com; gg@slimlogic.co.uk; Kristo, Tero; Ian Lartey
> Subject: Re: [PATCH v3] mfd: DT bindings for the palmas family MFD
> 
> On Thu, 06 Jun 2013, Lee Jones wrote:
> 
> > On Thu, 06 Jun 2013, J Keerthy wrote:
> >
> > > Add the various binding files for the palmas family of chips. There
> > > is a top level MFD binding then a seperate binding for regulators
> IP blocks on chips.
> > >
> > > Signed-off-by: Graeme Gregory <gg@slimlogic.co.uk>
> > > Signed-off-by: J Keerthy <j-keerthy@ti.com>
> > > Signed-off-by: Ian Lartey <ian@slimlogic.co.uk>
> > > Reviewed-by: Stephen Warren <swarren@nvidia.com>
> > > ---
> > >  Documentation/devicetree/bindings/mfd/palmas.txt   |   49
> +++++++++++++
> > >  .../devicetree/bindings/regulator/palmas-pmic.txt  |   72
> ++++++++++++++++++++
> > >  2 files changed, 121 insertions(+), 0 deletions(-)  create mode
> > > 100644 Documentation/devicetree/bindings/mfd/palmas.txt
> > >  create mode 100644
> > > Documentation/devicetree/bindings/regulator/palmas-pmic.tx
> >
> > Applied, thanks.
> 
> Ah wait. It appears Grant wants to take this.
> 
> Unapplied, thanks. :)
> 

Is it applied?

> --
> Lee Jones
> Linaro ST-Ericsson Landing Team Lead
> Linaro.org â”‚ Open source software for ARM SoCs Follow Linaro: Facebook
> | Twitter | Blog

Thanks,
Keerthy
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

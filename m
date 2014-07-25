Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760057AbaGYJC1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 05:02:27 -0400
Received: from mail-bn1blp0188.outbound.protection.outlook.com ([207.46.163.188]:22643
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759312AbaGYJCX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 05:02:23 -0400
Date: Fri, 25 Jul 2014 16:42:50 +0800
From: Nicolin Chen <Guangyu.Chen@freescale.com>
To: Varka Bhadram <varkabhadram@gmail.com>
CC: Nicolin Chen <nicoleotsuka@gmail.com>, <broonie@kernel.org>,
        <robh+dt@kernel.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <rdunlap@infradead.org>, <lgirdwood@gmail.com>, <perex@perex.cz>,
        <tiwai@suse.de>, <timur@tabi.org>, <grant.likely@linaro.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <alsa-devel@alsa-project.org>, <linuxppc-dev@lists.ozlabs.org>,
        <shawn.guo@linaro.org>, <b02247@freescale.com>, <b42378@freescale.com>,
        <tklauser@distanz.ch>
Subject: Re: [PATCH v4 2/2] ASoC: fsl_asrc: Add ASRC ASoC CPU DAI and
 platform drivers
Message-ID: <20140725084249.GB29564@MrMyself>
References: <cover.1406271541.git.nicoleotsuka@gmail.com>
 <69b75ae4b0335cd3c9bedad67f57aaba13c0048c.1406271541.git.nicoleotsuka@gmail.com>
 <53D208A9.3040903@gmail.com> <20140725075755.GA29564@MrMyself>
 <53D2189E.4030108@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <53D2189E.4030108@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(24454002)(189002)(199002)(51704005)(479174003)(377454003)(97756001)(92566001)(106466001)(4396001)(81542001)(81342001)(6806004)(83506001)(44976005)(33716001)(95666004)(104016003)(69596002)(97736001)(74502001)(26826002)(74662001)(80022001)(107046002)(81156004)(99396002)(85852003)(79102001)(50986999)(77982001)(21056001)(92726001)(68736004)(105606002)(31966008)(87936001)(46406003)(93886003)(76482001)(1411001)(84676001)(102836001)(110136001)(86362001)(46102001)(50466002)(85306003)(23726002)(83322001)(83072002)(76176999)(20776003)(64706001)(54356999)(47776003)(33656002)(217873001);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR03MB443;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 02830F0362
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=guangyu.chen@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 25, 2014 at 02:13:10PM +0530, Varka Bhadram wrote:
> On 07/25/2014 01:27 PM, Nicolin Chen wrote:
> >>>+	if (IS_ERR(asrc_priv->regmap)) {
> >>>+		dev_err(&pdev->dev, "failed to init regmap\n");
> >>>+		return PTR_ERR(asrc_priv->regmap);
> >>>+	}
> >>>+
> >>>+	irq = platform_get_irq(pdev, 0);
> >>>+	if (irq < 0) {
> >>>+		dev_err(&pdev->dev, "no irq for node %s\n", np->full_name);
> >>>+		return irq;
> >>>+	}
> >>>+
> >>>+	ret = devm_request_irq(&pdev->dev, irq, fsl_asrc_isr, 0,
> >>>+			       asrc_priv->name, asrc_priv);
> >>same...
> >Sorry I don't see any problem with this devm_request_irq()...
> 
> Ohhh... This is the problem with my email client... Sorry...

No problem. I appreciate your carefulness :)

Thank you,
Nicolin


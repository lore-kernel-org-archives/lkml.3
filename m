Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753171AbaG2KPu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 06:15:50 -0400
Received: from mail-bn1blp0183.outbound.protection.outlook.com ([207.46.163.183]:18246
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752841AbaG2KPs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 06:15:48 -0400
Date: Tue, 29 Jul 2014 18:13:24 +0800
From: Nicolin Chen <Guangyu.Chen@freescale.com>
To: Mark Rutland <mark.rutland@arm.com>
CC: Nicolin Chen <nicoleotsuka@gmail.com>,
        "broonie@kernel.org" <broonie@kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "rdunlap@infradead.org" <rdunlap@infradead.org>,
        "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "perex@perex.cz" <perex@perex.cz>, "tiwai@suse.de" <tiwai@suse.de>,
        "timur@tabi.org" <timur@tabi.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "b02247@freescale.com" <b02247@freescale.com>,
        "b42378@freescale.com" <b42378@freescale.com>,
        "tklauser@distanz.ch" <tklauser@distanz.ch>
Subject: Re: [PATCH v3 2/2] ASoC: fsl_asrc: Add ASRC ASoC CPU DAI and
 platform drivers
Message-ID: <20140729101322.GA5495@MrMyself>
References: <cover.1406259578.git.nicoleotsuka@gmail.com>
 <f4ff79269a1680f9ce128e0e98fea926d3a41834.1406259578.git.nicoleotsuka@gmail.com>
 <20140729094613.GK2576@leverpostej>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20140729094613.GK2576@leverpostej>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(51704005)(43784003)(24454002)(189002)(199002)(85306003)(74662001)(46102001)(74502001)(31966008)(79102001)(83322001)(68736004)(23726002)(33656002)(44976005)(102836001)(26826002)(83072002)(85852003)(86362001)(81542001)(54356999)(33716001)(92726001)(95666004)(104016003)(50466002)(83506001)(97756001)(77982001)(20776003)(106466001)(47776003)(107046002)(80022001)(97736001)(6806004)(50986999)(21056001)(84676001)(105606002)(92566001)(81342001)(110136001)(99396002)(87936001)(4396001)(46406003)(64706001)(76176999)(76482001)(217873001);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR03MB443;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 0287BBA78D
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=guangyu.chen@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 29, 2014 at 10:46:13AM +0100, Mark Rutland wrote:
> > +   - big-endian : If this property is absent, the native endian mode will
> > +                 be in use as default, or the big endian mode will be in use
> > +                 for all the device registers.
> 
> Native endian is meaningless. If a CPU supports both BE and LE, there is
> no native endianness. The endianness of the kernel is dynamic while the
> endianness of registers in HW is fixed. 
> 
> Just choose an endianness to assume by default (presumably little). That
> way this describes the HW and always works with a kernel of arbitrary
> endianness.

Thank you for the comments.

I just revised it by using 'little endian as default' and sent the patch v6.

Please take a look at the new version.

Thanks again,
Nicolin


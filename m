Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932438AbaHELJe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 07:09:34 -0400
Received: from mail-by2lp0240.outbound.protection.outlook.com ([207.46.163.240]:24973
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932385AbaHELJc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 07:09:32 -0400
Date: Tue, 5 Aug 2014 19:07:36 +0800
From: Nicolin Chen <Guangyu.Chen@freescale.com>
To: Varka Bhadram <varkabhadram@gmail.com>
CC: Nicolin Chen <nicoleotsuka@gmail.com>, <broonie@kernel.org>,
        <linux-kernel@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        <alsa-devel@alsa-project.org>, <timur@tabi.org>,
        <Li.Xiubo@freescale.com>, <devicetree@vger.kernel.org>,
        <galak@codeaurora.org>, <ijc+devicetree@hellion.org.uk>,
        <mark.rutland@arm.com>, <pawel.moll@arm.com>, <robh+dt@kernel.org>,
        <b42378@freescale.com>, <b02247@freescale.com>
Subject: Re: [PATCH] ASoC: fsl_sai: Add asynchronous mode support
Message-ID: <20140805110735.GA16503@MrMyself>
References: <1407223925-29678-1-git-send-email-nicoleotsuka@gmail.com>
 <53E0B926.9010103@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <53E0B926.9010103@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(24454002)(51704005)(199002)(189002)(81156004)(99396002)(47776003)(107046002)(74662001)(31966008)(74502001)(76176999)(54356999)(50986999)(105606002)(106466001)(85306004)(86362001)(83072002)(83506001)(85852003)(81542001)(87936001)(97736001)(84676001)(81342001)(97756001)(69596002)(64706001)(80022001)(20776003)(68736004)(26826002)(1411001)(76482001)(79102001)(6806004)(44976005)(83322001)(110136001)(19580395003)(77982001)(104016003)(33656002)(46102001)(102836001)(4396001)(50466002)(95666004)(92726001)(21056001)(23726002)(46406003)(92566001)(33716001);DIR:OUT;SFP:;SCL:1;SRVR:BL2PR03MB322;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 02945962BD
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=guangyu.chen@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Varka,

On Tue, Aug 05, 2014 at 04:29:50PM +0530, Varka Bhadram wrote:
> >diff --git a/Documentation/devicetree/bindings/sound/fsl-sai.txt b/Documentation/devicetree/bindings/sound/fsl-sai.txt
> >index 0f4e238..77864f4 100644
> >--- a/Documentation/devicetree/bindings/sound/fsl-sai.txt
> >+++ b/Documentation/devicetree/bindings/sound/fsl-sai.txt
> >@@ -24,6 +24,22 @@ Required properties:
> >  - big-endian-data: If this property is absent, the little endian mode will
> >    be in use as default, or the big endian mode will be in use for all the
> >    fifo data.
> >+- fsl,sai-synchronous-rx: This is a boolean property. If present, indicating
> >+  that SAI will work in the synchronous mode (sync Tx with Rx) which means
> >+  both the transimitter and receiver will send and receive data by following
> >+  receiver's bit clocks and frame sync clocks.
> >+- fsl,sai-asynchronous: This is a boolean property. If present, indicating
> >+  that SAI will work in the asynchronous mode, which means both transimitter
> >+  and receiver will send and receive data by following their own bit clocks
> >+  and frame sync clocks separately.
> >
> Would be readable if it like this...
> 
> fsl,sai-synchronous-rx: This is a boolean property. If present, indicating
> 			that SAI will work in the synchronous mode (sync Tx with Rx) which means
> 			both the transimitter and receiver will send and receive data by following
> 			receiver's bit clocks and frame sync clocks.
> - fsl,sai-asynchronous: This is a boolean property. If present, indicating
> 			that SAI will work in the asynchronous mode, which means both transimitter
> 			and receiver will send and receive data by following their own bit clocks
> 			and frame sync clocks separately.

I agree, however, the doc was initialized in that format. Adding
indentations for these two appended lines makes the whole text
look weird. :(

Thank you,
Nicolin

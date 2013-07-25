Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755367Ab3GYJ3w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 05:29:52 -0400
Received: from co9ehsobe002.messaging.microsoft.com ([207.46.163.25]:46750
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754912Ab3GYJ3s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 05:29:48 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 1
X-BigFish: VS1(zz98dI1432Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6h1082kzzz2dh2a8h668h839h944hd25hd2bhf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1155h)
Date: Thu, 25 Jul 2013 17:34:23 +0800
From: Robin Gong <b38343@freescale.com>
To: Mark Brown <broonie@kernel.org>
CC: Shawn Guo <shawn.guo@linaro.org>, <grant.likely@linaro.org>,
        <rob.herring@calxeda.com>, <rob@landley.net>, <lgirdwood@gmail.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <s.trumtrar@pengutronix.de>
Subject: Re: [PATCH v5] regulator: pfuze100: add pfuze100 regulator driver
Message-ID: <20130725093422.GA10787@Robin-OptiPlex-780>
References: <1374723198-9716-1-git-send-email-b38343@freescale.com>
 <20130725084042.GA19368@S2101-09.ap.freescale.net>
 <20130725085809.GA10765@Robin-OptiPlex-780>
 <20130725091642.GT9858@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20130725091642.GT9858@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 25, 2013 at 10:16:42AM +0100, Mark Brown wrote:
> On Thu, Jul 25, 2013 at 04:58:10PM +0800, Robin Gong wrote:
> 
> > Shawn, I notice there are the same descriptions in the many docs of regulator
> > drivers, can we consider the 'regulators' child node as one of special property
> > ? Sorry for missing the information in the last mail.. 
> 
> No, it's just people using the wrong language to refer to them.
Ok, I will update the patch if there are no other comments. Thanks all.



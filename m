Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756734AbaAJCnO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 21:43:14 -0500
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:52836
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751632AbaAJCnM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 21:43:12 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(z579ehz98dI1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6hzz1de098h8275bh8275dh1de097hz2dh87h2a8h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h209eh2216h22d0h2336h2438h1151h1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Fri, 10 Jan 2014 10:44:03 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Nicolin Chen <Guangyu.Chen@freescale.com>
CC: <vinod.koul@intel.com>, <dan.j.williams@intel.com>,
        <kernel@pengutronix.de>, <fabio.estevam@freescale.com>,
        <dmaengine@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 1/2] Revert "ARM: dts: imx: use dual-fifo sdma script for
 ssi"
Message-ID: <20140110024359.GB6844@S2101-09.ap.freescale.net>
References: <1389170756-22351-1-git-send-email-Guangyu.Chen@freescale.com>
 <1389170756-22351-2-git-send-email-Guangyu.Chen@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1389170756-22351-2-git-send-email-Guangyu.Chen@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 08, 2014 at 04:45:55PM +0800, Nicolin Chen wrote:
> This reverts commit b1d27c79c8377df1880447375deffa3bb82c7bd3.
> 
> Previously we switched the SSI scriprt to dual-fifo mode to reduce playback
> underrun issue, which is only included by SDMA firmware version 2. However,
> there are quite a lot people still using version 1 or default firmware in
> the ROM code of SoC while these two kinds of firmwares do not support the
> dual-fifo script and the audio function on their platform would be broken.
> 
> Thus this patch provisionally reverts the dual-fifo script to the original
> single fifo script to meet all kinds of users' requirements, including the
> version 1/2 or inner ROM firmware.
> 
> Reported-by: Fabio Estevam <fabio.estevam@freescale.com>
> Signed-off-by: Nicolin Chen <Guangyu.Chen@freescale.com>

If Vinod's tree can be rebased, the patch can just be dropped.
Otherwise,

Acked-by: Shawn Guo <shawn.guo@linaro.org>


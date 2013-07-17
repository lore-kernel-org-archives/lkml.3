Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751212Ab3GQDuO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 23:50:14 -0400
Received: from mail-db9lp0249.outbound.messaging.microsoft.com ([213.199.154.249]:40630
	"EHLO db9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750864Ab3GQDuM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 23:50:12 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -1
X-BigFish: VS-1(z551biz98dI1432Izz1f42h1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzzz2dh87h2a8h668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1151h1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Wed, 17 Jul 2013 11:50:11 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Otavio Salvador <otavio@ossystems.com.br>
CC: Jonathan Cameron <jic23@kernel.org>, <linux-kernel@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 1/4] ARM: dts: imx23-evk: enable USB PHY and controller
Message-ID: <20130717035010.GC4541@S2101-09.ap.freescale.net>
References: <1373979376-31583-1-git-send-email-otavio@ossystems.com.br>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1373979376-31583-1-git-send-email-otavio@ossystems.com.br>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 16, 2013 at 09:56:12AM -0300, Otavio Salvador wrote:
> The i.MX23EVK board provides a USB port so the USB PHY and controller
> need to be enabled for it to be usable.
> 
> Signed-off-by: Otavio Salvador <otavio@ossystems.com.br>

There is a typo i.XM23 in commit log of patch #2 and #3.  I fixed them
up and applied all 3.

Shawn


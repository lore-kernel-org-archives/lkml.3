Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932169Ab3KFMX1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 07:23:27 -0500
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:13763 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756391Ab3KFMX0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 07:23:26 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(z579ehz98dIda00h1432Idc73hzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h1d1ah1d2ah1fc6hzz1de098h6d524h1de097hz2dh87h2a8h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h209eh2216h1151h1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Wed, 6 Nov 2013 20:24:02 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Wei Yongjun <weiyj.lk@gmail.com>
CC: <kernel@pengutronix.de>, <linux@arm.linux.org.uk>,
        <yongjun_wei@trendmicro.com.cn>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -next] ARM i.MX53: remove duplicated include from
 clk-imx51-imx53.c
Message-ID: <20131106122359.GA4352@S2101-09.ap.freescale.net>
References: <CAPgLHd9smv2Jcb7SUxKsXHqnDos53A3ZhVWPMSyDJckR9_URKQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAPgLHd9smv2Jcb7SUxKsXHqnDos53A3ZhVWPMSyDJckR9_URKQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 30, 2013 at 01:38:34PM +0800, Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> Remove duplicated include.
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Applied, thanks.


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752390Ab3JEC2P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 22:28:15 -0400
Received: from mail-db9lp0252.outbound.messaging.microsoft.com ([213.199.154.252]:5719
	"EHLO db9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751345Ab3JEC2O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 22:28:14 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zz98dI1432Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzzz2dh87h2a8h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h209eh1151h1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Sat, 5 Oct 2013 10:28:09 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Thierry Reding <thierry.reding@gmail.com>
CC: <linux-arm-kernel@lists.infradead.org>,
        Sascha Hauer <kernel@pengutronix.de>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: imx: Include linux/err.h
Message-ID: <20131005022806.GA3739@S2101-09.ap.freescale.net>
References: <1380542691-24756-1-git-send-email-treding@nvidia.com>
 <20131005022422.GF2734@S2101-09.ap.freescale.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20131005022422.GF2734@S2101-09.ap.freescale.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 05, 2013 at 10:24:23AM +0800, Shawn Guo wrote:
> On Mon, Sep 30, 2013 at 02:04:51PM +0200, Thierry Reding wrote:
> > The IS_ERR() macro is defined in the linux/err.h header file, so include
> > it explicitly.
> 
> Hmm, I can not find IS_ERR() in arch/arm/mach-imx/cpu.c

Sorry, I did not look at the correct tree.

Applied, thanks.

Shawn


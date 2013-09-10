Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754477Ab3IJHQb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 03:16:31 -0400
Received: from co9ehsobe004.messaging.microsoft.com ([207.46.163.27]:9009 "EHLO
	co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753497Ab3IJHQ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 03:16:29 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -1
X-BigFish: VS-1(zz98dI1432Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzd2iz1de098h1de097h8275bhz2dh87h2a8h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h209eh1151h1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Tue, 10 Sep 2013 15:16:40 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Michael Opdenacker <michael.opdenacker@free-electrons.com>,
        <kernel@pengutronix.de>, <linux@arm.linux.org.uk>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][RESEND] ARM: imx: remove IRQF_DISABLED
Message-ID: <20130910071636.GA7327@S2101-09.ap.freescale.net>
References: <1378271079-24945-1-git-send-email-michael.opdenacker@free-electrons.com>
 <20130910065838.GC30088@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20130910065838.GC30088@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 10, 2013 at 08:58:38AM +0200, Sascha Hauer wrote:
> On Wed, Sep 04, 2013 at 07:04:39AM +0200, Michael Opdenacker wrote:
> > This flag is a NOOP since 2.6.35 and can be removed.
> > 
> > This is an update for 3.11 of a patch already sent for 3.10
> > 
> > Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
> 
> (added shawn to Cc)
> 
> Acked-by: Sascha Hauer <s.hauer@pengutronix.de>

Applied, thanks.

Shawn


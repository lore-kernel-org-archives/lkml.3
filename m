Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751846Ab3HUB6v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 21:58:51 -0400
Received: from mail-db8lp0187.outbound.messaging.microsoft.com ([213.199.154.187]:1281
	"EHLO db8outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751556Ab3HUB6u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 21:58:50 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VS-3(zzbb2dI98dI1432Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzzz2dh87h2a8h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h1151h1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Wed, 21 Aug 2013 09:59:41 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Liu Ying <Ying.Liu@freescale.com>
CC: Philipp Zabel <p.zabel@pengutronix.de>, <kernel@pengutronix.de>,
        <gregkh@linuxfoundation.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <dri-devel@lists.freedesktop.org>
Subject: Re: [PATCH 0/3] refactor some ldb related clocks
Message-ID: <20130821015939.GD30533@S2101-09.ap.freescale.net>
References: <1376987932-5540-1-git-send-email-Ying.Liu@freescale.com>
 <1376991823.4000.22.camel@pizza.hi.pengutronix.de>
 <52134030.4030502@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <52134030.4030502@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ying,

On Tue, Aug 20, 2013 at 06:08:48PM +0800, Liu Ying wrote:
> > While I admit to having introduced the combination of 1/3.5 fixed
> > divider and configurable 1/1,1/2 divder clocks to describe this
> > fractional divider for the reasons you state, I think the correct
> > solution would be to improve the table divider to support fractional
> > values and get rid of the virtual ldb_di<n>_div_3_5 clocks, not
> > introduce more virtual clocks.
> 
> Yes, it's good to support fractional values for the table divider(not sure if there is any plan for this).
> I see there is something similar in 'include/linux/sh_clk.h'.

Yeah, I agree with Philipp on improving table divider to support
fractional values.  Would you like to work on that?

Shawn


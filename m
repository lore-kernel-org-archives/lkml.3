Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756267Ab3BSFbr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 00:31:47 -0500
Received: from co9ehsobe004.messaging.microsoft.com ([207.46.163.27]:32246
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755396Ab3BSFbp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 00:31:45 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -6
X-BigFish: VS-6(zzbb2dI98dI9371I1454I1432I1418Izz1f42h1ee6h1de0h1202h1e76h1d1ah1d2ahzzz2dh87h2a8h668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Tue, 19 Feb 2013 13:31:51 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Hiroshi Doyu <hdoyu@nvidia.com>, <linux-tegra@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>,
        Russell King <linux@arm.linux.org.uk>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 1/1] ARM: dt: add header to define tegra20 clocks
Message-ID: <20130219053148.GC3108@S2101-09.ap.freescale.net>
References: <1360791198-29462-1-git-send-email-swarren@wwwdotorg.org>
 <1360823899-17846-1-git-send-email-hdoyu@nvidia.com>
 <511D24D4.6070805@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <511D24D4.6070805@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 14, 2013 at 10:54:28AM -0700, Stephen Warren wrote:
> On 02/13/2013 11:38 PM, Hiroshi Doyu wrote:
> > To replace magic number in "clocks = <&tegra_car 28>;"
> 
> I like the concept here; I was thinking about doing this today, but you
> beat me to it:-) Feel free to create the Tegra30 header too, and modify
> all the *.dts* files.
> 
> To address other comments in this thread: Yes, I think that we will want
> to modify the clock driver to include this header to avoid
> duplication/errors (that will require adjusting Linux's include path),
> and also remove the list of IDs from the binding document; it can just
> refer the the new header by name and cause the header to *be* part of
> the binding document.

I like it, since doing so will help us hijack kernel to have dts stay
in the tree rather than going to a separate repository :)

Seriously, is maintaining dts in a separate repository still a plan?
If yes, we will have duplication problem someday anyway.

For reason of it, I vote for having dts stay in the kernel tree.

Shawn


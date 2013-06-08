Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751286Ab3FHDCm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 23:02:42 -0400
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:11298
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751059Ab3FHDCl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 23:02:41 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(z551biz98dI146fI1432Izz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzzz2dh87h2a8h668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1151h1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Sat, 8 Jun 2013 11:02:41 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Mike Turquette <mturquette@linaro.org>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <devicetree-discuss@lists.ozlabs.org>
Subject: Re: [PATCH RFC 0/3] clk: dt: bindings for mux & divider clocks
Message-ID: <20130608030240.GB22134@S2101-09.ap.freescale.net>
References: <1370281990-15090-1-git-send-email-mturquette@linaro.org>
 <20130607055128.GA20780@S2101-09.ap.freescale.net>
 <20130607175254.10233.7661@quantum>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20130607175254.10233.7661@quantum>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 07, 2013 at 10:52:54AM -0700, Mike Turquette wrote:
> Yes, there was a time when I was firmly against doing such a thing.
> However I'm not sure it is so bad now.  More and more SoCs are going to
> keep getting merged into the kernel and that just means more and more
> clock data.  Perhaps DT is best suited to handle this bloat.  I broke
> the clock data out into a separate file so that it didn't overwhelm the
> existing omap4.dtsi.

I'm actually more concerned by run-time impact.  Any of_find_node_*()
call will possibly have to scan all those hundreds of nodes to find the
desired one.  Anyway, it's an OMAP folks decision, and the impact might
not be that much on those fast CPUs.

Shawn

> 
> Either way I marked this series as RFC precisely due to your point.  I
> want feedback on how the OMAP folks feel about this.  So far no has has
> NACKed it ;-)


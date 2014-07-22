Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756340AbaGVSxq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 14:53:46 -0400
Received: from utopia.booyaka.com ([74.50.51.50]:53943 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751185AbaGVSxo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 14:53:44 -0400
Date: Tue, 22 Jul 2014 18:53:43 +0000 (UTC)
From: Paul Walmsley <paul@pwsan.com>
To: Tony Lindgren <tony@atomide.com>
cc: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
        Mugunthan V N <mugunthanvnm@ti.com>, devicetree@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>, Rajendra Nayak <rnayak@ti.com>,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [Re-send PATCH 1/1] arm: dra7xx: Add hwmod data for MDIO and
 CPSW
In-Reply-To: <20140717075028.GG18374@atomide.com>
Message-ID: <alpine.DEB.2.02.1407221853340.25593@utopia.booyaka.com>
References: <1404825399-10330-1-git-send-email-mugunthanvnm@ti.com> <20140709095552.GA25154@breakpoint.cc> <20140709100147.GB25154@breakpoint.cc> <alpine.DEB.2.02.1407152019020.21432@utopia.booyaka.com> <20140716070643.GC3378@breakpoint.cc>
 <alpine.DEB.2.02.1407161854360.23074@utopia.booyaka.com> <20140717075028.GG18374@atomide.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Jul 2014, Tony Lindgren wrote:

> * Paul Walmsley <paul@pwsan.com> [140716 11:59]:
> > On Wed, 16 Jul 2014, Sebastian Andrzej Siewior wrote:
> > 
> > > On 2014-07-15 20:21:21 [+0000], Paul Walmsley wrote:
> > > 
> > > > > Acked-by: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
> > > > > 
> > > > > This is basically what Tony hasked me to do: No IRQ numbers & iomem.
> > > > 
> > > > Sorry - I'm a bit confused - Sebastian, did you test this one?  If so, is 
> > > > it okay to add a Tested-by from you?
> > > 
> > > Tested-by: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
> > 
> > Thanks Sebastian.
> > 
> > Mugunthan, next step would be for you to get a Reviewed-by: by someone who 
> > has access to the (non-public) DRA7xx TRM, and can review for SoC 
> > integration.  Since Rajendra is no longer at TI, the right person is 
> > probably Tony.
> > 
> > Then this patch should be mergeable.
> 
> Yeah took a look at it and acked it.

Thanks queued for 3.17.


- Paul

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754778AbaGQHv5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 03:51:57 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:44913 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753452AbaGQHvy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 03:51:54 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+CYa7yi2z3mEOZQkydrrW6
Date: Thu, 17 Jul 2014 00:50:29 -0700
From: Tony Lindgren <tony@atomide.com>
To: Paul Walmsley <paul@pwsan.com>
Cc: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
        Mugunthan V N <mugunthanvnm@ti.com>, devicetree@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>, Rajendra Nayak <rnayak@ti.com>,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [Re-send PATCH 1/1] arm: dra7xx: Add hwmod data for MDIO and CPSW
Message-ID: <20140717075028.GG18374@atomide.com>
References: <1404825399-10330-1-git-send-email-mugunthanvnm@ti.com>
 <20140709095552.GA25154@breakpoint.cc>
 <20140709100147.GB25154@breakpoint.cc>
 <alpine.DEB.2.02.1407152019020.21432@utopia.booyaka.com>
 <20140716070643.GC3378@breakpoint.cc>
 <alpine.DEB.2.02.1407161854360.23074@utopia.booyaka.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1407161854360.23074@utopia.booyaka.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Paul Walmsley <paul@pwsan.com> [140716 11:59]:
> On Wed, 16 Jul 2014, Sebastian Andrzej Siewior wrote:
> 
> > On 2014-07-15 20:21:21 [+0000], Paul Walmsley wrote:
> > 
> > > > Acked-by: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
> > > > 
> > > > This is basically what Tony hasked me to do: No IRQ numbers & iomem.
> > > 
> > > Sorry - I'm a bit confused - Sebastian, did you test this one?  If so, is 
> > > it okay to add a Tested-by from you?
> > 
> > Tested-by: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
> 
> Thanks Sebastian.
> 
> Mugunthan, next step would be for you to get a Reviewed-by: by someone who 
> has access to the (non-public) DRA7xx TRM, and can review for SoC 
> integration.  Since Rajendra is no longer at TI, the right person is 
> probably Tony.
> 
> Then this patch should be mergeable.

Yeah took a look at it and acked it.

Tony

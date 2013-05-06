Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754783Ab3EFP1M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 11:27:12 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:17773 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753874Ab3EFP1K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 11:27:10 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18PsXeUvW5yOocCr84uEZXO
Date: Mon, 6 May 2013 08:27:06 -0700
From: Tony Lindgren <tony@atomide.com>
To: "Hiremath, Vaibhav" <hvaibhav@ti.com>
Cc: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: mach-omap2/timer.c: Bug introduced while merging patch -
 ff931c82
Message-ID: <20130506152706.GD28721@atomide.com>
References: <79CD15C6BA57404B839C016229A409A83EC7C45D@DBDE04.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <79CD15C6BA57404B839C016229A409A83EC7C45D@DBDE04.ent.ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Hiremath, Vaibhav <hvaibhav@ti.com> [130506 00:12]:
> Hi,
> 
> Not sure whether this got discussed and fixed already, but Google didn't give me anything :)
> 
> The below commit got merged wrongly to Mainline (Changes from timer.c got missed), and 
> due to this none of omap boards will boot.
> 
> 
> From ff931c821bab6713a52b768b0cd7ee7e90713b36 Mon Sep 17 00:00:00 2001
> From: Rajendra Nayak <rnayak@ti.com>
> Date: Thu, 21 Mar 2013 11:04:52 +0000
> Subject: ARM: OMAP: clocks: Delay clk inits atleast until slab is initialized
> 
> 
> It seems Linux-omap tree has the fix patch for this, and it should get pushed ASAP. 
> Below are links for Linus's mainline commit [1], the actual patch submitted to the list [2] and
> Commit  present in Linux-omap [3].

Can you please provide a proper patch for the regression since sounds
like you already figured out what happened?

Regards,

Tony 
 
> [1] http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/arch/arm/mach-omap2/io.c?id=ff931c821bab6713a52b768b0cd7ee7e90713b36
> [2] https://patchwork.kernel.org/patch/2300071/
> [3] http://git.kernel.org/cgit/linux/kernel/git/tmlind/linux-omap.git/commit/arch/arm/mach-omap2/timer.c?id=ff931c821bab6713a52b768b0cd7ee7e90713b36

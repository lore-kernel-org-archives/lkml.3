Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757598Ab3APCAd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 21:00:33 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:36633 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756414Ab3APCA3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 21:00:29 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 72.84.113.162
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+3gppQIOK5xK+tuvWuOpBF7rbiVz+l40g=
Date: Tue, 15 Jan 2013 21:00:24 -0500
From: Jason Cooper <jason@lakedaemon.net>
To: Mike Turquette <mturquette@linaro.org>
Cc: Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Cong Ding <dinggnu@gmail.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        linux-kernel@vger.kernel.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3] clk: mvebu/clk-cpu.c: fix memory leakage
Message-ID: <20130116020024.GG25500@titan.lakedaemon.net>
References: <1358183892-28928-1-git-send-email-dinggnu@gmail.com>
 <50F563EC.3030804@free-electrons.com>
 <20130115152307.GA25615@gmail.com>
 <20130115153716.GF13433@titan.lakedaemon.net>
 <50F584F5.6030007@free-electrons.com>
 <20130115182629.GB7211@gmail.com>
 <50F5A1A9.2030803@free-electrons.com>
 <20130115184423.GC7211@gmail.com>
 <50F5C00B.10108@free-electrons.com>
 <20130116010143.8920.90024@quantum>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130116010143.8920.90024@quantum>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 15, 2013 at 05:01:43PM -0800, Mike Turquette wrote:
> Quoting Gregory CLEMENT (2013-01-15 12:46:03)
> > On 01/15/2013 07:44 PM, Cong Ding wrote:
> > > the variable cpuclk and clk_name should be properly freed when error happens.
> > Dear Cong Ding,
> > 
> > Thanks for you efforts!
> > I am happy with this patch and I tested it on the Armada XP DB board, so
> > you can now add my:
> > 
> > Acked-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
> > 
> > Mike,
> > 
> > could you take this patch for 3.8-rc fixes?
> > 
> > If you prefer, Jason agrees to take it, but you probably didn't notice it,
> > because he uses your former(and no more valid) email when he wrote this.
> > 
> 
> Acked-by: Mike Turquette <mturquette@linaro.org>
> 
> I don't have an existing clk-fixes branch.  This patch is the first fix
> I've reviewed for this cycle.  I'm happy if you want to take it and
> submit as part of any other mvebu fixes you have.  Otherwise I can take
> it.

I'll take it, no problem.  Thanks for the Ack Mike,

Jason.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754997AbaADSSM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jan 2014 13:18:12 -0500
Received: from one.firstfloor.org ([193.170.194.197]:57304 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751359AbaADSSK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jan 2014 13:18:10 -0500
Date: Sat, 4 Jan 2014 19:18:07 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Ben Hutchings <ben@decadent.org.uk>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@rostedt.homelinux.com>, 723180@bugs.debian.org,
        Brian Silverman <bsilver16384@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-rt-users@vger.kernel.org,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] Revert "x86: Disable IST stacks for debug/int 3/stack
 fault for PREEMPT_RT"
Message-ID: <20140104181807.GS20765@two.firstfloor.org>
References: <20130917061329.4872.51468.reportbug@dell-inspiron-linux.dlinkrouter>
 <1379427451.23881.48.camel@deadeye.wl.decadent.org.uk>
 <CAP01z6LVxoA6kDJeL8NuO2aA22BjMvXSk9ZY7z9cOK1=k56vpg@mail.gmail.com>
 <1379905562.3913.8.camel@deadeye.wl.decadent.org.uk>
 <CAP01z6+j6moUio9pc3G3iz+ebJCdKEvngddxnxazRP+NXwLkyg@mail.gmail.com>
 <1380115449.4430.21.camel@deadeye.wl.decadent.org.uk>
 <52AE0419.3050103@linutronix.de>
 <20140103135548.GA6327@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140103135548.GA6327@linutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 03, 2014 at 02:55:48PM +0100, Sebastian Andrzej Siewior wrote:
> where do I start. Let me explain what is going on here. The code
> sequence

Yes the IST stacks are needed for correctness, even in more cases than
the example below. You cannot just disable them, just because you don't
like them.

-Andi

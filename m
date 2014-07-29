Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754219AbaG2UlI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 16:41:08 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:40476 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751693AbaG2UlF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 16:41:05 -0400
Date: Tue, 29 Jul 2014 13:41:00 -0700
From: Brian Norris <computersforpeace@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Dmitry Torokhov <dtor@google.com>
Subject: Re: [RFC][PATCH] irq: Rework IRQF_NO_SUSPENDED
Message-ID: <20140729204100.GI3711@ld-irv-0074>
References: <20140724212620.GO3935@laptop>
 <13290270.IfKaUSRMLR@vostro.rjw.lan>
 <20140725055847.GQ3935@laptop>
 <20140729192008.GH3711@ld-irv-0074>
 <20140729192843.GP3935@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140729192843.GP3935@laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 29, 2014 at 09:28:43PM +0200, Peter Zijlstra wrote:
> On Tue, Jul 29, 2014 at 12:20:08PM -0700, Brian Norris wrote:
> 
> > I'm curious what you mean. Are you referring to the fact that its input
> > is simply an IRQ number (regardless of whether the IRQ is shared), not
> > something that identifies the particular handler (e.g., struct
> > irqaction)?
> 
> Yes. I know that shared stuff is a massive head-ache, but I feel we
> should not introduce primitives that do not work with it.

Thanks for the reply. I could also have just read the rest of the thread
[1], in which this very question was addressed already. Shame on me.

Brian

[1] https://lkml.org/lkml/2014/7/28/60

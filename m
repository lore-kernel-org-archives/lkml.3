Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757342AbaKTANc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 19:13:32 -0500
Received: from mail-wi0-f179.google.com ([209.85.212.179]:35819 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756974AbaKTANa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 19:13:30 -0500
Date: Thu, 20 Nov 2014 01:13:27 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Chuck Ebbert <cebbert.lkml@gmail.com>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [PATCH 3.17 00/25] 3.17.1-stable review
Message-ID: <20141120001324.GA11882@lerouge>
References: <20141013022454.289398272@linuxfoundation.org>
 <20141013112834.GA10826@khazad-dum.debian.net>
 <20141013082319.175d90bb@as>
 <20141119172235.GA31260@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141119172235.GA31260@kroah.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 19, 2014 at 09:22:35AM -0800, Greg Kroah-Hartman wrote:
> > From a80e49e2cc3145af014a8ae44f575829cc236192 Mon Sep 17 00:00:00 2001
> > From: Frederic Weisbecker <fweisbec@gmail.com>
> > Subject: nohz: Move nohz full init call to tick init
> > 
> > From c5c38ef3d70377dc504a6a3f611a3ec814bc757b Mon Sep 17 00:00:00 2001
> > From: Peter Zijlstra <peterz@infradead.org>
> > Subject: irq_work: Introduce arch_irq_work_has_interrupt()
> > 
> > From 76a33061b9323b7fdb220ae5fa116c10833ec22e Mon Sep 17 00:00:00 2001
> > From: Frederic Weisbecker <fweisbec@gmail.com>
> > Subject: irq_work: Force raised irq work to run on irq work interrupt
> > 
> > From 3010279f0fc36f0388872203e63ca49912f648fd Mon Sep 17 00:00:00 2001
> > From: Frederic Weisbecker <fweisbec@gmail.com>
> > Subject: x86: Tell irq work about self IPI support
> > 
> > From 09f6edd424218eb69078551b2ecfada1f2d098eb Mon Sep 17 00:00:00 2001
> > From: Frederic Weisbecker <fweisbec@gmail.com>
> > Subject: arm: Tell irq work about self IPI support
> > 
> > From 3631073659d0aafeaa52227bb61a100efaf901dc Mon Sep 17 00:00:00 2001
> > From: Frederic Weisbecker <fweisbec@gmail.com>
> > Subject: arm64: Tell irq work about self IPI support
> 
> These are pretty intrusive, maybe 3.18 is better for people to use :)
> 
> If Frederic says it's ok for me to backport these, I will, but I want
> his ack first.

Ah, not the whole lot is needed, only these (in the order):

irq_work: Introduce arch_irq_work_has_interrupt()
irq_work: Force raised irq work to run on irq work interrupt
x86: Tell irq work about self IPI support
arm: Tell irq work about self IPI support

You've applied them on your previous 3.17-stable release. They
just lacked stable tags upstream because we decided to backport them
after they got merged so you cherry-picked them directly :-)


Thanks!

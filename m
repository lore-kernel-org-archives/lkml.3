Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754287AbaJNBbJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 21:31:09 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36023 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754142AbaJNBbI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 21:31:08 -0400
Date: Tue, 14 Oct 2014 03:30:05 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Chuck Ebbert <cebbert.lkml@gmail.com>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>, linux-kernel@vger.kernel.org,
        stable@kernel.org
Subject: Re: [PATCH 3.17 00/25] 3.17.1-stable review
Message-ID: <20141014013005.GC17932@kroah.com>
References: <20141013022454.289398272@linuxfoundation.org>
 <20141013112834.GA10826@khazad-dum.debian.net>
 <20141013082319.175d90bb@as>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141013082319.175d90bb@as>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 13, 2014 at 08:23:19AM -0500, Chuck Ebbert wrote:
> Stalls when using nohz, requires series of six patches to fix that
> didn't make 3.17 and weren't marked for -stable:
> 
> From a80e49e2cc3145af014a8ae44f575829cc236192 Mon Sep 17 00:00:00 2001
> From: Frederic Weisbecker <fweisbec@gmail.com>
> Subject: nohz: Move nohz full init call to tick init
> 
> From c5c38ef3d70377dc504a6a3f611a3ec814bc757b Mon Sep 17 00:00:00 2001
> From: Peter Zijlstra <peterz@infradead.org>
> Subject: irq_work: Introduce arch_irq_work_has_interrupt()
> 
> From 76a33061b9323b7fdb220ae5fa116c10833ec22e Mon Sep 17 00:00:00 2001
> From: Frederic Weisbecker <fweisbec@gmail.com>
> Subject: irq_work: Force raised irq work to run on irq work interrupt
> 
> From 3010279f0fc36f0388872203e63ca49912f648fd Mon Sep 17 00:00:00 2001
> From: Frederic Weisbecker <fweisbec@gmail.com>
> Subject: x86: Tell irq work about self IPI support
> 
> From 09f6edd424218eb69078551b2ecfada1f2d098eb Mon Sep 17 00:00:00 2001
> From: Frederic Weisbecker <fweisbec@gmail.com>
> Subject: arm: Tell irq work about self IPI support

I have all of these in 3.17.1-rc1.

> From 3631073659d0aafeaa52227bb61a100efaf901dc Mon Sep 17 00:00:00 2001
> From: Frederic Weisbecker <fweisbec@gmail.com>
> Subject: arm64: Tell irq work about self IPI support

This one I missed, probably because no one actually has a arm64 machine
that is "public" :)

I'll go queue that one up now, thanks.

greg k-h

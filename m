Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754385Ab3ITVqs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 17:46:48 -0400
Received: from www.linutronix.de ([62.245.132.108]:44039 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752249Ab3ITVqq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 17:46:46 -0400
Date: Fri, 20 Sep 2013 23:46:42 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Guenter Roeck <linux@roeck-us.net>
cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>, linux-arch@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andi Kleen <ak@linux.intel.com>, Peter Anvin <hpa@zytor.com>,
        Mike Galbraith <bitbucket@online.de>, Arjanvan@roeck-us.net
Subject: Re: [patch 2/6] h8300: Use schedule_preempt_irq
In-Reply-To: <20130920174144.GA30356@roeck-us.net>
Message-ID: <alpine.DEB.2.02.1309202346212.4089@ionos.tec.linutronix.de>
References: <20130917082838.218329307@infradead.org> <20130917182350.449685712@linutronix.de> <20130917183628.646285522@linutronix.de> <20130920174144.GA30356@roeck-us.net>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Sep 2013, Guenter Roeck wrote:

> On Tue, Sep 17, 2013 at 06:53:06PM -0000, Thomas Gleixner wrote:
> > Use the proper function instead of fiddling with PREEMPT_ACTIVE and
> > interrupt enable/disable in the low level code.
> > 
> > Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> > Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
> > Cc: Geert Uytterhoeven <geert@linux-m68k.org>
> > 
> This will result in a conflict in -next as h8300 support has been removed
> there, and I'll send a pull request to Linus in the next commit window.

An easy to resolve one methinks :)

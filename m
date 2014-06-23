Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753269AbaFWIsR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 04:48:17 -0400
Received: from www.linutronix.de ([62.245.132.108]:41381 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750820AbaFWIsO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 04:48:14 -0400
Date: Mon, 23 Jun 2014 10:48:00 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [tip:timers/core] time/timers: Move all time(r) related files
 into kernel/time
In-Reply-To: <CAFTL4hyhsgiXdZN4modTAYU8G3X7RULuR-d=CzrY3gmPEZ0w8Q@mail.gmail.com>
Message-ID: <alpine.DEB.2.10.1406231044570.5170@nanos>
References: <tip-33ee255196f8de7407012217e5fa7897555dd034@git.kernel.org> <CAFTL4hyhsgiXdZN4modTAYU8G3X7RULuR-d=CzrY3gmPEZ0w8Q@mail.gmail.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Jun 2014, Frederic Weisbecker wrote:
> > +       if (!hrtimer_is_hres_active(timer)) {
> > +               /*
> > +                * Kick to reschedule the next tick to handle the new
> timer
> > +                * on dynticks target.
> > +                */
> > +               wake_up_nohz_cpu(base->cpu_base->cpu);

Proper quoting is overrdated, right. I almost missed your comment.
 
> Are you sure that you intended to integrate these unrelated changes in this
> patch?
> 
> Or may be you applied my patches before but I can't see them. And you
> reported at least an issue.

Hrmm. No idea how that happened. I zapped your commits. Lemme redo.

Thanks,

	tglx

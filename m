Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753526AbaCaPvm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 11:51:42 -0400
Received: from www.linutronix.de ([62.245.132.108]:33724 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751982AbaCaPvl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 11:51:41 -0400
Date: Mon, 31 Mar 2014 17:51:51 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Viresh Kumar <viresh.kumar@linaro.org>
cc: Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        =?ISO-8859-15?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
        Linaro Networking <linaro-networking@linaro.org>,
        Arvind Chauhan <Arvind.Chauhan@arm.com>
Subject: Re: [PATCH 00/16] timers/hrtimers: Minor cleanups: Part II
In-Reply-To: <CAKohpon3VKU=E7LEYFRN=4jDnxU8+t_mR4K-NkBRY0Tzup=-5g@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1403311749500.14882@ionos.tec.linutronix.de>
References: <cover.1396006658.git.viresh.kumar@linaro.org> <alpine.DEB.2.02.1403311522080.14882@ionos.tec.linutronix.de> <CAKohpon3VKU=E7LEYFRN=4jDnxU8+t_mR4K-NkBRY0Tzup=-5g@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 31 Mar 2014, Viresh Kumar wrote:
> On 31 March 2014 19:08, Thomas Gleixner <tglx@linutronix.de> wrote:
> > And those cleanups make the compiler generate worse code at least on
> > x86_64:
> >
> >    text      data      bss      dec     hex    filename
> >    7475      554       0        8029    1f5d   kernel/hrtimer.o
> >    7706      554       0        8260    2044   kernel/hrtimer.o
> >
> > So just removing parameters and return values because you can get the
> > same information from a datastructure is not necessarily a good thing.
> 
> Hmm.. Nice.
> 
> Okay, I will have another look at patches and do this kind of investigation
> before sending it next time :) Its been fun going through these frameworks.
> 
> How do you want to proceed now? I mean, you will take the other patches
> (which don't play with function parameters) as is or want me to send a single
> unified patchset with all the pending patches that I have?

I still want to go through the lot and review them, but I wont take
anything before the end of the merge window.

Thanks,

	tglx

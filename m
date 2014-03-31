Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753454AbaCaObT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 10:31:19 -0400
Received: from mail-ob0-f173.google.com ([209.85.214.173]:62487 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752533AbaCaObS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 10:31:18 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1403311522080.14882@ionos.tec.linutronix.de>
References: <cover.1396006658.git.viresh.kumar@linaro.org>
	<alpine.DEB.2.02.1403311522080.14882@ionos.tec.linutronix.de>
Date: Mon, 31 Mar 2014 20:01:17 +0530
Message-ID: <CAKohpon3VKU=E7LEYFRN=4jDnxU8+t_mR4K-NkBRY0Tzup=-5g@mail.gmail.com>
Subject: Re: [PATCH 00/16] timers/hrtimers: Minor cleanups: Part II
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
        Linaro Networking <linaro-networking@linaro.org>,
        Arvind Chauhan <Arvind.Chauhan@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31 March 2014 19:08, Thomas Gleixner <tglx@linutronix.de> wrote:
> And those cleanups make the compiler generate worse code at least on
> x86_64:
>
>    text      data      bss      dec     hex    filename
>    7475      554       0        8029    1f5d   kernel/hrtimer.o
>    7706      554       0        8260    2044   kernel/hrtimer.o
>
> So just removing parameters and return values because you can get the
> same information from a datastructure is not necessarily a good thing.

Hmm.. Nice.

Okay, I will have another look at patches and do this kind of investigation
before sending it next time :) Its been fun going through these frameworks.

How do you want to proceed now? I mean, you will take the other patches
(which don't play with function parameters) as is or want me to send a single
unified patchset with all the pending patches that I have?

Thanks for your support :)

--
viresh

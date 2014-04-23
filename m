Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752019AbaDWLMi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 07:12:38 -0400
Received: from mail-ob0-f171.google.com ([209.85.214.171]:43633 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751102AbaDWLMg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 07:12:36 -0400
MIME-Version: 1.0
In-Reply-To: <20140415093002.GL1877@localhost.localdomain>
References: <20140410143857.GA27654@localhost.localdomain>
	<CAKohpomMhpGsYGafr5uZ0QgO0MEndqDA4G=4syhus4sZW3d8cg@mail.gmail.com>
	<20140411145333.GC3438@localhost.localdomain>
	<20140411151825.GX11096@twins.programming.kicks-ass.net>
	<CAKohpomgv-LbUcPxazfJkf0Jq0sSULxT0WjrbFovn0k0O-ORwg@mail.gmail.com>
	<20140414110245.GG11096@twins.programming.kicks-ass.net>
	<CAKohpo==1=K0=gZz_Z_Y0zO2PtyvA-Q67_+VKTJN7kbQgbiHTg@mail.gmail.com>
	<20140414114744.GI11096@twins.programming.kicks-ass.net>
	<CAKohpon=_ZR+QbfacGT+G_atgcc21KMYG3YxPf0nkSDLBH8Q2A@mail.gmail.com>
	<20140414120600.GJ11096@twins.programming.kicks-ass.net>
	<20140415093002.GL1877@localhost.localdomain>
Date: Wed, 23 Apr 2014 16:42:35 +0530
Message-ID: <CAKohpomKLyK0XZbB2j1Gjxe123b6JkcdSTpvdFFD23Hb_EmmpA@mail.gmail.com>
Subject: Re: [Query]: tick-sched: why don't we stop tick when we are running
 idle task?
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15 April 2014 15:00, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> Ok, I'm a bit buzy with a conference right now but I'm going to summarize that
> soonish.

Are you back now ?

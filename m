Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755031AbaIPU02 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 16:26:28 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:14084 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751966AbaIPU01 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 16:26:27 -0400
Date: Tue, 16 Sep 2014 16:26:25 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: Jan Kara <jack@suse.cz>, Geert Uytterhoeven <geert@linux-m68k.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] printk: git rid of [sched_delayed] message for
 printk_deferred
Message-ID: <20140916162625.4b55732a@gandalf.local.home>
In-Reply-To: <20140916191740.GA24243@x4>
References: <20140914050905.GA296@x4>
	<20140914055450.GB296@x4>
	<CAMuHMdUmqvN3GZzfjjHc5W2Dxgx2b0gzVHFUR8P8yUs5iFt_tA@mail.gmail.com>
	<20140915163740.GA12408@x4>
	<20140916105547.GA1205@quack.suse.cz>
	<20140916144252.GB32118@x4>
	<20140916111331.14303381@gandalf.local.home>
	<20140916152046.GC32118@x4>
	<20140916151415.4c646cbc@gandalf.local.home>
	<20140916191740.GA24243@x4>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Sep 2014 21:17:40 +0200
Markus Trippelsdorf <markus@trippelsdorf.de> wrote:

> On 2014.09.16 at 15:14 -0400, Steven Rostedt wrote:
> > On Tue, 16 Sep 2014 17:20:46 +0200
> > Markus Trippelsdorf <markus@trippelsdorf.de> wrote:
> > 
> > > On 2014.09.16 at 11:13 -0400, Steven Rostedt wrote
> > > I'll leave it to you. This is just a cosmetic issue, so there's no need
> > > to fix this immediately.
> > > 
> > 
> > Actually the fix is much simpler (I had to wait for the drugs to wear
> > off before I noticed this ;-):
> 
> Well, the list is not complete:

Thanks! I'll update it.

-- Steve

> 
>  linux % git grep printk_deferred
> ...
> kernel/time/clockevents.c:              printk_deferred(KERN_WARNING
> kernel/time/clockevents.c:      printk_deferred(KERN_WARNING
> kernel/time/ntp.c:              printk_deferred(KERN_ERR
> kernel/time/ntp.c:              printk_deferred(KERN_WARNING
> kernel/time/ntp.c:              printk_deferred(KERN_WARNING
> kernel/time/ntp.c:              printk_deferred(KERN_ERR "hardpps: PPSJITTER: bad pulse\n");
> kernel/time/timekeeping.c:              printk_deferred(KERN_WARNING
> 


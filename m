Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752525Ab3BIHwb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2013 02:52:31 -0500
Received: from mail-pa0-f53.google.com ([209.85.220.53]:50926 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752186Ab3BIHwa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2013 02:52:30 -0500
Subject: Re: Kernel code interrupted by Timer
From: anish kumar <anish198519851985@gmail.com>
To: Peter Teoh <htmldeveloper@gmail.com>
Cc: Gaurav Jain <gjainroorkee@gmail.com>,
        Kernel Newbies <kernelnewbies@kernelnewbies.org>,
        linux-kernel@vger.kernel.org
In-Reply-To: <CAHnt0GVvhROgJ2=ekPY8syB5p0Vkb9A1jLHtt1Uyvi2-7CiJmw@mail.gmail.com>
References: <CAAFF8wQLm-DDq=knZJUgXVSNnUL4WOcXH9=17a-UesD3P5AB-Q@mail.gmail.com>
	 <1360388827.582.122.camel@anish-Inspiron-N5050>
	 <CAHnt0GVvhROgJ2=ekPY8syB5p0Vkb9A1jLHtt1Uyvi2-7CiJmw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 09 Feb 2013 13:21:56 +0530
Message-ID: <1360396316.582.128.camel@anish-Inspiron-N5050>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-02-09 at 14:57 +0800, Peter Teoh wrote:
> 
> 
> On Sat, Feb 9, 2013 at 1:47 PM, anish kumar 
> .
>         Timer interrupts is supposed to cause scheduling and scheduler
>         may or
>         may not pick up your last process(we always use the term
>         "task" in
>         kernel space) after handling timer interrupt.
>         >
>         
> 
> 
> Sorry if I may disagree, correct me if wrong.   Timer interrupt and
> scheduler is two different thing.   I just counted in the "drivers"
> subdirectory, there are at least more than 200 places where
> "setup_timer()" is called, and these have nothing to do with
> scheduling.   For eg, heartbeat operation etc.  Not sure I
> misunderstood something?
Have a look at kernel/timer.c and kernel/hrtimer.c.
There are many sched() calls in these files.This will invoke scheduler.
> 
> 
> -- 
> Regards,
> Peter Teoh



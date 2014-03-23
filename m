Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752102AbaCWOFe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2014 10:05:34 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:56573 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751465AbaCWOFc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2014 10:05:32 -0400
MIME-Version: 1.0
In-Reply-To: <1395572478.74811.YahooMailNeo@web141601.mail.bf1.yahoo.com>
References: <1395223046.28757.YahooMailNeo@web141601.mail.bf1.yahoo.com>
	<1395228430.4896.6.camel@marge.simpson.net>
	<1395228843.40159.YahooMailNeo@web141603.mail.bf1.yahoo.com>
	<CAJ__M-3RTLqU5MBVDGkXXw7cGriRCtfcb3pnMwGpXuJPMxeYHw@mail.gmail.com>
	<1395259275.22551.YahooMailNeo@web141602.mail.bf1.yahoo.com>
	<1395282203.11039.24.camel@marge.simpson.net>
	<1395572478.74811.YahooMailNeo@web141601.mail.bf1.yahoo.com>
Date: Sun, 23 Mar 2014 07:05:32 -0700
Message-ID: <CAK2H+edMBcJhqe8=hQvCRYAm6GsqnoqwqU5By_FD6qMyoXvCjQ@mail.gmail.com>
Subject: Re: Thread Scheduler
From: Mark Knecht <markknecht@gmail.com>
To: Mahmood Naderan <nt_mahmood@yahoo.com>
Cc: Mike Galbraith <umgwanakikbuti@gmail.com>,
        Jack Carrozzo <jack@crepinc.com>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 23, 2014 at 4:01 AM, Mahmood Naderan <nt_mahmood@yahoo.com> wrote:
>
>
>
>
>
>
>>On Thursday, March 20, 2014 6:53 AM, Mike Galbraith <umgwanakikbuti@gmail.com> wrote:
>>
>>marge:~ # man -k setscheduler getscheduler
>>sched_setscheduler (2) - set and get scheduling policy/parameters
>>sched_setscheduler (3p) - set scheduling policy and parameters (REALTIME)
>>sched_getscheduler (2) - set and get scheduling policy/parameters
>>sched_getscheduler (3p) - get scheduling policy (REALTIME)
>
>
>
>
>
> OK I read them and it seems that in order to change the scheduler, I have to write a C code and call the sched_set* functions. Please correct that if I am wrong.
>
> So in order to use my custom scheduler, I have to do the following steps.
>
> 1- Write my  code using the APIs and save that in kernel/sched_custom.c
> 2- Invoke sched_custom.c in kernel/sched.c
> 3- Recompile the kernel source
> 4- Reboot using the new kernel
> 5- write a C code and call sched_setschedule() to use my scheduler.
>
> Is that all? Your reply is appreciated.
>
>
> Regards,
> Mahmood
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

In terms of changing the scheduler I think that you possibly missed
reading Documentation/block/switching-sched.txt in the kernel's
documentation directory.

HTH,
Mark

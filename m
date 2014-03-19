Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933908AbaCSMG6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 08:06:58 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:50965 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758764AbaCSMG5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 08:06:57 -0400
MIME-Version: 1.0
In-Reply-To: <1395228843.40159.YahooMailNeo@web141603.mail.bf1.yahoo.com>
References: <1395223046.28757.YahooMailNeo@web141601.mail.bf1.yahoo.com>
	<1395228430.4896.6.camel@marge.simpson.net>
	<1395228843.40159.YahooMailNeo@web141603.mail.bf1.yahoo.com>
Date: Wed, 19 Mar 2014 08:06:57 -0400
Message-ID: <CAJ__M-3RTLqU5MBVDGkXXw7cGriRCtfcb3pnMwGpXuJPMxeYHw@mail.gmail.com>
Subject: Re: Thread Scheduler
From: Jack Carrozzo <jack@crepinc.com>
To: Mahmood Naderan <nt_mahmood@yahoo.com>
Cc: Mike Galbraith <umgwanakikbuti@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 19, 2014 at 7:34 AM, Mahmood Naderan <nt_mahmood@yahoo.com> wrote:
>
> [...]
> Do you mean include/linux/sched.h ?
> Where is he implementation then?

Your kernel source is incomplete. You can fetch a vanilla kernel
tarball from http://kernel.org.

jackc@kdev0 ~ $ ls /usr/src/linux-2.6.10/kernel/|grep sched
sched.c
jackc@kdev0 ~ $ ls /usr/src/linux-3.13.5/kernel/sched/
auto_group.c  completion.c  cpuacct.h  cputime.c  features.h   proc.c
 stats.c      wait.c
auto_group.h  core.c        cpupri.c   debug.c    idle_task.c  rt.c     stats.h
clock.c       cpuacct.c     cpupri.h   fair.c     Makefile     sched.h
 stop_task.c

-J

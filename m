Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754476Ab3J2LYG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 07:24:06 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:58589 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751349Ab3J2LYE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 07:24:04 -0400
MIME-Version: 1.0
Date: Tue, 29 Oct 2013 19:24:02 +0800
Message-ID: <CAGdX0WFXXhV9sb8Uxjfpizz3xLDBMoUrWBsjubOW6S2pN7Q_kw@mail.gmail.com>
Subject: [ANNOUNCE] ktap 0.3 released
From: Jovi Zhangwei <jovi.zhangwei@gmail.com>
To: ktap@freelists.org
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear,

I'm pleased to announce that ktap released v0.3, the archive is available at:

        https://github.com/ktap/ktap/archive/v0.3.tar.gz


= what's ktap?

   A New Script-based Dynamic Tracing Tool For Linux

   ktap have different design principles from Linux mainstream dynamic
   tracing language in that it's based on bytecode, so it doesn't
   depend upon GCC, doesn't require compiling kernel module for each
   script, safe to use in production environment, fulfilling the embedded
   ecosystem's tracing needs.

   ktap is released as GPL license.

   More information can be found at ktap/doc directory.

   Website: www.ktap.org

= Highlight features

   - support tracepoints, k(ret)probe, u(ret)probe, timer, function
     tracing, etc.
   - support x86, x86-64, powerpc, arm, and preempt-rt kernel.
   - support kernel 3.1 and later versions, include Linux mainline.

= Highlight changes from v0.2

   * New website for ktap: www.ktap.org

   * Tutorial: http://www.ktap.org/doc/tutorial.html

   * Wiki: https://github.com/ktap/ktap/wiki

   * simple new tracing block syntax
         trace EVENTDEF { action }
         trace_end { action }

   * New event tracing keywords: argevent, argname, arg1..arg9
         trace "syscalls:*" function () {
             print(argevent)
         }

   * New timer block syntax
         tick-N { action }
         profile-N { action }

   * Basic aggregation support
         It's similar with systemtap, use "<<<" operator
         support aggregate function: count, sum, avg, max, min

   * Introduce new "+=" operator

   * Introduce sort_paris for table sort iteration

   * New sample scripts
         helloworld.kp
         syscalls/sctop.kp
         profiling/stack_profile.kp
         io/traceio.kp
         mem/kmalloc-top.kp
         syscalls/errinfo.kp
         schedule/schedtimes.kp
         game/tetris.kp

   * ansi library for sending ANSI escape sequences

   * statistics of ktapvm
   * Big cleanups and lots of bugfix

= Source code

   Please get latest code from:
   https://github.com/ktap/ktap.git

= Building & Running

   [root@jovi]# git clone https://github.com/ktap/ktap.git

   [root@jovi]# cd ktap
   [root@jovi]# make    #generate ktapvm kernel module and ktap binary

   [root@jovi]# insmod ./ktapvm.ko
   [root@jovi]# ./ktap helloworld.kp

= Samples scripts

   There have many samples scripts in README and ktap/scripts/.

   #ls scripts/
   ansi   game           interrupt  mem        schedule  tracepoints
   basic  helloworld.kp  io         profiling  syscalls  userspace

   Totally 29 sample scripts.

= Documentation

   Documentation is in ktap/doc/, also can read from website:
   http://www.ktap.org/doc/tutorial.html

= Mailing list

   ktap@freelists.org
   You can subscribe ktap mailing list at link:
   http://www.freelists.org/list/ktap

= Feedback

   ktap is still under active development, so any feedback, bug
   reports, patches, feature requests, as always, is welcome.

= Contributors for this release

   Thanks all contributors for this release.

   Alen Skondro, Brandon Philips, Greg Kroah-Hartman, Jovi Zhangwei,
   Qingping Hou, Stanislav Fomichev, Tadaki SAKAI, Yegor Yefremov,
   Yicheng Qin.


Jovi

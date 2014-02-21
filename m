Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754142AbaBUUXl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 15:23:41 -0500
Received: from mail-qc0-f175.google.com ([209.85.216.175]:42368 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752215AbaBUUXk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 15:23:40 -0500
Date: Fri, 21 Feb 2014 15:25:41 -0500 (EST)
From: Vince Weaver <vincent.weaver@maine.edu>
To: Linux Kernel <linux-kernel@vger.kernel.org>
cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>
Subject: perf_fuzzer causes reboot
Message-ID: <alpine.DEB.2.10.1402211521040.6395@vincent-weaver-1.um.maine.edu>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


So I'm not sure who exactly to report this to.  Some perf people CC'd as
I trigger it while using the perf_fuzzer.

This is with 3.14-rc3 on a core2 machine, although I've had the reboots 
happen throughout at least 3.14-rc*

I'm having a hard time coming up with a reproducible test case.  Using the 
random seed that caused the below will cause the perf_fuzzer to segfault 
but not reboot.

The log isn't very helpful, it reboots so fast that the oops doesn't 
finish printing and the serial log just moves to the bootloader...

[ 4466.804123] BUG: unable to handle kernel NULL pointer dereference at 0000000000000050
[ 4466.808014] IP: [<ffffffff81111783>] cache_reap+0x5e/0x1c5
[ 4466.808014] PGD 0 
[ 4466.808014] Oops: 0000 [#1] GNU GRUB  version 2.00-17


Vince

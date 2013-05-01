Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757351Ab3EAVD5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 17:03:57 -0400
Received: from fold.natur.cuni.cz ([195.113.57.32]:46570 "EHLO
	fold.natur.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756938Ab3EAVDy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 17:03:54 -0400
Message-ID: <51818334.7020201@fold.natur.cuni.cz>
Date: Wed, 01 May 2013 23:03:48 +0200
From: Martin Mokrejs <mmokrejs@fold.natur.cuni.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:20.0) Gecko/20100101 Firefox/20.0 SeaMonkey/2.17.1
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        toshi.kani@hp.com
Subject: 3.9-linux-next-20130501: OOPS in intel_pstate_sample
X-Enigmail-Version: 1.6a1pre
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
  I opened yet another bug https://bugzilla.kernel.org/show_bug.cgi?id=57411 .

This is maybe a dupe of bug https://bugzilla.kernel.org/show_bug.cgi?id=57401
(which is vanilla 3.9) but happened on linux-next-20130501 after I did "dmesg | less".

? pid_param_set
intel_pstate_timer_func
call_timer_fn
? __internal_add_timer
? pid_param_set
run_timer_softirq
__do_softirq
irq_exit
smp_apic_timer_interrupt
apic_timer_interrupt
? sysret_check

A camera picture of the stacktrace is attached to the bug https://bugzilla.kernel.org/show_bug.cgi?id=57411
Please forward this to the appropriate person.
Thanks,
Martin

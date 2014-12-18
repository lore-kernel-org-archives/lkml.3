Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752328AbaLRMtB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 07:49:01 -0500
Received: from mail-wi0-f182.google.com ([209.85.212.182]:61283 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752187AbaLRMtA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 07:49:00 -0500
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
Date: Thu, 18 Dec 2014 13:48:59 +0100
Message-ID: <CA+icZUV+WFzb+1OAF5Va=qZNyozYj9-UYdRB=RwsRjrLKOiSqg@mail.gmail.com>
Subject: Re: [PATCH 0/2] sched: Preemption fixlet and cleanup
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Frederic Weisbecker <fweisbec@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am following the "frequent lockups in 3.18rc4" thread (see [0]).

So, people still work on it, and one fixlet was going towards the sched/x86.
Is there an update of your patchset [1] (especially of patch 2/2 [2]) around?

One good thing in the discussion of [0] would be a short summarize and
config-parameters to test with.

Thanks in advance.

Regards,
- Sedat -

[0] http://marc.info/?t=141600075000006&r=1&w=1
[1] http://marc.info/?l=linux-kernel&m=141861029214340&w=1
[2] http://marc.info/?t=141861036000004&r=1&w=1

P.S.: I have applied the 3 patches of Linux on top of Linux v3.18.1
and testing with that.

Linus Torvalds (3):
      x86: mm: move mmap_sem unlock from mm_fault_error() to caller
      x86: mm: consolidate VM_FAULT_RETRY handling
      x86: mm: fix VM_FAULT_RETRY handling

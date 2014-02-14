Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752532AbaBNNJP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 08:09:15 -0500
Received: from www.linutronix.de ([62.245.132.108]:41615 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752480AbaBNNJN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 08:09:13 -0500
Date: Fri, 14 Feb 2014 14:09:10 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Nicholas Mc Guire <der.herr@hofr.at>
Cc: linux-rt-users@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>, Carsten Emde <C.Emde@osadl.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andreas Platschek <platschek@ict.tuwien.ac.at>
Subject: Re: [PATCH RT 4/5] allow preemption in
 mem_cgroup_move_account_page_stat
Message-ID: <20140214130910.GE28438@linutronix.de>
References: <20140210153933.GE20017@opentech.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140210153933.GE20017@opentech.at>
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Nicholas Mc Guire | 2014-02-10 16:39:33 [+0100]:

>
>allow preemption in mem_cgroup_move_account_page_stat
>
>as the call sites of mem_cgroup_move_account_page_stat are under 
>move_lock_mem_cgroup move_unlock_mem_cgroup (spin_lock_irqsave/
>spin_unlock_irqrestore respectively) the move operations 
>preempt_disable/enable seem to be purely for migration protection so 
>a migrate_disable/enable should be fine here.
>
>patch on top of 3.12.10-rt15
>
>Signed-off-by: Nicholas Mc Guire <der.herr@hofr.at>

Applied.

Sebastian

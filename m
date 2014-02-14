Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752701AbaBNNWm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 08:22:42 -0500
Received: from www.linutronix.de ([62.245.132.108]:41729 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751998AbaBNNWl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 08:22:41 -0500
Date: Fri, 14 Feb 2014 14:22:40 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Nicholas Mc Guire <der.herr@hofr.at>
Cc: linux-rt-users@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>, Carsten Emde <C.Emde@osadl.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andreas Platschek <platschek@ict.tuwien.ac.at>
Subject: Re: [PATCH RT 3/5] allow preemption in check_task_state
Message-ID: <20140214132240.GH28438@linutronix.de>
References: <20140210162816.GA24267@opentech.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140210162816.GA24267@opentech.at>
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Nicholas Mc Guire | 2014-02-10 17:28:16 [+0100]:

>A lockfree approach to check_task_state

I ignore this due to was has been written in the thread "allow
preemption in check_task_state" for now.

Also I just want to state that this function is hardly used on regular
basis except for ptrace attach case which ends up beeing a power user in
the test case mentioned.

Sebastian

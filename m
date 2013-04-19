Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968363Ab3DSMvn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 08:51:43 -0400
Received: from mail-lb0-f171.google.com ([209.85.217.171]:57850 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968346Ab3DSMvm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 08:51:42 -0400
MIME-Version: 1.0
In-Reply-To: <1366305822-5499-1-git-send-email-fweisbec@gmail.com>
References: <1366305822-5499-1-git-send-email-fweisbec@gmail.com>
Date: Fri, 19 Apr 2013 14:51:40 +0200
Message-ID: <CAFTL4hzW_r37so=f7VhA39tKP4-M+4j=QCULkyB2pJTZia4puQ@mail.gmail.com>
Subject: Re: [RFC GIT PULL] nohz: Posix cpu timers handling on full dynticks
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Kevin Hilman <khilman@linaro.org>,
        Li Zhong <zhong@linux.vnet.ibm.com>, Oleg Nesterov <oleg@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/4/18 Frederic Weisbecker <fweisbec@gmail.com>:
> Ingo,
>
> Please consider the following branch:
>
> git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git
>         timers/nohz-posix-timers

So please wait for a v2. I need to drop patch 2 and fix
posix_cpu_timers_schedule() through another way.
But the other pull request reviewed by Paul is still valid.

Thanks.

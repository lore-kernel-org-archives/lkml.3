Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757073Ab3DWSMO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 14:12:14 -0400
Received: from a193-30.smtp-out.amazonses.com ([199.255.193.30]:4865 "EHLO
	a193-30.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756735Ab3DWSMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 14:12:12 -0400
Date: Tue, 23 Apr 2013 18:12:10 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Kevin Hilman <khilman@linaro.org>,
        Li Zhong <zhong@linux.vnet.ibm.com>, Oleg Nesterov <oleg@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 2/2] nohz: Add basic tracing
In-Reply-To: <1366664905-21884-3-git-send-email-fweisbec@gmail.com>
Message-ID: <0000013e38188092-7e0b72ea-9ae0-417c-902a-5e8a88282073-000000@email.amazonses.com>
References: <1366664905-21884-1-git-send-email-fweisbec@gmail.com> <1366664905-21884-3-git-send-email-fweisbec@gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.193.30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 22 Apr 2013, Frederic Weisbecker wrote:

> It's not obvious to find out why the full dynticks subsystem
> doesn't always stop the tick: whether this is due to kthreads,
> posix timers, perf events, etc...
>
> These new tracepoints are here to help the user diagnose
> the failures and test this feature.

Very good. This will help a lot.


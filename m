Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934715Ab3DORia (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 13:38:30 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:38332 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756348Ab3DORi2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 13:38:28 -0400
Message-ID: <1366047507.31131.2.camel@joe-AO722>
Subject: Re: [Patch -v3 2/4] Move shutdown/reboot related functions to
 kernel/reboot.c
From: Joe Perches <joe@perches.com>
To: Robin Holt <holt@sgi.com>
Cc: Ingo Molnar <mingo@redhat.com>, Russ Anderson <rja@sgi.com>,
        Shawn Guo <shawn.guo@linaro.org>, Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Michel Lespinasse <walken@google.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>,
        Tejun Heo <tj@kernel.org>, the arch/x86 maintainers <x86@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Mon, 15 Apr 2013 10:38:27 -0700
In-Reply-To: <20130415171516.GG3672@sgi.com>
References: <20130415171225.GC3658@sgi.com> <20130415171516.GG3672@sgi.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-04-15 at 12:15 -0500, Robin Holt wrote:
> This patch is preparatory.  It moves reboot related syscall, etc
> functions from kernel/sys.c to kernel/reboot.c.
[]
> diff --git a/kernel/reboot.c b/kernel/reboot.c
[]
> +#ifdef CONFIG_HIBERNATION
> +	case LINUX_REBOOT_CMD_SW_SUSPEND:
> +		ret = hibernate();
> +		break;
> +#endif

Doesn't compile.  needs suspend.h




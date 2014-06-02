Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753797AbaFBUfQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 16:35:16 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40922 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751616AbaFBUfP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 16:35:15 -0400
Date: Mon, 2 Jun 2014 13:35:12 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu
Subject: Re: [PATCH RFC 2/2] rcu: Add Josh Triplett as designated reviewer
Message-Id: <20140602133512.6d3f584314ecc423e63ffc8e@linux-foundation.org>
In-Reply-To: <1401728420-3572-2-git-send-email-paulmck@linux.vnet.ibm.com>
References: <1401728420-3572-1-git-send-email-paulmck@linux.vnet.ibm.com>
	<1401728420-3572-2-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  2 Jun 2014 10:00:20 -0700 "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:

> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -7321,6 +7321,7 @@ F:	kernel/rcu/torture.c
>  
>  RCUTORTURE TEST FRAMEWORK
>  M:	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> +R:	Josh Triplett <josh@joshtriplett.org>
>  L:	linux-kernel@vger.kernel.org
>  S:	Supported
>  T:	git git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git

I like the general principle - knowing who to poke regarding a kernel
change is useful.

I don't care much whether it's "M:" or "R:", although "R:" carries more
meaning and hence is probably better.

But why not "Cc:"?  That's meaningful too and is more copy-n-paste friendly.

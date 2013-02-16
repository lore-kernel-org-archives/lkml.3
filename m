Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754494Ab3BPUy7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2013 15:54:59 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:48479 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754407Ab3BPUy6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2013 15:54:58 -0500
Date: Sat, 16 Feb 2013 12:54:51 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Debugging Thinkpad T430s occasional suspend failure.
Message-ID: <20130216205451.GA3094@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130212193901.GA18906@redhat.com>
 <alpine.LNX.2.00.1302121549500.890@eggly.anvils>
 <20130213004059.GA14451@redhat.com>
 <alpine.LNX.2.00.1302121652240.1077@eggly.anvils>
 <20130213041629.GA28622@redhat.com>
 <alpine.LNX.2.00.1302122121170.15020@eggly.anvils>
 <20130213193411.GA15928@redhat.com>
 <CA+55aFzmEDriX26Z7oJZg9yssFdCAaYwu6krmrwqfj2TBsxA4w@mail.gmail.com>
 <20130213205313.GA31374@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130213205313.GA31374@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13021620-4834-0000-0000-000003C45389
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 13, 2013 at 03:53:13PM -0500, Dave Jones wrote:
> On Wed, Feb 13, 2013 at 11:56:25AM -0800, Linus Torvalds wrote:

[ . . . ]

> Which points out something in tree-rcu.  Which I don't even have compiled in,
> because I have CONFIG_PREEMPT set.

FWIW, the code in kernel/rcutree.c is shared between CONFIG_TREE_RCU
and CONFIG_TREE_PREEMPT_RCU.  The differences between these two options
is mostly in kernel/rcutree_plugin.h under #ifdef, with some others in
include/linux/rcudate.h and kernel/rcutree.h.

							Thanx, Paul

> I'll keep trying some of the earlier good branches in case I missed something.
> 
> 	Dave
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


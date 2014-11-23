Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751869AbaKWQjt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2014 11:39:49 -0500
Received: from mail-ig0-f176.google.com ([209.85.213.176]:54912 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751280AbaKWQjs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2014 11:39:48 -0500
Message-ID: <1416760785.17888.18.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: Re: [PATCH tip/core/rcu 3/9] drivers/md: Use rcu_dereference() for
 accessing rcu pointer
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Pranith Kumar <bobby.prani@gmail.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Dipankar Sarma <dipankar@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        David Howells <dhowells@redhat.com>,
        Eric Dumazet <edumazet@google.com>, dvhart@linux.intel.com,
        =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Oleg Nesterov <oleg@redhat.com>
Date: Sun, 23 Nov 2014 08:39:45 -0800
In-Reply-To: <CAJhHMCCE_p+xTibLZwoS5OqW--NO_uEVsW6tfN6LcgZGBquBTQ@mail.gmail.com>
References: <20141028220944.GA26114@linux.vnet.ibm.com>
	 <1414534202-27312-1-git-send-email-paulmck@linux.vnet.ibm.com>
	 <1414534202-27312-3-git-send-email-paulmck@linux.vnet.ibm.com>
	 <20141121133145.GA17245@node.dhcp.inet.fi> <546F4C8C.4040904@gmail.com>
	 <20141121145817.GA17710@node.dhcp.inet.fi>
	 <CAJhHMCCE_p+xTibLZwoS5OqW--NO_uEVsW6tfN6LcgZGBquBTQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-11-23 at 07:21 -0500, Pranith Kumar wrote:

> I am not sure we should be taking rcu_read_lock() there as I am not
> sure how long that critical section might last. Can someone who is
> more familiar with the code take a look?
> 
> I will try to look for a solution too in the mean time.

I am sending a fix.



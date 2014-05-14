Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755961AbaENPmK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 11:42:10 -0400
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:44578 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755682AbaENPmI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 11:42:08 -0400
X-Originating-IP: 50.43.32.211
Date: Wed, 14 May 2014 08:41:50 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu, Uma Sharma <uma.sharma523@gmail.com>
Subject: Re: [PATCH tip/core/rcu 1/1] rcu: Variable name changed in
 tree_plugin.h and used in tree.c
Message-ID: <20140514154150.GA1873@thin>
References: <1400027459-29427-1-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400027459-29427-1-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 13, 2014 at 05:30:59PM -0700, Paul E. McKenney wrote:
> From: Uma Sharma <uma.sharma523@gmail.com>
> 
> The variable and struct both having the name "rcu_state" confuses
> sparse in some situations, so this commit changes the variable to
> "rcu_state_p" in order to avoid this confusion.  This also makes
> things easier for human readers.

Human readers aside, how does Sparse get confused?  Let's fix that.

Personally, I don't think the _p makes things particularly easier for
human readers, but it doesn't make things *harder* for anyone other than
those used to reading the existing code, so, *shrug*.

- Josh Triplett

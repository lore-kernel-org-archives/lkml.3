Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752429AbaEGV1N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 17:27:13 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:34986 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750966AbaEGV1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 17:27:12 -0400
Date: Wed, 7 May 2014 14:27:08 -0700
From: josh@joshtriplett.org
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu
Subject: Re: [PATCH tip/core/rcu 11/45] torture: Rename
 RCU_QEMU_INTERACTIVE to TORTURE_QEMU_INTERACTIVE
Message-ID: <20140507212708.GG27924@cloud>
References: <20140429002455.GA15461@linux.vnet.ibm.com>
 <1398731133-18925-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1398731133-18925-11-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398731133-18925-11-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 28, 2014 at 05:24:59PM -0700, Paul E. McKenney wrote:
> -		if test -n "$RCU_QEMU_INTERACTIVE" -a -n "$RCU_QEMU_MAC"
> +		if test -n "$TORTURE_QEMU_INTERACTIVE" -a -n "$RCU_QEMU_MAC"
>  		then
>  			echo -device spapr-vlan,netdev=net0,mac=$RCU_QEMU_MAC
>  			echo -netdev bridge,br=br0,id=net0
> -		elif test -n "$RCU_QEMU_INTERACTIVE"
> +		elif test -n "$TORTURE_QEMU_INTERACTIVE"
>  		then
>  			echo -net nic -net user

Not related to this patch, but: qemu defaults to -net nic -net user, so
you don't need to specify it.

- Josh Triplett

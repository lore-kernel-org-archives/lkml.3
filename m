Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761964Ab3DBVPb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 17:15:31 -0400
Received: from dcvr.yhbt.net ([64.71.152.64]:58034 "EHLO dcvr.yhbt.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758910Ab3DBVP3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 17:15:29 -0400
Date: Tue, 2 Apr 2013 21:15:27 +0000
From: Eric Wong <normalperson@yhbt.net>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: linux-kernel@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: Re: [PATCH] wfcqueue: add function for unsynchronized prepend
Message-ID: <20130402211527.GA17261@dcvr.yhbt.net>
References: <20130311213602.GB9829@Krystal>
 <20130329081016.GA15979@dcvr.yhbt.net>
 <20130402130541.GC11621@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130402130541.GC11621@Krystal>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:
> * Eric Wong (normalperson@yhbt.net) wrote:
> > In some situations, it is necessary to prepend a node to a queue.
> > For epoll, this is necessary for two rare conditions:
> > 
> > * when the user triggers -EFAULT
> > * when reinjecting elements from the ovflist (implemented as a stack)
> 
> This approach makes sense.
> 
> In terms of API naming, I wonder if "prepend" is the good counterpart
> for "enqueue". Maybe "enqueue_first" or "enqueue_head" could be better
> suited ?

I'm not sure, I'll go with whatever name you decide is best :)

Thanks for looking at my patch, I'll post an updated version
once a name is decided.

-- 
Eric "isuckatnamingthings" Wong

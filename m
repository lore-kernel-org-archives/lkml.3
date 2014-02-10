Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751184AbaBJFY5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 00:24:57 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:37788 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750719AbaBJFYw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 00:24:52 -0500
Date: Sun, 9 Feb 2014 21:24:43 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Rientjes <rientjes@google.com>
Subject: Re: linux-next: manual merge of the akpm-current tree with the rcu
 tree
Message-ID: <20140210052443.GH4250@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140210150047.65f06219ffa970ad34d27d7f@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140210150047.65f06219ffa970ad34d27d7f@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021005-7164-0000-0000-000005D7EFF3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 10, 2014 at 03:00:47PM +1100, Stephen Rothwell wrote:
> Hi Andrew,
> 
> Today's linux-next merge of the akpm-current tree got a conflict in
> mm/slub.c between commit f4e40a71719d ("slub: Fix add_full() lockdep
> checks") from the rcu tree and commit aee03fe7a7c8 ("mm/slub.c: list_lock
> may not be held in some circumstances") from the akpm-current tree.
> 
> These patches try to achieve the same thing, so I arbitrarily chose the
> version from the akpm-current tree.

My bad -- I forgot to remove my version.

							Thanx, Paul


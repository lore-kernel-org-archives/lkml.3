Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753401AbaF3UY2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 16:24:28 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:57388 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750840AbaF3UY1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 16:24:27 -0400
Date: Mon, 30 Jun 2014 13:24:21 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Josh Triplett <josh@joshtriplett.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 0/2] rcu: uninline rcu_lock_acquire() and
 rcu_lock_release()
Message-ID: <20140630202420.GG4603@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140630161837.GA15873@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140630161837.GA15873@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14063020-6688-0000-0000-000002F4833E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 30, 2014 at 06:18:37PM +0200, Oleg Nesterov wrote:
> Hello,
> 
> May be correct this time ;) Based on paulmck/linux-rcu.git rcu/next.
> 
> 2/2 is new and hopefully trivial. But! the numbers look suspiciously
> good, I do not understand where does the difference come from...

Probably from rcu_dereference_raw() and rcu_dereference_check(..., 1).  ;-)

Queued and kicked off testing, both mine and (indirectly) Fengguang's.

							Thanx, Paul


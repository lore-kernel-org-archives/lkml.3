Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753940AbaKQEwW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 23:52:22 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:42550 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751881AbaKQEwU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 23:52:20 -0500
Date: Sun, 16 Nov 2014 20:43:00 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Tejun Heo <tj@kernel.org>
Cc: Pranith Kumar <bobby.prani@gmail.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 09/16] percpu: Replace smp_read_barrier_depends() with
 lockless_dereference()
Message-ID: <20141117044300.GM4460@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1415906662-4576-1-git-send-email-bobby.prani@gmail.com>
 <1415906662-4576-10-git-send-email-bobby.prani@gmail.com>
 <20141114131448.GC21209@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141114131448.GC21209@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14111704-0017-0000-0000-0000065A3217
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 14, 2014 at 08:14:48AM -0500, Tejun Heo wrote:
> On Thu, Nov 13, 2014 at 02:24:15PM -0500, Pranith Kumar wrote:
> > Recently lockless_dereference() was added which can be used in place of
> > hard-coding smp_read_barrier_depends(). The following PATCH makes the change.
> > 
> > Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
> 
> How should this be routed?  There's a pending change on the same
> region of code and if this patch is routed outside percpu tree it'd
> cause a conflict and I can't route this as lockless_dereference()
> isn't in the mainline yet.  Maybe expose a git branch which contaisn
> lockless_dereference() so that percpu can pull it in?

Actually, lockless_dereference() is now in mainline, if that makes it
easier.

							Thanx, Paul


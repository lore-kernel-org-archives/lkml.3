Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754353Ab3JMLF1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Oct 2013 07:05:27 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:59048 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754238Ab3JMLFZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Oct 2013 07:05:25 -0400
Date: Sun, 13 Oct 2013 04:05:18 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Chen Gang <gang.chen@asianux.com>
Cc: josh@freedesktop.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Suggestion] kernel/rcutorture.c: about using scnprintf()
 instead of sprintf().
Message-ID: <20131013110518.GC5790@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <5253C335.5050609@asianux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5253C335.5050609@asianux.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13101311-9332-0000-0000-000001BFE867
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 08, 2013 at 04:32:53PM +0800, Chen Gang wrote:
> Hello Maintainers:
> 
> In srcu_torture_stats(), if cpus are more than 1K, the PAGE_SIZE will
> not be enough.
> 
> In rcu_torture_printk(), the 'page' maximized size is 4096, it has a
> function pointer for printing, which not tell its maximized length.
> 
> Welcome any additional suggestions or completions.

I never have run rcutorture on a system with that many CPUs.  ;-)

Given that rcutorture is not used in production, my approach would be to
fix this when I encountered it.  But what change would you suggest, and,
more importantly, how would you go about testing it before submitting
a patch?

Or if you are simply reporting this as a bug, please let me know that.

							Thanx, Paul


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757720Ab3GWPLm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 11:11:42 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:39258 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754566Ab3GWPLl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 11:11:41 -0400
Date: Tue, 23 Jul 2013 08:01:53 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Tejun Heo <tj@kernel.org>
Cc: Dipankar Sarma <dipankar@in.ibm.com>,
        Fengguang Wu <fengguang.wu@intel.com>,
        "David S. Miller" <davem@davemloft.net>, Li Zefan <lizefan@huawei.com>,
        Patrick McHardy <kaber@trash.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] rculist: list_first_or_null_rcu() should use
 list_entry_rcu()
Message-ID: <20130723150153.GU21367@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130621003244.GD11837@mtj.dyndns.org>
 <20130626172753.GC4405@mtj.dyndns.org>
 <20130628173448.GD18889@mtj.dyndns.org>
 <20130628192509.GB3773@linux.vnet.ibm.com>
 <20130723144854.GB18458@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130723144854.GB18458@mtj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13072315-5518-0000-0000-000010909BA9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 23, 2013 at 10:48:54AM -0400, Tejun Heo wrote:
> Hello, Paul.
> 
> On Fri, Jun 28, 2013 at 12:25:09PM -0700, Paul E. McKenney wrote:
> > Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> How should this patch be routed?  Probably best to route with other
> rcu changes?

Fair point, queued for 3.12.  Thank you, Tejun!

							Thanx, Paul


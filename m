Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757840Ab3GWOtR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 10:49:17 -0400
Received: from mail-ye0-f181.google.com ([209.85.213.181]:40963 "EHLO
	mail-ye0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757704Ab3GWOs7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 10:48:59 -0400
Date: Tue, 23 Jul 2013 10:48:54 -0400
From: Tejun Heo <tj@kernel.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Dipankar Sarma <dipankar@in.ibm.com>,
        Fengguang Wu <fengguang.wu@intel.com>,
        "David S. Miller" <davem@davemloft.net>, Li Zefan <lizefan@huawei.com>,
        Patrick McHardy <kaber@trash.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] rculist: list_first_or_null_rcu() should use
 list_entry_rcu()
Message-ID: <20130723144854.GB18458@mtj.dyndns.org>
References: <20130621003244.GD11837@mtj.dyndns.org>
 <20130626172753.GC4405@mtj.dyndns.org>
 <20130628173448.GD18889@mtj.dyndns.org>
 <20130628192509.GB3773@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130628192509.GB3773@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Paul.

On Fri, Jun 28, 2013 at 12:25:09PM -0700, Paul E. McKenney wrote:
> Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

How should this patch be routed?  Probably best to route with other
rcu changes?

Thanks.

-- 
tejun

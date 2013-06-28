Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755897Ab3F1Rb6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 13:31:58 -0400
Received: from mail-qc0-f173.google.com ([209.85.216.173]:58548 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754682Ab3F1Rb5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 13:31:57 -0400
Date: Fri, 28 Jun 2013 10:31:51 -0700
From: Tejun Heo <tj@kernel.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Dipankar Sarma <dipankar@in.ibm.com>,
        Fengguang Wu <fengguang.wu@intel.com>,
        "David S. Miller" <davem@davemloft.net>, Li Zefan <lizefan@huawei.com>,
        Patrick McHardy <kaber@trash.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] rculist: list_first_or_null_rcu() should use
 list_entry_rcu()
Message-ID: <20130628173151.GC18889@mtj.dyndns.org>
References: <20130621003244.GD11837@mtj.dyndns.org>
 <20130626172753.GC4405@mtj.dyndns.org>
 <20130628172455.GA3773@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130628172455.GA3773@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 28, 2013 at 10:24:55AM -0700, Paul E. McKenney wrote:
> But why drop the parens around "ptr"?

Oops, when did that happen?  :) Will post an updated version right
away.

Thanks.

-- 
tejun

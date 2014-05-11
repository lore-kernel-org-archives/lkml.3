Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757887AbaEKBrx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2014 21:47:53 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:46898 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752221AbaEKBrw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2014 21:47:52 -0400
Date: Sat, 10 May 2014 21:47:50 -0400 (EDT)
Message-Id: <20140510.214750.1194823540790487670.davem@davemloft.net>
To: tj@kernel.org
Cc: lizefan@huawei.com, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        hannes@cmpxchg.org, vgoyal@redhat.com, axboe@kernel.dk,
        a.p.zijlstra@chello.nl, mhocko@suse.cz, nhorman@tuxdriver.com
Subject: Re: [PATCH 01/14] cgroup: remove css_parent()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1399671091-23867-2-git-send-email-tj@kernel.org>
References: <1399671091-23867-1-git-send-email-tj@kernel.org>
	<1399671091-23867-2-git-send-email-tj@kernel.org>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Sat, 10 May 2014 18:47:51 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tejun Heo <tj@kernel.org>
Date: Fri,  9 May 2014 17:31:18 -0400

> cgroup in general is moving towards using cgroup_subsys_state as the
> fundamental structural component and css_parent() was introduced to
> convert from using cgroup->parent to css->parent.  It was quite some
> time ago and we're moving forward with making css more prominent.
> 
> This patch drops the trivial wrapper css_parent() and let the users
> dereference css->parent.  While at it, explicitly mark fields of css
> which are public and immutable.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>

For networking bits:

Acked-by: David S. Miller <davem@davemloft.net>

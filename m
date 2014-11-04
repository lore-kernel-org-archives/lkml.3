Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754683AbaKDQeR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 11:34:17 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:56882 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754591AbaKDQeM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 11:34:12 -0500
Date: Tue, 04 Nov 2014 11:34:09 -0500 (EST)
Message-Id: <20141104.113409.1013929072623558759.davem@davemloft.net>
To: hannes@cmpxchg.org
Cc: mhocko@suse.cz, kamezawa.hiroyu@jp.fujitsu.com, akpm@linux-foundation.org,
        vdavydov@parallels.com, tj@kernel.org, linux-mm@kvack.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 1/3] mm: embed the memcg pointer directly into struct
 page
From: David Miller <davem@davemloft.net>
In-Reply-To: <20141104140937.GA18602@phnom.home.cmpxchg.org>
References: <20141104132701.GA18441@phnom.home.cmpxchg.org>
	<20141104134110.GD22207@dhcp22.suse.cz>
	<20141104140937.GA18602@phnom.home.cmpxchg.org>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 04 Nov 2014 08:34:11 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johannes Weiner <hannes@cmpxchg.org>
Date: Tue, 4 Nov 2014 09:09:37 -0500

> You either need cgroup memory accounting and limiting or not.  There
> is no possible trade-off to be had.

I couldn't have said it better myself, +1.

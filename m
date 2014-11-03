Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753559AbaKCULA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 15:11:00 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:49065 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752448AbaKCUK7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 15:10:59 -0500
Date: Mon, 03 Nov 2014 15:10:56 -0500 (EST)
Message-Id: <20141103.151056.1825096971313944324.davem@davemloft.net>
To: hannes@cmpxchg.org
Cc: akpm@linux-foundation.org, mhocko@suse.cz, vdavydov@parallels.com,
        tj@kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch] mm: move page->mem_cgroup bad page handling into
 generic code fix
From: David Miller <davem@davemloft.net>
In-Reply-To: <20141103182740.GA10816@phnom.home.cmpxchg.org>
References: <1414898156-4741-1-git-send-email-hannes@cmpxchg.org>
	<1414898156-4741-3-git-send-email-hannes@cmpxchg.org>
	<20141103182740.GA10816@phnom.home.cmpxchg.org>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 03 Nov 2014 12:10:58 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johannes Weiner <hannes@cmpxchg.org>
Date: Mon, 3 Nov 2014 13:27:40 -0500

> Remove unneeded !CONFIG_MEMCG memcg bad_page() dummies as well.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Acked-by: David S. Miller <davem@davemloft.net>

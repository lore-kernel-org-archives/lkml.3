Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751924AbaKCEW7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2014 23:22:59 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:42560 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751681AbaKCEWy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2014 23:22:54 -0500
Date: Sun, 02 Nov 2014 23:22:52 -0500 (EST)
Message-Id: <20141102.232252.289821233794405148.davem@davemloft.net>
To: hannes@cmpxchg.org
Cc: akpm@linux-foundation.org, mhocko@suse.cz, vdavydov@parallels.com,
        tj@kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 2/3] mm: page_cgroup: rename file to mm/swap_cgroup.c
From: David Miller <davem@davemloft.net>
In-Reply-To: <1414898156-4741-2-git-send-email-hannes@cmpxchg.org>
References: <1414898156-4741-1-git-send-email-hannes@cmpxchg.org>
	<1414898156-4741-2-git-send-email-hannes@cmpxchg.org>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Sun, 02 Nov 2014 20:22:54 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johannes Weiner <hannes@cmpxchg.org>
Date: Sat,  1 Nov 2014 23:15:55 -0400

> Now that the external page_cgroup data structure and its lookup is
> gone, the only code remaining in there is swap slot accounting.
> 
> Rename it and move the conditional compilation into mm/Makefile.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Acked-by: David S. Miller <davem@davemloft.net>

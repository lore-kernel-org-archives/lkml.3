Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752521AbaKCQml (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 11:42:41 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:47310 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751981AbaKCQmj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 11:42:39 -0500
Date: Mon, 03 Nov 2014 11:42:35 -0500 (EST)
Message-Id: <20141103.114235.2147567115691592307.davem@davemloft.net>
To: hannes@cmpxchg.org
Cc: iamjoonsoo.kim@lge.com, akpm@linux-foundation.org, mhocko@suse.cz,
        vdavydov@parallels.com, tj@kernel.org, linux-mm@kvack.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 1/3] mm: embed the memcg pointer directly into struct
 page
From: David Miller <davem@davemloft.net>
In-Reply-To: <20141103150942.GA32052@phnom.home.cmpxchg.org>
References: <1414898156-4741-1-git-send-email-hannes@cmpxchg.org>
	<20141103080208.GA7052@js1304-P5Q-DELUXE>
	<20141103150942.GA32052@phnom.home.cmpxchg.org>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 03 Nov 2014 08:42:38 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johannes Weiner <hannes@cmpxchg.org>
Date: Mon, 3 Nov 2014 10:09:42 -0500

> Please re-introduce this code when your new usecase is ready to be
> upstreamed.  There is little reason to burden an unrelated feature
> with a sizable chunk of dead code for a vague future user.

+1

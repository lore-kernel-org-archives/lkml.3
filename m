Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753983AbaJNAEW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 20:04:22 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:36438 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752985AbaJNAEU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 20:04:20 -0400
Date: Mon, 13 Oct 2014 20:04:16 -0400 (EDT)
Message-Id: <20141013.200416.641735303627599182.davem@davemloft.net>
To: iamjoonsoo.kim@lge.com
Cc: mroos@linux.ee, linux-kernel@vger.kernel.org, cl@linux.com,
        penberg@kernel.org, rientjes@google.com, akpm@linux-foundation.org,
        linux-mm@kvack.org, sparclinux@vger.kernel.org
Subject: Re: unaligned accesses in SLAB etc.
From: David Miller <davem@davemloft.net>
In-Reply-To: <20141013235219.GA11191@js1304-P5Q-DELUXE>
References: <20141012.132012.254712930139255731.davem@davemloft.net>
	<alpine.LRH.2.11.1410132320110.9586@adalberg.ut.ee>
	<20141013235219.GA11191@js1304-P5Q-DELUXE>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 13 Oct 2014 17:04:20 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Date: Tue, 14 Oct 2014 08:52:19 +0900

> I'd like to know that your another problem is related to commit
> bf0dea23a9c0 ("mm/slab: use percpu allocator for cpu cache").  So,
> if the commit is reverted, your another problem is also gone
> completely?

The other problem has been present forever.

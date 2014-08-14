Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753513AbaHNC4C (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 22:56:02 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:49005 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753219AbaHNC4A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 22:56:00 -0400
Date: Wed, 13 Aug 2014 19:55:58 -0700 (PDT)
Message-Id: <20140813.195558.2039710996129294402.davem@davemloft.net>
To: minchan@kernel.org
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, mtk.manpages@gmail.com,
        linux-api@vger.kernel.org, hughd@google.com, hannes@cmpxchg.org,
        riel@redhat.com, kosaki.motohiro@jp.fujitsu.com, mgorman@suse.de,
        je@fb.com, zhangyanfei@cn.fujitsu.com, kirill@shutemov.name,
        sparclinux@vger.kernel.org
Subject: Re: [PATCH v14 3/8] sparc: add pmd_[dirty|mkclean] for THP
From: David Miller <davem@davemloft.net>
In-Reply-To: <1407981212-17818-4-git-send-email-minchan@kernel.org>
References: <1407981212-17818-1-git-send-email-minchan@kernel.org>
	<1407981212-17818-4-git-send-email-minchan@kernel.org>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 13 Aug 2014 19:55:59 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Minchan Kim <minchan@kernel.org>
Date: Thu, 14 Aug 2014 10:53:27 +0900

> MADV_FREE needs pmd_dirty and pmd_mkclean for detecting recent
> overwrite of the contents since MADV_FREE syscall is called for
> THP page.
> 
> This patch adds pmd_dirty and pmd_mkclean for THP page MADV_FREE
> support.
> 
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: sparclinux@vger.kernel.org
> Signed-off-by: Minchan Kim <minchan@kernel.org>

Acked-by: David S. Miller <davem@davemloft.net>

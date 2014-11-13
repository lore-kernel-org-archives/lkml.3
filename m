Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752969AbaKMACK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 19:02:10 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:51719 "EHLO
	lgemrelse7q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752201AbaKMACJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 19:02:09 -0500
X-Original-SENDERIP: 10.177.220.156
X-Original-MAILFROM: minchan@kernel.org
Date: Thu, 13 Nov 2014 09:02:16 +0900
From: Minchan Kim <minchan@kernel.org>
To: Mahendran Ganesh <opensource.ganesh@gmail.com>
Cc: ngupta@vflare.org, weijie.yang@samsung.com, sergey.senozhatsky@gmail.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/zram: correct ZRAM_ZERO flag bit position
Message-ID: <20141113000216.GA1074@bbox>
References: <1415803038-7913-1-git-send-email-opensource.ganesh@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1415803038-7913-1-git-send-email-opensource.ganesh@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 12, 2014 at 10:37:18PM +0800, Mahendran Ganesh wrote:
> In struct zram_table_entry, the element *value* contains obj size and
> obj zram flags. Bit 0 to bit (ZRAM_FLAG_SHIFT - 1) represent obj size,
> and bit ZRAM_FLAG_SHIFT to the highest bit of unsigned long represent obj
> zram_flags. So the first zram flag(ZRAM_ZERO) should be from ZRAM_FLAG_SHIFT
> instead of (ZRAM_FLAG_SHIFT + 1).
> 
> This patch fixes this issue.
> 
> Also this patch fixes a typo, "page in now accessed" -> "page is now accessed"
> 
> Signed-off-by: Mahendran Ganesh <opensource.ganesh@gmail.com>
Acked-by: Minchan Kim <minchan@kernel.org>

To be clear about "fixes this issue", it's not a bug but just clean up
so it doesn't change any behavior.

Thanks!

-- 
Kind regards,
Minchan Kim

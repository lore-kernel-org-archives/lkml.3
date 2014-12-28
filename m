Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751632AbaL1Xyg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2014 18:54:36 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:56493 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751476AbaL1Xyf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2014 18:54:35 -0500
X-Original-SENDERIP: 10.177.220.156
X-Original-MAILFROM: minchan@kernel.org
Date: Mon, 29 Dec 2014 08:56:37 +0900
From: Minchan Kim <minchan@kernel.org>
To: Ganesh Mahendran <opensource.ganesh@gmail.com>
Cc: ngupta@vflare.org, sjennings@variantweb.net, ddstreet@ieee.org,
        akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mm/zpool: add name argument to create zpool
Message-ID: <20141228235637.GA27095@bbox>
References: <1419599095-4382-1-git-send-email-opensource.ganesh@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1419599095-4382-1-git-send-email-opensource.ganesh@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 26, 2014 at 09:04:55PM +0800, Ganesh Mahendran wrote:
> Currently the underlay of zpool: zsmalloc/zbud, do not know
> who creates them. There is not a method to let zsmalloc/zbud
> find which caller they belogs to.
> 
> Now we want to add statistics collection in zsmalloc. We need
> to name the debugfs dir for each pool created. The way suggested
> by Minchan Kim is to use a name passed by caller(such as zram)
> to create the zsmalloc pool.
>     /sys/kernel/debug/zsmalloc/zram0
> 
> This patch adds a argument *name* to zs_create_pool() and other
> related functions.
> 
> Signed-off-by: Ganesh Mahendran <opensource.ganesh@gmail.com>
Acked-by: Minchan Kim <minchan@kernel.org>

-- 
Kind regards,
Minchan Kim

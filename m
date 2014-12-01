Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752448AbaLAA3a (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 19:29:30 -0500
Received: from lgeamrelo01.lge.com ([156.147.1.125]:34231 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751756AbaLAA33 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 19:29:29 -0500
X-Original-SENDERIP: 10.177.220.156
X-Original-MAILFROM: minchan@kernel.org
Date: Mon, 1 Dec 2014 09:29:48 +0900
From: Minchan Kim <minchan@kernel.org>
To: Ganesh Mahendran <opensource.ganesh@gmail.com>
Cc: ngupta@vflare.org, ddstreet@ieee.org, akpm@linux-foundation.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] mm/zsmalloc: allocate exactly size of struct zs_pool
Message-ID: <20141201002948.GC11340@bbox>
References: <1417260235-32053-1-git-send-email-opensource.ganesh@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1417260235-32053-1-git-send-email-opensource.ganesh@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 29, 2014 at 07:23:55PM +0800, Ganesh Mahendran wrote:
> In zs_create_pool(), we allocate memory more then sizeof(struct zs_pool)
>   ovhd_size = roundup(sizeof(*pool), PAGE_SIZE);
> 
> This patch allocate memory of exactly needed size.
> 
> Signed-off-by: Ganesh Mahendran <opensource.ganesh@gmail.com>
Acked-by: Minchan Kim <minchan@kernel.org>

-- 
Kind regards,
Minchan Kim

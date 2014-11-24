Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752731AbaKXHtO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 02:49:14 -0500
Received: from lgeamrelo04.lge.com ([156.147.1.127]:56570 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752176AbaKXHtN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 02:49:13 -0500
X-Original-SENDERIP: 10.177.220.156
X-Original-MAILFROM: minchan@kernel.org
Date: Mon, 24 Nov 2014 16:49:30 +0900
From: Minchan Kim <minchan@kernel.org>
To: Mahendran Ganesh <opensource.ganesh@gmail.com>
Cc: ngupta@vflare.org, iamjoonsoo.kim@lge.com, ddstreet@ieee.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm/zsmalloc: avoid duplicate assignment of prev_class
Message-ID: <20141124074930.GA22312@bbox>
References: <1416577403-7887-1-git-send-email-opensource.ganesh@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1416577403-7887-1-git-send-email-opensource.ganesh@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 21, 2014 at 09:43:23PM +0800, Mahendran Ganesh wrote:
> In zs_create_pool(), prev_class is assigned (ZS_SIZE_CLASSES - 1)
> times. And the prev_class only references to the previous size_class.
> So we do not need unnecessary assignement.
> 
> This patch assigns *prev_class* when a new size_class structure
> is allocated and uses prev_class to check whether the first class
> has been allocated.
> 
> Signed-off-by: Mahendran Ganesh <opensource.ganesh@gmail.com>
Acked-by: Minchan Kim <minchan@kernel.org>

-- 
Kind regards,
Minchan Kim

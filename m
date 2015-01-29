Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757619AbbA2FXI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 00:23:08 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:47600 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754294AbbA2FXG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 00:23:06 -0500
Date: Thu, 29 Jan 2015 14:22:54 +0900
From: Minchan Kim <minchan@kernel.org>
To: Ganesh Mahendran <opensource.ganesh@gmail.com>
Cc: ngupta@vflare.org, sergey.senozhatsky.work@gmail.com,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: Re: [PATCH v2] zram: free meta table in zram_meta_free
Message-ID: <20150129052254.GA25462@blaptop>
References: <1421711028-5553-1-git-send-email-opensource.ganesh@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421711028-5553-1-git-send-email-opensource.ganesh@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 20, 2015 at 07:43:47AM +0800, Ganesh Mahendran wrote:
> zram_meta_alloc() and zram_meta_free() are a pair.
> In zram_meta_alloc(), meta table is allocated. So it it better to free
> it in zram_meta_free().
> 
> Signed-off-by: Ganesh Mahendran <opensource.ganesh@gmail.com>
Acked-by: Minchan Kim <minchan@kernel.org>

Thanks.

-- 
Kind regards,
Minchan Kim

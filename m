Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752655Ab3FDJAj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 05:00:39 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:43052 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752194Ab3FDJAh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 05:00:37 -0400
X-AuditID: 9c93017e-b7c0cae0000006f6-be-51adacb3b263
Date: Tue, 4 Jun 2013 18:00:35 +0900
From: Minchan Kim <minchan@kernel.org>
To: Jiang Liu <liuj97@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nitin Gupta <ngupta@vflare.org>, Jerome Marchand <jmarchan@redhat.com>,
        Yijing Wang <wangyijing@huawei.com>, Jiang Liu <jiang.liu@huawei.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v1 0/8] small bugfixes and code improvements for zram
Message-ID: <20130604090035.GA28551@blaptop>
References: <1370274140-26420-1-git-send-email-jiang.liu@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370274140-26420-1-git-send-email-jiang.liu@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Jun 03, 2013 at 11:42:12PM +0800, Jiang Liu wrote:
> This patchset is to fix issues in zram found by code inspection.
> There is still one more issue left: should we repalce zram_stat64_xxx()
> with atomic64_xxx()?
> 
> Jiang Liu (8):
>   zram: simplify and optimize zram_to_dev()
>   zram: avoid invalid memory access in zram_exit()
>   zram: use zram->lock to protect zram_free_page() in swap free notify
>     path
>   zram: destroy all devices on error recovery path in zram_init()
>   zram: avoid double free in error recovery path of zram_bvec_write()
>   zram: avoid access beyond the zram device
>   zram: optimize memory operations with clear_page()/copy_page()
>   zram: protect sysfs handler from invalid memory access

I reviewed your patchset roughly and I feel most of patches make sense
to me but some of that isn't not sure because you didn't write up the
possible scenario, expecially "zram: use zram->lock to protect zram_free_page()
in swap free notify path".

If your patchset fix real problem, it should go to the stable tree so
you need to write description up in detail.

So, please rewrite up description on all of patches and resend.
Thanks!
-- 
Kind regards,
Minchan Kim

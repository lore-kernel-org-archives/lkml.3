Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754700Ab3L0PHk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Dec 2013 10:07:40 -0500
Received: from mail-pb0-f50.google.com ([209.85.160.50]:49580 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753676Ab3L0PHj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Dec 2013 10:07:39 -0500
Date: Fri, 27 Dec 2013 23:07:24 +0800
From: Huang Shijie <shijie8@gmail.com>
To: Caizhiyong <caizhiyong@hisilicon.com>
Cc: "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        David Woodhouse <David.Woodhouse@intel.com>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Huang Shijie <b32955@freescale.com>,
        Rashika Kheria <rashika.kheria@gmail.com>,
        "Gupta, Pekon" <pekon@ti.com>,
        "Wanglin (Albert)" <albert.wanglin@hisilicon.com>,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH] mtd: nand: remove NAND_MAX_OOBSIZE and NAND_MAX_PAGESIZE
Message-ID: <20131227150721.GA1953@gmail.com>
References: <C3050A4DBA34F345975765E43127F10F25E480C3@SZXEMA512-MBX.china.huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C3050A4DBA34F345975765E43127F10F25E480C3@SZXEMA512-MBX.china.huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 27, 2013 at 01:03:32PM +0000, Caizhiyong wrote:
> From: Cai Zhiyong <caizhiyong@huawei.com>
> Date: Fri, 27 Dec 2013 20:23:09 +0800
> Subject: [PATCH] mtd: nand: remove NAND_MAX_OOBSIZE and NAND_MAX_PAGESIZE
> 
> remove NAND_MAX_OOBSIZE and NAND_MAX_PAGESIZE, dynamic allocate
> NAND buffer after detecting NAND writesize and oobsize.
> 
>  - save memory. when use MACRO allocate static buffer, use a small
>    page size NAND chip, the buffer is still 8k, the memory is wasted.
> 
>  - reduce maintenance. NAND chip pagesize and oobsize update frequently,
>    allocate buffer according to the detecting size will reduce maintenance.
> 
>  - this fix was suggested by Brian Norris [computersforpeace@gmail.com]
>                          and Huang Shijie [b32955@freescale.com]

I have already sent out a patch set to remove these macros several days ago. :(


thanks
Huang Shijie

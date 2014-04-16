Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753695AbaDPFJ5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 01:09:57 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:48100 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893AbaDPFJ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 01:09:56 -0400
Date: Tue, 15 Apr 2014 22:09:52 -0700
From: Brian Norris <computersforpeace@gmail.com>
To: Caizhiyong <caizhiyong@hisilicon.com>
Cc: "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "Wanglin (Albert)" <albert.wanglin@hisilicon.com>,
        Huang Shijie <b32955@freescale.com>,
        David Woodhouse <David.Woodhouse@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Subject: Re: [PATCH] mtd: nand: remove unused function input parameter
Message-ID: <20140416050952.GK3131@norris-Latitude-E6410>
References: <C3050A4DBA34F345975765E43127F10F25E47D50@SZXEMA512-MBX.china.huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C3050A4DBA34F345975765E43127F10F25E47D50@SZXEMA512-MBX.china.huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 25, 2013 at 12:40:50PM +0000, Caizhiyong wrote:
> From: Cai Zhiyong <caizhiyong@huawei.com>
> Date: Wed, 25 Dec 2013 20:11:15 +0800
> Subject: [PATCH] mtd: nand: remove unused function input parameter
> 
> The nand_get_flash_type parameter "busw" input value is not used by any
> branch, and it is updated before use it in the function, so remove it, 
> define the "busw" as an internal variable.
> 
> Signed-off-by: Cai Zhiyong <caizhiyong@huawei.com>

I merged this patch and sent it upstream for 3.15-rc1, but I don't think
I ever sent you a notification... here goes:

Applied, thanks!

Brian

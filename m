Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752129Ab3LMHtO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 02:49:14 -0500
Received: from mail-pb0-f44.google.com ([209.85.160.44]:50821 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750926Ab3LMHtM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 02:49:12 -0500
Date: Thu, 12 Dec 2013 23:49:08 -0800
From: Brian Norris <computersforpeace@gmail.com>
To: Caizhiyong <caizhiyong@hisilicon.com>
Cc: David Woodhouse <dwmw2@infradead.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        David Woodhouse <David.Woodhouse@intel.com>,
        Quyaxin <quyaxin@hisilicon.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Huang Shijie <b32955@freescale.com>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        "Wanglin (Albert)" <albert.wanglin@hisilicon.com>
Subject: Re: [PATCH] mtd: increase max page/OOB size to support 16K pagesize
 NAND
Message-ID: <20131213074908.GB24650@norris-Latitude-E6410>
References: <C3050A4DBA34F345975765E43127F10F25E47448@SZXEMA512-MBX.china.huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C3050A4DBA34F345975765E43127F10F25E47448@SZXEMA512-MBX.china.huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 13, 2013 at 05:01:56AM +0000, Caizhiyong wrote:
> The Toshiba's TC58TEG5DCJTA pagesize is 16K, oob size is 1280 bytes.
> So increase the NAND_MAX_OOBSIZE and NAND_MAX_PAGESIZE.
> 
> Signed-off-by: Huang Shijie <b32955@freescale.com>
> Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
> Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>

Huh? I hope you're not intentionally forging Signed-off-by lines...
Presumably the follow-up (re)send is because this one was an accident?

> Signed-off-by: Cai Zhiyong <caizhiyong@huawei.com>

Brian

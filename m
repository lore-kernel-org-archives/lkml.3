Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751521Ab3KJOIu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Nov 2013 09:08:50 -0500
Received: from mail-pd0-f171.google.com ([209.85.192.171]:42254 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374Ab3KJOIp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Nov 2013 09:08:45 -0500
Date: Sun, 10 Nov 2013 22:06:59 -0500
From: Huang Shijie <shijie8@gmail.com>
To: Caizhiyong <caizhiyong@hisilicon.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "fengguang.wu@intel.com" <fengguang.wu@intel.com>,
        Brian Norris <computersforpeace@gmail.com>,
        Artem Bityutskiy <dedekind1@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Karel Zak <kzak@redhat.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        Shmulik Ladkani <shmulik.ladkani@gmail.com>,
        "Wanglin (Albert)" <albert.wanglin@hisilicon.com>
Subject: Re: [PATCH 2/2] mtd: cmdlinepart: support master name is not set
 when parser partition
Message-ID: <20131111030657.GA9406@gmail.com>
References: <C3050A4DBA34F345975765E43127F10F1C08B3EA@szxeml512-mbs.china.huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C3050A4DBA34F345975765E43127F10F1C08B3EA@szxeml512-mbs.china.huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 09, 2013 at 11:43:06AM +0000, Caizhiyong wrote:
> From: Cai Zhiyong <caizhiyong@huawei.com>
> Date: Sat, 9 Nov 2013 17:54:12 +0800
>  
> @@ -143,5 +149,5 @@ MODULE_PARM_DESC(mtdparts, "Partitioning specification");
>  module_param(mtdparts, charp, 0);
>  
>  MODULE_LICENSE("GPL");
> -MODULE_AUTHOR("Marius Groeger <mag@sysgo.de>");
> +MODULE_AUTHOR("Cai Zhiyong <caizhiyong@huawei.com>");
I tested this patch with several cases, it is ok.

But is it neccessary to change the author line?

thanks
Huang Shijie

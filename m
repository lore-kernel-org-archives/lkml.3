Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752361Ab3KKDJv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Nov 2013 22:09:51 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:40804 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003Ab3KKDJn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Nov 2013 22:09:43 -0500
From: Caizhiyong <caizhiyong@hisilicon.com>
To: Huang Shijie <shijie8@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        "fengguang.wu@intel.com" <fengguang.wu@intel.com>,
        Brian Norris <computersforpeace@gmail.com>,
        "Artem Bityutskiy" <dedekind1@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Karel Zak <kzak@redhat.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        Shmulik Ladkani <shmulik.ladkani@gmail.com>,
        "Wanglin (Albert)" <albert.wanglin@hisilicon.com>
Subject: RE: [PATCH 2/2] mtd: cmdlinepart: support master name is not set
 when parser partition
Thread-Topic: [PATCH 2/2] mtd: cmdlinepart: support master name is not set
 when parser partition
Thread-Index: Ac7dQNrmaepPFNCzTfSQ2Rn2iobZJgBByziAAA+tr0A=
Date: Mon, 11 Nov 2013 03:08:26 +0000
Message-ID: <C3050A4DBA34F345975765E43127F10F1C08B4C1@szxeml512-mbs.china.huawei.com>
References: <C3050A4DBA34F345975765E43127F10F1C08B3EA@szxeml512-mbs.china.huawei.com>
 <20131111030657.GA9406@gmail.com>
In-Reply-To: <20131111030657.GA9406@gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.67.223.36]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Sat, Nov 09, 2013 at 11:43:06AM +0000, Caizhiyong wrote:
> > From: Cai Zhiyong <caizhiyong@huawei.com>
> > Date: Sat, 9 Nov 2013 17:54:12 +0800
> >
> > @@ -143,5 +149,5 @@ MODULE_PARM_DESC(mtdparts, "Partitioning specification");
> >  module_param(mtdparts, charp, 0);
> >
> >  MODULE_LICENSE("GPL");
> > -MODULE_AUTHOR("Marius Groeger <mag@sysgo.de>");
> > +MODULE_AUTHOR("Cai Zhiyong <caizhiyong@huawei.com>");
> I tested this patch with several cases, it is ok.

Thank you for test.

> 
> But is it neccessary to change the author line?

I rewrite this module, there may be some bugs or other problems, if I keep the original author,
I am afraid that someone care about this.

> 
> thanks
> Huang Shijie

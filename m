Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752009Ab3KJSJd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Nov 2013 13:09:33 -0500
Received: from top.free-electrons.com ([176.31.233.9]:33005 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751783Ab3KJSJ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Nov 2013 13:09:27 -0500
Date: Sun, 10 Nov 2013 15:09:02 -0300
From: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
To: Huang Shijie <shijie8@gmail.com>
Cc: Caizhiyong <caizhiyong@hisilicon.com>,
        "fengguang.wu@intel.com" <fengguang.wu@intel.com>,
        Artem Bityutskiy <dedekind1@gmail.com>,
        "Wanglin (Albert)" <albert.wanglin@hisilicon.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Karel Zak <kzak@redhat.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        Shmulik Ladkani <shmulik.ladkani@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Brian Norris <computersforpeace@gmail.com>
Subject: Re: [PATCH 2/2] mtd: cmdlinepart: support master name is not set
 when parser partition
Message-ID: <20131110180900.GA2478@localhost>
References: <C3050A4DBA34F345975765E43127F10F1C08B3EA@szxeml512-mbs.china.huawei.com>
 <20131111030657.GA9406@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20131111030657.GA9406@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 10, 2013 at 10:06:59PM -0500, Huang Shijie wrote:
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
> 

Can you summarize such cases? Or maybe better, just share them all :)
-- 
Ezequiel García, Free Electrons
Embedded Linux, Kernel and Android Engineering
http://free-electrons.com

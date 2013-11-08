Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757005Ab3KHJNw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 04:13:52 -0500
Received: from top.free-electrons.com ([176.31.233.9]:56072 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756971Ab3KHJNq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 04:13:46 -0500
Date: Fri, 8 Nov 2013 06:13:47 -0300
From: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
To: Caizhiyong <caizhiyong@hisilicon.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Brian Norris <computersforpeace@gmail.com>,
        "Wanglin (Albert)" <albert.wanglin@hisilicon.com>,
        Artem Bityutskiy <dedekind1@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Karel Zak <kzak@redhat.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        Shmulik Ladkani <shmulik.ladkani@gmail.com>
Subject: Re: [PATCH 2/2]  mtd: cmdlinepart: use cmdline partition parser lib
Message-ID: <20131108091216.GA2365@localhost>
References: <C3050A4DBA34F345975765E43127F10F1C0643B8@szxeml512-mbx.china.huawei.com>
 <20131020120603.GA18678@localhost>
 <C3050A4DBA34F345975765E43127F10F1C084C81@szxeml512-mbs.china.huawei.com>
 <20131105144328.fb5a6a1d423776b324771706@linux-foundation.org>
 <C3050A4DBA34F345975765E43127F10F1C08B274@szxeml512-mbs.china.huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <C3050A4DBA34F345975765E43127F10F1C08B274@szxeml512-mbs.china.huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 08, 2013 at 06:53:29AM +0000, Caizhiyong wrote:
> >> For further information, see "https://lkml.org/lkml/2013/8/6/550"
> > 
> > Thanks for doing this.  Could we please get some acked-by's or,
> > preferably, tested-by's from the MTD people?
> 
> Acked-by: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>

I don't remember acking this patch! Instead, I do remember asking
for the test results, prooving the this change has _no_ change of
behavior compared to the MTD parsing code:

https://lkml.org/lkml/2013/10/25/164

Such results was never posted and unless we see those, I think
I'd rather NACK this patch instead. I like the cleanup, but only
if it's guaranteed to _not_ brake things, specially when dealing
with a kernel parameter.
-- 
Ezequiel García, Free Electrons
Embedded Linux, Kernel and Android Engineering
http://free-electrons.com

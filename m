Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752995Ab3JYMJI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 08:09:08 -0400
Received: from top.free-electrons.com ([176.31.233.9]:54738 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751542Ab3JYMJH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 08:09:07 -0400
Date: Fri, 25 Oct 2013 09:09:01 -0300
From: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
To: Caizhiyong <caizhiyong@hisilicon.com>
Cc: Brian Norris <computersforpeace@gmail.com>,
        Quyaxin <quyaxin@hisilicon.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Wanglin (Albert)" <albert.wanglin@hisilicon.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mtd: cmdlinepart: use cmdline partition parser lib
Message-ID: <20131025120900.GF2489@localhost>
References: <C3050A4DBA34F345975765E43127F10F1C0643B8@szxeml512-mbx.china.huawei.com>
 <20131020120603.GA18678@localhost>
 <C3050A4DBA34F345975765E43127F10F1C084F26@szxeml512-mbs.china.huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <C3050A4DBA34F345975765E43127F10F1C084F26@szxeml512-mbs.china.huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Oct 25, 2013 at 11:52:14AM +0000, Caizhiyong wrote:
> > 
> > I'd like to review the patch in detail and test it, but being a bit old,
> > the patch doesn't apply as it is on v3.12-rc5. Care to resend an update?
> >
>   I have sent you a 2 patch base on v3.12-rc6. Are there any problems? I tested it for a long time and found no problems.
> 

I haven't had time to look at that yet, thanks for re-sending them!

If you already did testing using those, then I think we would all appreciate
that you post the results.

In particular, we're interested in **seeing** this change parses correctly
all possible combinations of partitions configured by the 'mtdparts' parameter.

This is a big change you're proposing and we need to be sure there won't
be any users experiencing any unexpected result while using 'mtdparts'.
-- 
Ezequiel García, Free Electrons
Embedded Linux, Kernel and Android Engineering
http://free-electrons.com

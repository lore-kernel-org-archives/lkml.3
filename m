Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753607AbaK0AHx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 19:07:53 -0500
Received: from mail-pd0-f175.google.com ([209.85.192.175]:55723 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752724AbaK0AHw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 19:07:52 -0500
Date: Wed, 26 Nov 2014 16:07:48 -0800
From: Brian Norris <computersforpeace@gmail.com>
To: zhangxingcai <zhangxingcai@huawei.com>
Cc: "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Fengfuqiu <fengfuqiu@huawei.com>, Tanhaijun <tanhaijun@huawei.com>
Subject: Re: =?utf-8?B?562U5aSNOiBbUEFUQw==?= =?utf-8?Q?H?= 3/3] [PATCH] mtd:
 fix concurrent access to mtd->usecount
Message-ID: <20141127000748.GF21347@ld-irv-0074>
References: <1417008990-24413-1-git-send-email-zhangxingcai@huawei.com>
 <20141126181030.GC21347@ld-irv-0074>
 <DFCD9FCD7B2D0148BC097DBCAE107A3327C764@SZXEML503-MBS.china.huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <DFCD9FCD7B2D0148BC097DBCAE107A3327C764@SZXEML503-MBS.china.huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Please don't top-post)

On Thu, Nov 27, 2014 at 12:04:52AM +0000, zhangxingcai wrote:
> I am sorry about it, it has only one patch indeed. 
> 
> because another two patch is not related to it, so it didn't display in the email.
> 
> Should I send-email again ?

No, at least not yet. I just wanted to make sure I wasn't missing
anything.

> -----邮件原件-----
> 发件人: Brian Norris [mailto:computersforpeace@gmail.com] 
> 发送时间: 2014年11月27日 2:11
> 收件人: zhangxingcai
> 抄送: dwmw2@infradead.org; linux-mtd@lists.infradead.org; linux-kernel@vger.kernel.org; Fengfuqiu; Tanhaijun
> 主题: Re: [PATCH 3/3] [PATCH] mtd: fix concurrent access to mtd->usecount
> 
> On Wed, Nov 26, 2014 at 09:36:30PM +0800, zhangxingcai wrote:
> [...]
> 
> What series is this patch 3/3 of? It looks like it stands alone, and I wasn't CC'd on anything else related to it.

Brian

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752571AbaBLBA3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 20:00:29 -0500
Received: from mail-vb0-f43.google.com ([209.85.212.43]:51048 "EHLO
	mail-vb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750978AbaBLBA2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 20:00:28 -0500
MIME-Version: 1.0
In-Reply-To: <20140211155440.62c5e90eb498ec2964258969@linux-foundation.org>
References: <52F592F2.6010008@huawei.com>
	<52F5934B.4000101@huawei.com>
	<20140211155440.62c5e90eb498ec2964258969@linux-foundation.org>
Date: Tue, 11 Feb 2014 17:00:27 -0800
Message-ID: <CAN8TOE-fCLM4_7rez=jdVBmav0D2dnqO56mPCNQoG4AGgSiwbw@mail.gmail.com>
Subject: Re: [PATCH 2/3] jffs2: avoid soft-lockup in jffs2_reserve_space_gc()
From: Brian Norris <computersforpeace@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Li Zefan <lizefan@huawei.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        David Woodhouse <dwmw2@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Artem Bityutskiy <dedekind1@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

On Tue, Feb 11, 2014 at 3:54 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Sat, 8 Feb 2014 10:15:39 +0800 Li Zefan <lizefan@huawei.com> wrote:
> I now have four jffs2 bugfixes but cannot unload them on anyone.
> Waddup?

Well, at best we have 3 "maintainers" involved in MTD (David, Artem,
and me), but David is often quite unresponsive unless you yell, and
Artem has more or less left non-UBI/UBIFS stuff to me. I personally
have little knowledge of JFFS2, and I have seen a fair number of
dubious JFFS2 patches from people with automated tools and no testing.
So I'm understandably cautious to merge them. But if you have properly
tested (or at least reviewed) patches sitting around, I can take a
look at them and merge them. Are you referring to the top 4 here?

http://www.spinics.net/linux/lists/mm-commits/

Brian

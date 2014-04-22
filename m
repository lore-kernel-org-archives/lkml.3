Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756336AbaDVNoZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 09:44:25 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:42386 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756315AbaDVNoS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 09:44:18 -0400
MIME-Version: 1.0
In-Reply-To: <20140422100505.GB937@swordfish.minsk.epam.com>
References: <1397922764-1512-1-git-send-email-ddstreet@ieee.org>
 <1397922764-1512-4-git-send-email-ddstreet@ieee.org> <20140422100505.GB937@swordfish.minsk.epam.com>
From: Dan Streetman <ddstreet@ieee.org>
Date: Tue, 22 Apr 2014 09:43:56 -0400
X-Google-Sender-Auth: A5PuUQ9gWX0G2KK_GANOlDAMyXM
Message-ID: <CALZtONDk0UOBwUNGppDCW0fk2kGtAdwoKq6mmWTOO5nihatdwQ@mail.gmail.com>
Subject: Re: [PATCH 3/4] mm: zpool: implement common zpool api to zbud/zsmalloc
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Seth Jennings <sjennings@variantweb.net>, Minchan Kim <minchan@kernel.org>,
        Nitin Gupta <ngupta@vflare.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Bob Liu <bob.liu@oracle.com>, Hugh Dickins <hughd@google.com>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Weijie Yang <weijie.yang@samsung.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Linux-MM <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2014 at 6:05 AM, Sergey Senozhatsky
<sergey.senozhatsky@gmail.com> wrote:
> Hello,
>> diff --git a/mm/Makefile b/mm/Makefile
>> index 60cacbb..4135f7c 100644
>> --- a/mm/Makefile
>> +++ b/mm/Makefile
>> @@ -60,6 +60,7 @@ obj-$(CONFIG_DEBUG_KMEMLEAK_TEST) += kmemleak-test.o
>>  obj-$(CONFIG_CLEANCACHE) += cleancache.o
>>  obj-$(CONFIG_MEMORY_ISOLATION) += page_isolation.o
>>  obj-$(CONFIG_PAGE_OWNER) += pageowner.o
>> +obj-$(CONFIG_ZPOOL)  += zpool.o
>
> side note, this fails to apply on linux-next. mm/Makefile does not contain
> CONFIG_PAGE_OWNER
>
> https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/tree/mm/Makefile?id=refs/tags/next-20140422
>
> what tree this patchset is against of?

It's against this mmotm tree:
git://git.cmpxchg.org/linux-mmotm.git

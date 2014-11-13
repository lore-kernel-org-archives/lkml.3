Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933174AbaKMNyV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 08:54:21 -0500
Received: from mail-oi0-f51.google.com ([209.85.218.51]:57322 "EHLO
	mail-oi0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932868AbaKMNyT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 08:54:19 -0500
MIME-Version: 1.0
In-Reply-To: <20141113000216.GA1074@bbox>
References: <1415803038-7913-1-git-send-email-opensource.ganesh@gmail.com>
	<20141113000216.GA1074@bbox>
Date: Thu, 13 Nov 2014 21:54:19 +0800
Message-ID: <CADAEsF-VBUBivo0j2cmxHHPzM7rkZOCfis9kzZNZG25YnA2YrA@mail.gmail.com>
Subject: Re: [PATCH] mm/zram: correct ZRAM_ZERO flag bit position
From: Ganesh Mahendran <opensource.ganesh@gmail.com>
To: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>, weijie.yang@samsung.com,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-11-13 8:02 GMT+08:00 Minchan Kim <minchan@kernel.org>:
> On Wed, Nov 12, 2014 at 10:37:18PM +0800, Mahendran Ganesh wrote:
>> In struct zram_table_entry, the element *value* contains obj size and
>> obj zram flags. Bit 0 to bit (ZRAM_FLAG_SHIFT - 1) represent obj size,
>> and bit ZRAM_FLAG_SHIFT to the highest bit of unsigned long represent obj
>> zram_flags. So the first zram flag(ZRAM_ZERO) should be from ZRAM_FLAG_SHIFT
>> instead of (ZRAM_FLAG_SHIFT + 1).
>>
>> This patch fixes this issue.
>>
>> Also this patch fixes a typo, "page in now accessed" -> "page is now accessed"
>>
>> Signed-off-by: Mahendran Ganesh <opensource.ganesh@gmail.com>
> Acked-by: Minchan Kim <minchan@kernel.org>

Thanks!

>
> To be clear about "fixes this issue", it's not a bug but just clean up
> so it doesn't change any behavior.
>
> Thanks!
>
> --
> Kind regards,
> Minchan Kim

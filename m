Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932268AbbA0BnR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 20:43:17 -0500
Received: from mail-oi0-f47.google.com ([209.85.218.47]:50664 "EHLO
	mail-oi0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932202AbbA0Bm4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 20:42:56 -0500
MIME-Version: 1.0
In-Reply-To: <20150126154506.GA528@blaptop>
References: <1422107153-9701-1-git-send-email-opensource.ganesh@gmail.com>
	<20150126154506.GA528@blaptop>
Date: Tue, 27 Jan 2015 09:42:55 +0800
Message-ID: <CADAEsF8MvAWp20KCZp2Z2MSF3fXah-1+ehxsH0wBRQnzJRZ3Vg@mail.gmail.com>
Subject: Re: [PATCH] zram: free meta table in zram_meta_free
From: Ganesh Mahendran <opensource.ganesh@gmail.com>
To: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>, Andrew Morton <akpm@linux-foundation.org>,
        Linux-MM <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Minchan

2015-01-26 23:45 GMT+08:00 Minchan Kim <minchan@kernel.org>:
> Hello,
>
> On Sat, Jan 24, 2015 at 09:45:53PM +0800, Ganesh Mahendran wrote:
>> zram_meta_alloc() and zram_meta_free() are a pair.
>> In zram_meta_alloc(), meta table is allocated. So it it better to free
>> it in zram_meta_free().
>>
>> Signed-off-by: Ganesh Mahendran <opensource.ganesh@gmail.com>
>> Cc: Nitin Gupta <ngupta@vflare.org>
>> Cc: Minchan Kim <minchan@kernel.org>
>
> Looks good to me but it seems the patch is based on my recent work
> "zram: free meta out of init_lock".
> Please resend it on recent mmotm because I will respin my patch and
> your patch is orthogonal with mine.

OK, I will resend the patch. Thanks.

>
> Thanks.

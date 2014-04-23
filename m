Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753713AbaDWCcd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 22:32:33 -0400
Received: from mail-ig0-f176.google.com ([209.85.213.176]:34756 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751154AbaDWCcb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 22:32:31 -0400
MIME-Version: 1.0
In-Reply-To: <20140422125539.f40a414ca0dbae703a23b977@linux-foundation.org>
References: <000001cf5dd8$ecf1c360$c6d54a20$%yang@samsung.com>
	<20140422125539.f40a414ca0dbae703a23b977@linux-foundation.org>
Date: Wed, 23 Apr 2014 10:32:30 +0800
Message-ID: <CAL1ERfM2VGyNUGYdQQyEyqyycnPMoHZn5Vk2Fo3WXL37KmFzCA@mail.gmail.com>
Subject: Re: [PATCH] zram: correct offset usage in zram_bio_discard
From: Weijie Yang <weijie.yang.kh@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Weijie Yang <weijie.yang@samsung.com>, Minchan Kim <minchan@kernel.org>,
        Nitin Gupta <ngupta@vflare.org>, iamjoonsoo.kim@lge.com,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Bob Liu <bob.liu@oracle.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 23, 2014 at 3:55 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Tue, 22 Apr 2014 11:14:02 +0800 Weijie Yang <weijie.yang@samsung.com> wrote:
>
>> we want to skip the logical block which is partially covered by
>> the discard bio, so check the remaining size and subtract it if
>> there is a need to goto the next logical block.
>>
>> This patch corrects the offset usage in zram_bio_discard.
>>
>
> What were the end-user visible effects of the bug?
>
> Please always include this information when fixing something so that
> others can work out which kernel(s) need patching.
>

Thanks for your advise, I will resend this patch and add the end-user
visible effect information.

> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

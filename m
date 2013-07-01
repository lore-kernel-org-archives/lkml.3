Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755706Ab3GAWDU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 18:03:20 -0400
Received: from mail-ee0-f44.google.com ([74.125.83.44]:61361 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755057Ab3GAWDS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 18:03:18 -0400
Message-ID: <51D1FCA1.10004@gmail.com>
Date: Tue, 02 Jul 2013 00:03:13 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Jason Cooper <jason@lakedaemon.net>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] DMA: Fix Marvell Orion and mv_xor after MEMSET removal
References: <1372690589-2218-1-git-send-email-sebastian.hesselbarth@gmail.com> <20130701150407.GB19937@titan.lakedaemon.net> <20130701124205.9571b26975c1910ce5afa896@linux-foundation.org> <20130701213706.GF19937@titan.lakedaemon.net> <20130701144106.cf0cff602dbff596bf364de0@linux-foundation.org>
In-Reply-To: <20130701144106.cf0cff602dbff596bf364de0@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/01/2013 11:41 PM, Andrew Morton wrote:
> On Mon, 1 Jul 2013 17:37:06 -0400 Jason Cooper<jason@lakedaemon.net>  wrote:
>
>>>> Please take a look at the email from lkml I just forwarded to you.  I
>>>> believe this solves your problem, but I don't have time to look closely
>>>> atm.
>>>
>>> Unhelpful.  Can the rest of us see this email as well please?
>>
>> Sorry about that, the thread I was referring to on lkml was here:
>>
>> http://comments.gmane.org/gmane.linux.kernel/1516018
>>
>> And the specific email I was referring to is here (second version of
>> Bartlomiej's patch which addresses what Sebastian was attempting to fix):
>>
>> http://permalink.gmane.org/gmane.linux.kernel/1517735
>
> Ah, OK, I have that:
>
> http://ozlabs.org/~akpm/mmots/broken-out/drivers-dma-remove-unused-support-for-memset-operations.patch

I guess, that is what is in next-20130701? My patch was based on it.

> http://ozlabs.org/~akpm/mmots/broken-out/drivers-dma-remove-unused-support-for-memset-operations-v3.patch

Bartlomeij sent another patch with all remaining differences between my
patch and the both above: https://lkml.org/lkml/2013/7/1/397

Sebastian

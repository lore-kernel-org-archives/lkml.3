Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752190AbaABUP3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 15:15:29 -0500
Received: from merlin.infradead.org ([205.233.59.134]:58611 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751210AbaABUP2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 15:15:28 -0500
Message-ID: <52C5C8B0.9080505@kernel.dk>
Date: Thu, 02 Jan 2014 13:14:40 -0700
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Geoff Levand <geoff@infradead.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>
CC: Jim Paris <jim@jtan.com>, linuxppc-dev@lists.ozlabs.org,
        cbe-oss-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] block/ps3: Remove obsolete reference to MTD
References: <1388394463-25798-1-git-send-email-geert@linux-m68k.org> <1388688375.32559.9.camel@smoke>
In-Reply-To: <1388688375.32559.9.camel@smoke>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/02/2014 11:46 AM, Geoff Levand wrote:
> On Mon, 2013-12-30 at 10:07 +0100, Geert Uytterhoeven wrote:
>> The ps3vram driver is a plain block device driver since commit
>> f507cd22035fdadd5dbb476dd05e9e7ee21c3b84 ("ps3/block: Replace mtd/ps3vram
>> by block/ps3vram").
>>
>> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
>> ---
>>  drivers/block/ps3vram.c |    2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/block/ps3vram.c b/drivers/block/ps3vram.c
>> index 06a2e53e5f37..313ee641ea10 100644
>> --- a/drivers/block/ps3vram.c
>> +++ b/drivers/block/ps3vram.c
>> @@ -1,5 +1,5 @@
>>  /*
>> - * ps3vram - Use extra PS3 video ram as MTD block device.
>> + * ps3vram - Use extra PS3 video ram as block device.
>>   *
>>   * Copyright 2009 Sony Corporation
>>   *
> 
> Looks good.
> 
> Jens, could you please apply.
> 
> Acked-by: Geoff Levand <geoff@infradead.org>

Yup will do, thanks.

-- 
Jens Axboe


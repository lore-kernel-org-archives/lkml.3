Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751329AbaKGJxq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 04:53:46 -0500
Received: from a.ns.miles-group.at ([95.130.255.143]:65275 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750957AbaKGJxm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 04:53:42 -0500
Message-ID: <545C96A1.40304@nod.at>
Date: Fri, 07 Nov 2014 10:53:37 +0100
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: dedekind1@gmail.com
CC: Christoph Hellwig <hch@infradead.org>, axboe@fb.com,
        ezequiel.garcia@free-electrons.com, dwmw2@infradead.org,
        computersforpeace@gmail.com, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] UBI: Block: Add blk-mq support
References: <1414933255-3795-1-git-send-email-richard@nod.at>	 <20141103081821.GA5261@infradead.org> <54573B72.1060600@nod.at> <1415353596.958.302.camel@sauron.fi.intel.com>
In-Reply-To: <1415353596.958.302.camel@sauron.fi.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 07.11.2014 um 10:46 schrieb Artem Bityutskiy:
> On Mon, 2014-11-03 at 09:23 +0100, Richard Weinberger wrote:
>> Am 03.11.2014 um 09:18 schrieb Christoph Hellwig:
>>> On Sun, Nov 02, 2014 at 02:00:55PM +0100, Richard Weinberger wrote:
>>>> +#define UBIBLOCK_SG_COUNT 64
>>>
>>>
>>> Can you document why you choose this number? The default nr_request
>>> for the old code would be 128.
>>
>> Is 64 a problem? Beside of the fact that I forgot to set blk_queue_max_segments().
>> I used this number because 128 seemed a bit high and my goal was to
>> keep the memory footprint small.
>> This is also why I've set tag_set.queue_depth to 64.
> 
> The request was to document, so lets' document the choice.

Of course I'll document it. But so far I had no time to do a
v2 of this patch.

Thanks,
//richard

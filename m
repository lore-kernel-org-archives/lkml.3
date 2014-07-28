Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752656AbaG1OHz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 10:07:55 -0400
Received: from mail-oa0-f48.google.com ([209.85.219.48]:35711 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751999AbaG1OHw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 10:07:52 -0400
MIME-Version: 1.0
In-Reply-To: <CAJyon0sLb-j8K=-=3ozTTuJkE8y6DctCxJ2+Kj+aUKrhB=OZTg@mail.gmail.com>
References: <20140728071332.GA3822@gmail.com>
	<20140728125319.GA537@infradead.org>
	<CAJyon0sLb-j8K=-=3ozTTuJkE8y6DctCxJ2+Kj+aUKrhB=OZTg@mail.gmail.com>
Date: Mon, 28 Jul 2014 18:07:52 +0400
Message-ID: <CAHj3AVmzqzZyDfo_ka6jRs81iq2nfH81HYvjb2TbyEPKjFOZgA@mail.gmail.com>
Subject: Re: Eudyptula Challenge (Task 10)
From: Denis Kirjanov <kirjanov@gmail.com>
To: Lucas Tanure <tanure@linux.com>
Cc: Christoph Hellwig <hch@infradead.org>, devel@driverdev.osuosl.org,
        liang.zhen@intel.com, "Liviu I." <liviu.i.2222@gmail.com>,
        uja.ornl@gmail.com, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, amk@cray.com, rashika.kheria@gmail.com,
        emoly.liu@intel.com, Denis Kirjanov <kda@linux-powerpc.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/28/14, Lucas Tanure <tanure@linux.com> wrote:
> Hi Christoph,
>
> What kind of things that you think a newbie can fix ?

You can start working on fixing the pci_map_* and dma_map_* return
value checks with CONFIG_DMA_API_DEBUG enabled. A lot of drivers still
missing that...

> Thanks
> --
> Lucas Tanure
> +55 (19) 988176559
>
>
> On Mon, Jul 28, 2014 at 9:53 AM, Christoph Hellwig <hch@infradead.org>
> wrote:
>> Can you folks please stop this challenge Bullshit?  More checkpatch
>> fixes is not something we'll need at all.
>>
>> Thanks you!
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel"
>> in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
> _______________________________________________
> devel mailing list
> devel@linuxdriverproject.org
> http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel
>


-- 
Regards,
Denis

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751616AbaKVLtd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2014 06:49:33 -0500
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:40276 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751366AbaKVLtb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2014 06:49:31 -0500
Message-ID: <5470784A.9020505@kernel.org>
Date: Sat, 22 Nov 2014 11:49:30 +0000
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Daniel Baluta <daniel.baluta@intel.com>
CC: "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] kmx61: Small cleanups
References: <1416230316-14511-1-git-send-email-daniel.baluta@intel.com>	<F244A294-8B78-4A9C-BB0B-268AFCC3EC5C@kernel.org> <CAEnQRZCa07iOt5baDHaH4-wNNYsP7rOf5Sixs+yndNo5-OP4kQ@mail.gmail.com>
In-Reply-To: <CAEnQRZCa07iOt5baDHaH4-wNNYsP7rOf5Sixs+yndNo5-OP4kQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17/11/14 15:09, Daniel Baluta wrote:
> On Mon, Nov 17, 2014 at 4:59 PM, Jonathan Cameron <jic23@kernel.org> wrote:
>>
>>
>> On November 17, 2014 1:18:34 PM GMT+00:00, Daniel Baluta <daniel.baluta@intel.com> wrote:
>>> This is a small cleanup patchset, that:
>>>       * makes it clear that kmx61 uses only the micro part of scale
>>>       * use macro instead of hardcoded value for driver name
>>>
>>> Jonathan, if you think it's worth it, these could be squased together
>>> with
>>> the initial patch submitted in testing:
>>>       61ef04a496 (iio: imu: Add support for Kionix KMX61 sensor)
>>>
>>
>> Given the additional bits from Peter, I don't mind pulling the original and applying an updated patch.
> 
> I prefer this :). I will send an updated patch with fixes reported by Peter.
> 
>>
>> Additional changes like this are fine as well if you prefer.
> 
> I am almost done with adding support for runtime PM. Let me know
> if you want this as a separate patch or just one big updated patch.
Oops. I moaned about the unified patch, but didn't actually get around
to replying to you.  Was fine either way really.

Note to anyone reading this patch series - the unified patch for
adding the driver with all these changes in place has now been applied.

Jonathan
> 
> Daniel.
> 


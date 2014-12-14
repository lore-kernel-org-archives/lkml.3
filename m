Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751935AbaLNBHW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2014 20:07:22 -0500
Received: from mail-lb0-f176.google.com ([209.85.217.176]:57057 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750949AbaLNBHV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2014 20:07:21 -0500
MIME-Version: 1.0
In-Reply-To: <CA+i8gKKGBviLBaS8b=swqv2OWgh2Uc+m-TT8LVYcPehcYd903A@mail.gmail.com>
References: <CA+i8gKK0sj55s-Gk8Y36KM4yBFLvLotffbSodjH5Gsd_yxd5Sg@mail.gmail.com>
	<CAKMK7uGa_dHnie8EACcX0mQvc-uGpsgQHjWGN_obxPa3O6SJbw@mail.gmail.com>
	<CA+i8gKKGBviLBaS8b=swqv2OWgh2Uc+m-TT8LVYcPehcYd903A@mail.gmail.com>
Date: Sun, 14 Dec 2014 02:07:19 +0100
Message-ID: <CA+i8gKJPPPUXrxY5q+81xZG91azygoUb27R_Wid3GTpb3-1-rw@mail.gmail.com>
Subject: Re: [Regression] 83f45fc turns machine's screen off
From: Emmanuel Benisty <benisty.e@gmail.com>
To: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dave Airlie <airlied@linux.ie>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        dri-devel <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel,

> On Mon, Nov 10, 2014 at 10:19 PM, Daniel Vetter <daniel.vetter@ffwll.ch> wrote:
>> Adding relevant mailing lists.
>>
>>
>> On Sat, Nov 8, 2014 at 7:34 PM, Emmanuel Benisty <benisty.e@gmail.com> wrote:
>>> Hi,
>>>
>>> The following commit permanently turns my screen off when x server is
>>> started (i3 330M Ironlake):
>>>
>>>     [83f45fc360c8e16a330474860ebda872d1384c8c] drm: Don't grab an fb
>>> reference for the idr
>>>
>>> Reverting this commit fixed the issue.
>>
>> This is definitely unexpected. I think we need a bit more data to
>> figure out what's going on here:
>> - Please boot with drm.debug=0xe added to your kernel cmdline and grab
>> the dmesg right after boot-up for both a working or broken kernel.
>
> Please see attached files.
>
>> - Are you using any special i915 cmdline options?
>
> Nope.

Is there anything else I could provide to help fixing this issue? It's
still in Linus' tree.

Thanks in advance.

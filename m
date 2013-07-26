Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759857Ab3GZUrI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 16:47:08 -0400
Received: from mail-qc0-f173.google.com ([209.85.216.173]:49010 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759648Ab3GZUrF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 16:47:05 -0400
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:1b02:6e3b:e5ff:fe16:f1aa]
In-Reply-To: <20130726203012.GB14077@radagast>
References: <1374605750-29565-1-git-send-email-olof@lixom.net>
	<20130725161406.GD31835@radagast>
	<CAOesGMiupSqpqfyuJ_abr4UQj9Ot77aGJZTsCEY63v-XttgPgw@mail.gmail.com>
	<20130725171951.GD25415@radagast>
	<CAOesGMgn0H4pteeWQcBzcccHr+F9Cf=Y+wvKHr2gCMfBBieOWg@mail.gmail.com>
	<20130726095437.GB2970@radagast>
	<CAOesGMgJsSjf7McOMTHd4E2yoxuxEjqp+DE-CxB4nuEY0gMOzg@mail.gmail.com>
	<20130726203012.GB14077@radagast>
Date: Fri, 26 Jul 2013 13:47:03 -0700
Message-ID: <CAOesGMixLQffPNxcrp+RhG9QSzLDsxy=BSvHVyM=8azUdW4tEQ@mail.gmail.com>
Subject: Re: [PATCH] usb: gadget: at91_udc: Check gpio lookup results
From: Olof Johansson <olof@lixom.net>
To: Felipe Balbi <balbi@ti.com>
Cc: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 26, 2013 at 1:30 PM, Felipe Balbi <balbi@ti.com> wrote:
> On Fri, Jul 26, 2013 at 09:23:35AM -0700, Olof Johansson wrote:
>> On Fri, Jul 26, 2013 at 2:54 AM, Felipe Balbi <balbi@ti.com> wrote:
>> > On Thu, Jul 25, 2013 at 01:59:51PM -0700, Olof Johansson wrote:
>> >> On Thu, Jul 25, 2013 at 10:19 AM, Felipe Balbi <balbi@ti.com> wrote:
>> >> > On Thu, Jul 25, 2013 at 09:18:39AM -0700, Olof Johansson wrote:
>> >> >> That's what the code does today, and I wasn't trying to second-guess
>> >> >> their decisions on that. Chances are firmware, in some instances, have
>> >> >> left power on so continuing might do no harm.
>> >> >
>> >> > fair enough, then let's just decrease the error message level to debug
>> >> > or info.
>> >>
>> >> Fair enough. info seems appropriate (or warn). Want me to respin, or
>> >> can you edit when you apply?
>> >
>> > please respin
>>
>> An older patch from Arnd that accomplishes the same warning removal
>> has mysteriously showed up in -next in the last couple of days
>> (ae40d64b1f2db93d7b092e6425a2f716289fbd09), even though commit date
>> was July 15.
>>
>> So, might as well, drop this one.
>
> doesn't look like the same thing:

No, not the same patch, but fixes the same warning as a result. Please
stick to the patch from Arnd that you've already applied.


Thanks,

-Olof

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756223AbaGTDKM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2014 23:10:12 -0400
Received: from mail-vc0-f182.google.com ([209.85.220.182]:35397 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752158AbaGTDKK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2014 23:10:10 -0400
MIME-Version: 1.0
In-Reply-To: <53CB1113.5020202@gmail.com>
References: <CAPDOMVhiHNBB_j6hEH6LMDvgEp+7-of3xEOeK6Y-QZuU3Xkt5w@mail.gmail.com>
	<CAPDOMVgo9nvB0g+C49-iJMRLUN_Ho60Q-7qB2G4O0CgOxpdjNg@mail.gmail.com>
	<53CB1113.5020202@gmail.com>
Date: Sat, 19 Jul 2014 23:10:09 -0400
Message-ID: <CAPDOMVjtdstKXYsE7X2tmdf9f5S3B5ZN5qG93t3CrGVmQGY8bQ@mail.gmail.com>
Subject: Re: Intel Graphics Drivers
From: Nick Krause <xerofoify@gmail.com>
To: "Roberto J. Dohnert" <rjdohnert@gmail.com>
Cc: daniel.vetter@ffwll.ch, jani.nikula@linux.intel.com, airlied@linux.ie,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 19, 2014 at 8:45 PM, Roberto J. Dohnert <rjdohnert@gmail.com> wrote:
> This would probably be a better question for the Intel developers than the
> kernel developers per say, but a great question nonetheless.  The Intel
> video drivers are perhaps the best supported on Linux. Most of the hardware
> I ship does ship with Intel cards so in regards to performance, this would
> be something I would like to see improve as well.
>
> Thanks,
>
> Roberto J. Dohnert
> Lead Developer
> Black Lab Software Inc.
> PO Box 698
> Franklinton NC 27525
> http://www.pc-opensystems.com
> http://www.blacklablinux.org
>
>
> On 07/19/2014 06:54 PM, Nick Krause wrote:
>>
>> On Sat, Jul 19, 2014 at 6:32 PM, Nick Krause <xerofoify@gmail.com> wrote:
>>   Hey Daniel and others ,
>>   If I am correct after asking around on the mailing list then  the
>> windows  Intel graphics drivers are faster then their Linux
>> counterparts.
>>   In addition , I  am wondering if we can improve this and try to
>> remove regressions in this area of graphics  support as this seems to
>> be
>>   the main issue and perhaps the hardware is hard to come by outside of
>> Intel or the board manufacturers as we seem to have no hardware
>>   for testing as I asked before . I don't have the hardware but if
>> people help do the hardware testing  and maybe a bit of advice and
>> guidance
>>   as I am new to the graphics stack in the kernel  I can help out  :).
>> If not that's Ok too just thought it may be of help.
>> Cheers Nick
>> P.S. Sorry about first email it wasn't edited. :(
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>>
>

Our you sure there aren't Intel devolopers who do this on the lkml?
I do known however that the nvidia and amd drivers are being, while
not opened are being optimized for Linux and are now more stable
and faster in most benchmarks by like 20% only after four months
of development  on a gtx 780. I would like to see the same work
coming into the Intel drivers. Overall in terms of hardware support
we are way better then Windows expect for a few areas ,which
I will list below.
1. Nvidia Graphics can be faster then Windows( improving fast,
probably will happen in next few months)
    Removed no overclocking support
2. Amd Graphics(same as above )
    Removed no overclocking support
3.Intel Graphics(needs lots of work)
4. Printers and Scanners ( need more support from vendors)
5. Laptops( Mostly battery is shorter on a few laptops then in
Windows) and maybe hdmi and touchscreen  support?
   Otherwise we are good here and have removed are issues with  Nvidia
optimus not be supported
6. Gaming Mice and Keyboards

Cheers Nick

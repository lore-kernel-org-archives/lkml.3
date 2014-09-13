Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752037AbaIMPcx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2014 11:32:53 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:62266 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751948AbaIMPcv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2014 11:32:51 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <20140913152438.GA3072@kroah.com>
References: <CA+icZUW8vHj9_L-4WD0FR6mUTWW621T5O-Cd=fSJ_UoPX0BQUg@mail.gmail.com>
	<20140913152438.GA3072@kroah.com>
Date: Sat, 13 Sep 2014 17:32:50 +0200
Message-ID: <CA+icZUX0vNpi7F-P8RAqzqPWhS2pD+XdppHXcEeKy=W94n+jxA@mail.gmail.com>
Subject: Re: linux-3.16.y: acpi-battery fixes
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        =?UTF-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 13, 2014 at 5:24 PM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Sat, Sep 13, 2014 at 02:52:52PM +0200, Sedat Dilek wrote:
>> Hi Greg,
>>
>> I hoped the acpi-fixes from [1] (especially [2]) would fix my shown
>> "85% battery available", but a Ubuntu/trusty kernel reports the same
>> (battery defect?).
>> The 2nd revert is applicable, the 1st not, both are labeled with 3.16+.
>>
>> Wanna pick them or have it already on your to-do?
>>
>> Thanks.
>>
>> Regards,
>> - Sedat -
>>
>> [1] http://git.kernel.org/cgit/linux/kernel/git/rafael/linux-pm.git/log/?h=acpi-battery
>> [2] http://git.kernel.org/cgit/linux/kernel/git/rafael/linux-pm.git/commit/?h=acpi-battery&id=508b3c677601797f2d51df3df5caa436dd235cb9
>
> First off, stable kernel questions should go to stable@vger.kernel.org,
> not just to me.
>
> Secondly, I don't understand what you are asking here.  What exact fix
> in Linus's tree do you want to see in a stable backport that I haven't
> taken already?  I've queued up a number of ACPI fixes for 3.16.3, are
> they not sufficient?
>
> thanks,
>

Sorry, if I was nor precise enough and forgot about CCing the
linux-stable email-address.

With jumping to Linux v3.16.y I have 1st seen that my battery reports
85% whereas the LED shows me it's full (green vs. charging orange).
So, I hoped the fix from Bjorn fixes the issue for me but did not help here.
Those acpi-battery fixes are labeled for 3.16+, don't you get them
automatically and consider for inclusion?

No, I did not try the pending ACPI patches in the stable-queue tree.
Is there a stable-review v3.16.3-rc1 around?

- Sedat -

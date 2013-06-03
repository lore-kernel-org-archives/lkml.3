Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759070Ab3FCPxc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 11:53:32 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:65081 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759032Ab3FCPxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 11:53:25 -0400
MIME-Version: 1.0
In-Reply-To: <CA+xJJ1_kT+jW-R+CVT_Z=Ek-2j87dhqK21=NOsLf+Wqo=M55bA@mail.gmail.com>
References: <CAAWiN8oSfH9fZVvnMtfehaY+D-9qhtqu4fwedVOv5Q-uB0WNYw@mail.gmail.com>
	<CA+xJJ1_kT+jW-R+CVT_Z=Ek-2j87dhqK21=NOsLf+Wqo=M55bA@mail.gmail.com>
Date: Mon, 3 Jun 2013 17:53:24 +0200
Message-ID: <CAFLxGvwxPnzTQ+SCjQeHgTBOKmfyahy-oXz66xCXB2EW3J2AXw@mail.gmail.com>
Subject: Re: Why Linux OS Desktop is not popular?
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: Mats Liljegren <liljegren.mats2@gmail.com>
Cc: Amit C <amit.linux.os.desktop@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please don't feed the trolls.

On Mon, Jun 3, 2013 at 5:43 PM, Mats Liljegren
<liljegren.mats2@gmail.com> wrote:
> On Tue, May 28, 2013 at 11:42 AM, Amit C
> <amit.linux.os.desktop@gmail.com> wrote:
>> Hi All,
>>
>> Linux OS Desktop has not become very popular because of the following reasons:
>>
>> 1. It is not because its GUI is not good.
>> 2. It is because if I buy a new gadget/device/hardware, I am not sure
>> whether it will work with Linux Desktop.
>> 3. The reason for number 2 is that the vendor introducing
>> gadget/device/hardware does not write a device driver for Linux.
>> 4. The reason for number 3 is that developing new device driver on
>> linux is hard.
>> 5. The way to solve number 4 is to move to data oriented device driver
>> development where the framework for driver is already available for
>> all kinds of devices (PCI, USB, Firewire, etc.) and the only thing a
>> device driver developer has to do is to collect io/virtual addresses
>> from the vendor/manual and feed into a table (structure of structures,
>> etc.) and the framework will pick up this data and configure the new
>> gadget/device/hardware instantly.
>>
>> I do not want to pay for Microsoft OS but can Linux community give me
>> a usable Linux Desktop. I have both Windows and Linux on my laptop and
>> I use Microsoft just to connect to Internet because the USB dongle
>> that I use for connecting to Internet does not work on Linux. I am in
>> India and here USB dongles connecting to Internet are very popular
>> because you can use them anywhere.
>
> The big difference between Windows and Linux is that Windows is
> developed by a single company, while Linux is developed by a community
> including several companies as well as hobbyists. You can become part
> of this community by participating in the development. It is not as
> easy to become part of developing Windows.
>
> The way Linux progress is by people realizing they have a pain they
> want to fix. The fix is done with one or several patches. If the
> maintainers like the patches, they become part of Linux. This is how
> these pains are fixed.
>
> You start this by experimenting for yourself until you've found a
> solution you like. Then you send out patch(es) labeled "RFC" (Request
> For Comments) to LKML to see if people think your idea will work.
> There is a long way to go then until it actually ends up in the kernel
> since there is a lot of quality assurance needed to be done, but
> eventually the pain gets solved.
>
> It is very hard to discuss any solutions without those RFC patches,
> since no one knows whether the idea will work or exactly what the idea
> consists of. So it's unlikely you'll get much constructive response
> until you've tested the solution yourself and sent out patches for
> comments so others might test it. Just keep it as small as possible
> while still proving the idea.
>
> I look forward to your patches, so I can better understand what you
> want to accomplish.
>
> Regards
> Mats Liljegren
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



-- 
Thanks,
//richard

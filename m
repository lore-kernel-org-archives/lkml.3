Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755804AbaJIMay (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 08:30:54 -0400
Received: from mail-ig0-f176.google.com ([209.85.213.176]:56206 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752573AbaJIMar (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 08:30:47 -0400
MIME-Version: 1.0
In-Reply-To: <CAFLxGvxkL33_TVaf6dT9joC8dzU9uvJVG-GJdDKXPsMVAvQhvw@mail.gmail.com>
References: <1412051169-9142-1-git-send-email-ankit.jindal@linaro.org>
 <CAPTm99V-xyXa7WQG2jzDz19gotJ0aQRPk_rb5ukvUpdFyFabfw@mail.gmail.com>
 <2114579.IN6EpqPdMv@wuerfel> <CAPTm99WBE7RnGYNZsCfsenYcR3wNSVYOg--90_s1Ji_=Vj5myA@mail.gmail.com>
 <CAFLxGvxkL33_TVaf6dT9joC8dzU9uvJVG-GJdDKXPsMVAvQhvw@mail.gmail.com>
From: Ankit Jindal <ankit.jindal@linaro.org>
Date: Thu, 9 Oct 2014 18:00:26 +0530
Message-ID: <CAPTm99WWP+FoEAL4N5vcSfNue5vEcL9hPcVfP6zmmvNUviRcuA@mail.gmail.com>
Subject: Re: [PATCH v2 0/6] UIO driver for APM X-Gene QMTM
To: Richard Weinberger <richard.weinberger@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Hans J. Koch" <hjk@hansjkoch.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "patches@apm.com" <patches@apm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Rob Herring <robh+dt@kernel.org>,
        Tushar Jagad <tushar.jagad@linaro.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9 October 2014 17:52, Richard Weinberger
<richard.weinberger@gmail.com> wrote:
> On Thu, Oct 9, 2014 at 2:17 PM, Ankit Jindal <ankit.jindal@linaro.org> wrote:
>> On 9 October 2014 17:36, Arnd Bergmann <arnd@arndb.de> wrote:
>>> On Thursday 09 October 2014 14:14:33 Ankit Jindal wrote:
>>>> On 30 September 2014 09:56, Ankit Jindal <ankit.jindal@linaro.org> wrote:
>>>> > This patchset enables user space access to APM X-Gene QMTM
>>>> > using UIO framework.
>>>> >
>>>> > The patchset also introduces new type UIO_MEM_PHYS_CACHE
>>>> > for mem regions because APM X-Gene QMTM device supports
>>>> > cache coherency with CPU caches.
>>>>
>>>
>>> I haven't been able to review the patch in detail yet, but I have
>>> a very high-level question: how do you decide which driver to use?
>>>
>>> I understand that the normal use case is for the QMTM to be used by
>>> the kernel directly rather than being exported to user space, and
>>> that the network driver will just use it if it is there.
>>
>> This UIO driver will be disabled by default. When this driver is
>> enabled, the other dependent drivers need to be removed from the
>> config.
>
> And if the user forgets or creates an allmod/yesconfig we have
> undefined behavior?

When the conflicting drivers will be added to kernel, necessary
options (depends on not) needs to be added to the Kconfig.

>
> --
> Thanks,
> //richard

Thanks,
Ankit

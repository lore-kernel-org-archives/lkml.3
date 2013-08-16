Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756866Ab3HQAMg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 20:12:36 -0400
Received: from mail-la0-f49.google.com ([209.85.215.49]:47660 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756617Ab3HQAMe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 20:12:34 -0400
Subject: Re: [PULL] Miscellaneous trivialities
Date: Fri, 16 Aug 2013 20:02:23 -0000
From: Michael Witten <mfwitten@gmail.com>
To: Rob Landley <rob@landley.net>
Cc: Jiri Kosina <trivial@kernel.org>, Randy Dunlap <rdunlap@infradead.org>,
        David Airlie <airlied@linux.ie>, linux-kernel@vger.kernel.org
Message-ID: <44b5fd3b87ba4565a78f1da4fa7d2e7d-mfwitten@gmail.com>
In-Reply-To: <1376668096.2737.43@driftwood>
References: <e3119c5240504890b8fd3ce2e38231c1-mfwitten@gmail.com>
            <1376668096.2737.43@driftwood>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Aug 2013 10:48:16 -0500, Rob Landley wrote:

> On 08/15/2013 04:44:01 AM, Michael Witten wrote:
>
>> I've been sitting on some trivial patches for a while, and I'd just
>> like to get them out of the way.
>>
>> Here is the series:
>>
>> ...
>>
>>   [5] Docs: Replace `hotplug' with `udev'
>>
>> ...
>>
>> diff --git a/Documentation/networking/README.ipw2200 b/Documentation/networking/README.ipw2200
>> index b7658be..aeb6494 100644
>> --- a/Documentation/networking/README.ipw2200
>> +++ b/Documentation/networking/README.ipw2200
>> @@ -256,7 +256,7 @@ You can set the debug level via:
>> 
>>  Where $VALUE would be a number in the case of this sysfs entry.  The
>>  input to sysfs files does not have to be a number.  For example, the
>> -firmware loader used by hotplug utilizes sysfs entries for transferring
>> +firmware loader used by udev utilizes sysfs entries for transferring
>>  the firmware image from user space into the driver.
>
> Hotplug is the name of the kernel subsystem, udev was one implementation
> of a userspace agent for it. A different implementation would be mdev
> (in busybox), some linux from scratch types are still using variants of
> diethotplug, there's a fork of udev called eudev that avoids systemd...
>
> And these days, firmware loading is mostly done directly by the kernel.
>
>>  The Intel(R) PRO/Wireless 2915ABG Driver for Linux exposes sysfs entries
>> @@ -425,8 +425,7 @@ are made to the driver.  Currently, there are no major changes planned.
>>  ----------------------------------------------
>>
>>  The driver requires a firmware image, download it and extract the
>> -files under /lib/firmware (or wherever your hotplug's firmware.agent
>> -will look for firmware files)
>> +files under /lib/firmware (or wherever udev will look for firmware files)
>
> Again, hotplug is correct.

Thanks for catching my error. I removed that patch from the series; the
remaining commits can be pulled from here:

  https://github.com/mfwitten/linux.git trivial/misc/1

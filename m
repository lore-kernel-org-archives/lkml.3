Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751238AbaFNXX2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2014 19:23:28 -0400
Received: from mail-qa0-f42.google.com ([209.85.216.42]:42760 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828AbaFNXX0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2014 19:23:26 -0400
MIME-Version: 1.0
In-Reply-To: <20140614224222.GE1389@xo-6d-61-c0.localdomain>
References: <20140612090636.GK10256@localhost>
	<1402605252-9620-1-git-send-email-janne.kanniainen@gmail.com>
	<20140614224222.GE1389@xo-6d-61-c0.localdomain>
Date: Sun, 15 Jun 2014 02:23:25 +0300
Message-ID: <CAEEjW04wA3PT2=oE4Z=tP-RWkmyiWpM5NzCH5Owwh8vCRbqMTA@mail.gmail.com>
Subject: Re: [PATCH v5] leds: USB: HID: Add support for MSI GT683R led panels
From: Janne Kanniainen <janne.kanniainen@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Jiri Kosina <jkosina@suse.cz>, Johan Hovold <johan@kernel.org>,
        Bryan Wu <cooloney@gmail.com>, linux-kernel@vger.kernel.org,
        linux-leds@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-input@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hi!

Hi.

>> --- /dev/null
>> +++ b/Documentation/ABI/testing/sysfs-class-hid-driver-gt683r
>> @@ -0,0 +1,10 @@
>> +What:                /sys/class/hidraw/<hidraw>/device/state
>> +Date:                Jun 2014
>> +KernelVersion:       3.15
>> +Contact:     Janne Kanniainen <janne.kanniainen@gmail.com>
>> +Description:
>> +             Set the mode of LEDs
>> +
>> +             0 - normal
>> +             1 - audio
>> +             2 - breathing
>
> THat's some strange interface. Don't we normally use led triggers for this?

I can implement it that way, if you all think that it is correct way.
What do Jiri and Johan thinks of it?

> And the mode of the LED should really be in /sys/class/leds, not in hidraw somewhere...

The problem is that all panels can only be in one mode at the time.
For example front panel can't be in breathing mode while side panel is
in normal mode.


Janne

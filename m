Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755951Ab3KVRrg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 12:47:36 -0500
Received: from mail-pb0-f54.google.com ([209.85.160.54]:33064 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754477Ab3KVRrd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 12:47:33 -0500
MIME-Version: 1.0
In-Reply-To: <20131122160457.GA3951@roeck-us.net>
References: <CAOMwXhM1Xi=UqpmKNDsOnQLXKo1o+65TZi6AkBk4Ds9wuXSaWQ@mail.gmail.com>
	<20131119165438.GD30481@roeck-us.net>
	<20131119180007.GB16693@roeck-us.net>
	<CAOMwXhOTRVu1EMSNE_muKKfSYBFQ1XVq1EQEL2d+wCwRJ0tkpw@mail.gmail.com>
	<CAOMwXhN8tZej9=65wyGvsnm64igiLLN6vdsiGaePCozKBs8J7Q@mail.gmail.com>
	<20131121173458.GC10783@roeck-us.net>
	<CAOMwXhNzpsiiK5NzxoXM56ACGmHo1gpm3OT6=kw29XQDFmyPAA@mail.gmail.com>
	<CAOMwXhPUR02fQ1EhV6K9eQW02kNHn55dTEND+R59g1=zC5qDWQ@mail.gmail.com>
	<528F6BB8.8040504@roeck-us.net>
	<CAOMwXhNx0v52BvxSWPrHFsGTvxss7N4tZT3gHMFJ8hz_HmvS5w@mail.gmail.com>
	<20131122160457.GA3951@roeck-us.net>
Date: Fri, 22 Nov 2013 17:47:33 +0000
X-Google-Sender-Auth: 8Pm-FNi1Fv7_5krd6Pu3bbWYs_4
Message-ID: <CAOMwXhO525BAJ+ESLaJ-62vkL7mAxLMULuaphE6YVda02beqfg@mail.gmail.com>
Subject: Re: [lm-sensors] [PATCH] hwmon: (max6650) Add support for gpiodef
From: Laszlo Papp <lpapp@kde.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Marcus Folkesson <marcus.folkesson@gmail.com>, hjk@hansjkoch.de,
        linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 22, 2013 at 4:04 PM, Guenter Roeck <linux@roeck-us.net> wrote:
> On Fri, Nov 22, 2013 at 02:50:50PM +0000, Laszlo Papp wrote:
>> On Fri, Nov 22, 2013 at 2:35 PM, Guenter Roeck <linux@roeck-us.net> wrote:
>> > On 11/22/2013 01:23 AM, Laszlo Papp wrote:
>> >>
>> >> Just to clarify: you want to have ./gpio/gpio-max6650.c?
>> >>
>> > No, I never said that. I wanted you to register the gpio pins
>> > with the gpio subsystem. I didn't ask you to write a separate
>> > driver for it.
>> >
>> > Sure, strictly speaking one could write a top level mfd driver
>> > and separate gpio and hwmon drivers, but at least in my opinion
>> > that would be overkill. I also never suggested this; you brought
>> > the term mfd into the discussion.
>>
>> Why is it an overkill to write a separate gpio driver for this, and
>> potentially also for the gpio status register of this particular MAXIM
>> chip?
>>
>> Other gpio drivers in the gpio folder are also short. This would not
>> become long either.
>>
> No one prevents you from writing a separate gpio driver. I will certainly
> not prevent you from doing it. Just don't claim that I requested it.
> Same is true for an mfd driver; I won't prevent you from writing one.
> But don't claim that I told you to do it.

I am not sure if you are trying to claim that with this statement a
separate gpio driver would be acceptable, but it would require a bit
more work, or whether that you would reject such a driver added.

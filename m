Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751390AbaBKJIN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 04:08:13 -0500
Received: from mail-pa0-f43.google.com ([209.85.220.43]:47666 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750797AbaBKJII convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 04:08:08 -0500
MIME-Version: 1.0
In-Reply-To: <1392108545.4700.4.camel@chaos.site>
References: <1392045953-26596-1-git-send-email-lpapp@kde.org>
	<20140210160842.GB26997@lee--X1>
	<20140210173811.04ba5964@endymion.delvare>
	<CAOMwXhPTkrUUaUL-H_0fvZBO9_kt4jqKXs5BJYthDfu0_1c3xg@mail.gmail.com>
	<20140211085014.4ef32b56@endymion.delvare>
	<CAOMwXhMhKdp420+SPTih+C3fAgTmrpJgPnGBxsfPO3pEhESGTA@mail.gmail.com>
	<1392108545.4700.4.camel@chaos.site>
Date: Tue, 11 Feb 2014 09:08:01 +0000
X-Google-Sender-Auth: ZcqmxFn9B5HAdeOXrY5dlCU-N8o
Message-ID: <CAOMwXhM4eaoEcQeeRgoXxxGzXkwSoypFLMd2qPwckgayEqsu_g@mail.gmail.com>
Subject: Re: [lm-sensors] [PATCH] hwmon: (max6650) Rename the device ids to
 contain the hwmon suffix
From: Laszlo Papp <lpapp@kde.org>
To: Jean Delvare <jdelvare@suse.de>
Cc: Lee Jones <lee.jones@linaro.org>, LKML <linux-kernel@vger.kernel.org>,
        lm-sensors@lm-sensors.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 11, 2014 at 8:49 AM, Jean Delvare <jdelvare@suse.de> wrote:
> Le Tuesday 11 February 2014 à 08:28 +0000, Laszlo Papp a écrit :
>> On Tue, Feb 11, 2014 at 7:50 AM, Jean Delvare <jdelvare@suse.de> wrote:
>> > Hi Laszlo,
>> >
>> > On Tue, 11 Feb 2014 03:13:37 +0000, Laszlo Papp wrote:
>> >> On Mon, Feb 10, 2014 at 4:38 PM, Jean Delvare <jdelvare@suse.de> wrote:
>> >> > Additionally, dashes are explicitly forbidden in hwmon
>> >> > device names.
>> >>
>> >> Also, where is that documented?
>> >
>> > In Documentation/hwmon/sysfs-interface:
>> >
>> > *********************
>> > * Global attributes *
>> > *********************
>> >
>> > name            The chip name.
>> >                 This should be a short, lowercase string, not containing
>> >                 spaces nor dashes, representing the chip name. This is
>> >                 the only mandatory attribute.
>> >                 I2C devices get this attribute created automatically.
>> >                 RO
>>
>> Time to revisit this decision....
>>
>> So, based on the fact that children device names usually contain
>> dashes, I do not understand why hwmon would be any special in this
>> regard. It is possible that the hwmon developers have not faced much
>> MFD situation before, and so, this was not considered to be handled
>> like in other subsystems.
>>
>> I am proposing to change this "rule"...  Any objection?
>
> I'm giving up here, sorry. There's no point in me writing any more on
> the topic as you are not listening to me. I do not have the impression
> you are doing any effort to understand what I'm saying. Plus you keep
> focusing on things that do not matter and problems for which a solution
> has already been provided.

Does it mean the people cannot come up with ideas if they think
something may be better than some provided way? Surely, software
evolves over time and people are sometimes right, and sometimes wrong
right?

I can assure you that I do listen, please assume good faith with ideas
thrown in. If you think it is that bad an idea, you could have
explained why so, so that I and others can also understand it who do
not yet, right?

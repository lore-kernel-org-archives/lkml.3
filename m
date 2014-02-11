Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751797AbaBKI6o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 03:58:44 -0500
Received: from mail-pd0-f180.google.com ([209.85.192.180]:37056 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751390AbaBKI6m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 03:58:42 -0500
MIME-Version: 1.0
In-Reply-To: <20140211085053.GD32042@lee--X1>
References: <1392045953-26596-1-git-send-email-lpapp@kde.org>
	<20140210160842.GB26997@lee--X1>
	<20140210173811.04ba5964@endymion.delvare>
	<CAOMwXhPTkrUUaUL-H_0fvZBO9_kt4jqKXs5BJYthDfu0_1c3xg@mail.gmail.com>
	<20140211085014.4ef32b56@endymion.delvare>
	<CAOMwXhMhKdp420+SPTih+C3fAgTmrpJgPnGBxsfPO3pEhESGTA@mail.gmail.com>
	<20140211085053.GD32042@lee--X1>
Date: Tue, 11 Feb 2014 08:58:42 +0000
X-Google-Sender-Auth: 1Kp9POE80EgKhFx0_Mf9lmhUBms
Message-ID: <CAOMwXhPfmXDKcov_+HHDTCaieGDiMEi+6CV_OnYDM3c8+S+bfA@mail.gmail.com>
Subject: Re: [lm-sensors] [PATCH] hwmon: (max6650) Rename the device ids to
 contain the hwmon suffix
From: Laszlo Papp <lpapp@kde.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: Jean Delvare <jdelvare@suse.de>, LKML <linux-kernel@vger.kernel.org>,
        lm-sensors@lm-sensors.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 11, 2014 at 8:50 AM, Lee Jones <lee.jones@linaro.org> wrote:
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
> Prior to proposing such an invasive change which is highly likely to
> come up against heavy opposition,

It is possible that someone does not understand why you think it may
be invasive, right? Could you please explain the reason for that?

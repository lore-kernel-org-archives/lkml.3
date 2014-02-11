Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752047AbaBKI2m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 03:28:42 -0500
Received: from mail-pb0-f47.google.com ([209.85.160.47]:33909 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750785AbaBKI2l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 03:28:41 -0500
MIME-Version: 1.0
In-Reply-To: <20140211085014.4ef32b56@endymion.delvare>
References: <1392045953-26596-1-git-send-email-lpapp@kde.org>
	<20140210160842.GB26997@lee--X1>
	<20140210173811.04ba5964@endymion.delvare>
	<CAOMwXhPTkrUUaUL-H_0fvZBO9_kt4jqKXs5BJYthDfu0_1c3xg@mail.gmail.com>
	<20140211085014.4ef32b56@endymion.delvare>
Date: Tue, 11 Feb 2014 08:28:40 +0000
X-Google-Sender-Auth: ecZBsPrHHqWPUj6u9fvQ5SW43Og
Message-ID: <CAOMwXhMhKdp420+SPTih+C3fAgTmrpJgPnGBxsfPO3pEhESGTA@mail.gmail.com>
Subject: Re: [lm-sensors] [PATCH] hwmon: (max6650) Rename the device ids to
 contain the hwmon suffix
From: Laszlo Papp <lpapp@kde.org>
To: Jean Delvare <jdelvare@suse.de>
Cc: Lee Jones <lee.jones@linaro.org>, LKML <linux-kernel@vger.kernel.org>,
        lm-sensors@lm-sensors.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 11, 2014 at 7:50 AM, Jean Delvare <jdelvare@suse.de> wrote:
> Hi Laszlo,
>
> On Tue, 11 Feb 2014 03:13:37 +0000, Laszlo Papp wrote:
>> On Mon, Feb 10, 2014 at 4:38 PM, Jean Delvare <jdelvare@suse.de> wrote:
>> > Additionally, dashes are explicitly forbidden in hwmon
>> > device names.
>>
>> Also, where is that documented?
>
> In Documentation/hwmon/sysfs-interface:
>
> *********************
> * Global attributes *
> *********************
>
> name            The chip name.
>                 This should be a short, lowercase string, not containing
>                 spaces nor dashes, representing the chip name. This is
>                 the only mandatory attribute.
>                 I2C devices get this attribute created automatically.
>                 RO

Time to revisit this decision....

So, based on the fact that children device names usually contain
dashes, I do not understand why hwmon would be any special in this
regard. It is possible that the hwmon developers have not faced much
MFD situation before, and so, this was not considered to be handled
like in other subsystems.

I am proposing to change this "rule"...  Any objection?

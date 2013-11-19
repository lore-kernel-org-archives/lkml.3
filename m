Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752947Ab3KSQmv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 11:42:51 -0500
Received: from mail-pb0-f50.google.com ([209.85.160.50]:54806 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751421Ab3KSQmu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 11:42:50 -0500
MIME-Version: 1.0
In-Reply-To: <CAJ4dqQu0=HP=Ut+VnNjkSL2cE8QN+JRa-Xd8X01ij+ijKUKxwA@mail.gmail.com>
References: <1384440661-3769-1-git-send-email-lpapp@kde.org>
	<20131114172427.GA11062@roeck-us.net>
	<CAOMwXhNdo8aRGH9AL+JxYnDg2zAN4+-TeHJU=Kc1kDKmyYuYmA@mail.gmail.com>
	<20131114181845.GA13727@roeck-us.net>
	<CAOMwXhNaZ=oqp5mjnCrOSkdax5U6ffsZf_p4mzd3W2jF+=xWqg@mail.gmail.com>
	<20131114190044.GE13727@roeck-us.net>
	<CAOMwXhPvPnprrJx-1dfJnO+E12sxAE9M_sYg7tyzp4dsDa8vyg@mail.gmail.com>
	<CAJ4dqQu0=HP=Ut+VnNjkSL2cE8QN+JRa-Xd8X01ij+ijKUKxwA@mail.gmail.com>
Date: Tue, 19 Nov 2013 16:42:49 +0000
X-Google-Sender-Auth: js274cYRpYJleLegpf4p4GyAGK4
Message-ID: <CAOMwXhM1Xi=UqpmKNDsOnQLXKo1o+65TZi6AkBk4Ds9wuXSaWQ@mail.gmail.com>
Subject: Re: [PATCH] hwmon: (max6650) Add support for gpiodef
From: Laszlo Papp <lpapp@kde.org>
To: Marcus Folkesson <marcus.folkesson@gmail.com>
Cc: Guenter Roeck <linux@roeck-us.net>, hjk@hansjkoch.de,
        lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 15, 2013 at 7:52 PM, Marcus Folkesson
<marcus.folkesson@gmail.com> wrote:
>
>> This is just one use case of those, you could also use it for
>> non-generic gpio functionality, like alarm, "full-on", internal clock,
>> external clock, etc. I believe it is always a bit tricky with MFD. I
>> personally prefer to put it into the chip driver because this is not
>> clearly a generic gpio interface here, and I need to drive it
>> dynamically.
>
> I agree.
>
> I think the solution with expose the "GPIOs" in sysfs is the right way to
> go.
> The chip-function is of a dynamic nature and should therefor not be set in
> platform data / devicetree.
>
> As mentioned before, GPIOs should use the gpio subsystem whenever possible,
> but the the gpio-functionality is just a subset of
> functions these pins may be set to.
>
> Also, the I think the *real* reason why the entries is called "gpio" is that
> it is so the registers are are mentioned in the datasheet.
> Everyone that is working with the device will know what it is all about.
> I see it more as an register expose than a gpio interface...
>
> I agree that the entries does not really fit here. But they does not fit
> better elsewhere either.
> And I don't think they fit worse than the alarm-entries that is already in
> mainline.
>
> Anyway, I think the documentation file should mention what function each
> valid value represent.

Yes, makes sense to make the documentation more comprehensive. Thanks.

Any other issues from anyone before submitting a polished version?

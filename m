Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753475AbaBMKed (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 05:34:33 -0500
Received: from mail-pa0-f50.google.com ([209.85.220.50]:58256 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751970AbaBMKeb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 05:34:31 -0500
MIME-Version: 1.0
In-Reply-To: <CAOMwXhPsQPvPn+kmBXyGq3WqsGhxTR2w1YjTzNbTyrEyxVHWxQ@mail.gmail.com>
References: <1392177760-17959-1-git-send-email-lpapp@kde.org>
	<20140212175018.GJ28112@sirena.org.uk>
	<20140213082311.GA32508@lee--X1>
	<CAOMwXhPsQPvPn+kmBXyGq3WqsGhxTR2w1YjTzNbTyrEyxVHWxQ@mail.gmail.com>
Date: Thu, 13 Feb 2014 10:34:31 +0000
X-Google-Sender-Auth: Cauhzpknnm4dAthXKvUsAK2-t68
Message-ID: <CAOMwXhPtw-ZZZtTax_oK6kwDMbC0e8BetVH1vvo8+8O53pbeGw@mail.gmail.com>
Subject: Re: [PATCH v6] mfd: MAX6650/6651 support
From: Laszlo Papp <lpapp@kde.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: Mark Brown <broonie@kernel.org>, Linus Walleij <linus.walleij@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Jean Delvare <jdelvare@suse.de>, Guenter Roeck <linux@roeck-us.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 13, 2014 at 9:14 AM, Laszlo Papp <lpapp@kde.org> wrote:
> On Thu, Feb 13, 2014 at 8:23 AM, Lee Jones <lee.jones@linaro.org> wrote:
>> Laszlo,
>>
>>> > +const struct regmap_config max665x_regmap_config = {
>>> > +   .reg_bits = 5,
>>> > +};
>>>
>>> This would normally be static too, and I'd *really* expect to see a
>>> val_bits set here.  I'm a bit surprised this works without one.
>>
>> Mark (privately) mentioned to me that this patch can't possibly work
>> given the current Regmap configuration.
>
> Strange because I have tested the change, although not for days and
> weeks. What exactly cannot possible work?

Hmm, yes, as it seems, I have not actually tested the patch set
_after_ all the modifications. I deemed some of them trivial enough,
but apparently I was wrong. In this case, sending trivial updates will
slow down, but I guess that is the way to follow. Well, I apologize.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753542AbaBMJOR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 04:14:17 -0500
Received: from mail-pb0-f41.google.com ([209.85.160.41]:46285 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751506AbaBMJOL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 04:14:11 -0500
MIME-Version: 1.0
In-Reply-To: <20140213082311.GA32508@lee--X1>
References: <1392177760-17959-1-git-send-email-lpapp@kde.org>
	<20140212175018.GJ28112@sirena.org.uk>
	<20140213082311.GA32508@lee--X1>
Date: Thu, 13 Feb 2014 09:14:11 +0000
X-Google-Sender-Auth: gh3xSO1Xc6_JJHe-sy5l35ccq-w
Message-ID: <CAOMwXhPsQPvPn+kmBXyGq3WqsGhxTR2w1YjTzNbTyrEyxVHWxQ@mail.gmail.com>
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

On Thu, Feb 13, 2014 at 8:23 AM, Lee Jones <lee.jones@linaro.org> wrote:
> Laszlo,
>
>> > +const struct regmap_config max665x_regmap_config = {
>> > +   .reg_bits = 5,
>> > +};
>>
>> This would normally be static too, and I'd *really* expect to see a
>> val_bits set here.  I'm a bit surprised this works without one.
>
> Mark (privately) mentioned to me that this patch can't possibly work
> given the current Regmap configuration.

Strange because I have tested the change, although not for days and
weeks. What exactly cannot possible work?

> Patches are accepted into
> Mainline based on the premise that they are fully tested and working,
> _prior_ to submitting [1].

Yes, I am aware of it, hence the quick testing done.

> It's also pretty pointless having an MFD driver without any
> children,

Agree.

> so unless (at least one of) the child device drivers have
> been accepted by pull-time, your work will not be part of the
> pull-request headed for Mainline.

Sure, I think that is reasonable.

> Please inform me of your plans as you with to proceed.

I already sent the hwmon changes to the maintainers - you included or
linked -, but got no response so far. I am all for making it work
ASAP. I will make a more thorough testing today or tomorrow. After
that, it is up to them...

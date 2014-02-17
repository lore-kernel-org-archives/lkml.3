Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752314AbaBQIzI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 03:55:08 -0500
Received: from mail-pd0-f178.google.com ([209.85.192.178]:61654 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435AbaBQIzH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 03:55:07 -0500
MIME-Version: 1.0
In-Reply-To: <20140214205743.GV4451@sirena.org.uk>
References: <1392177760-17959-1-git-send-email-lpapp@kde.org>
	<20140212175018.GJ28112@sirena.org.uk>
	<CAOMwXhNd69KMDcBLjfiw16T3bWWki-Dvxbz+zhgNe6OESnVaSw@mail.gmail.com>
	<20140214205743.GV4451@sirena.org.uk>
Date: Mon, 17 Feb 2014 08:55:06 +0000
X-Google-Sender-Auth: 7rMBx6tqOyG6OMhTX3bOPCYlYi4
Message-ID: <CAOMwXhObBhWYvuEJVK7rJsb3JgALvNeoeA3xenU4L2BHdTkUVQ@mail.gmail.com>
Subject: Re: [PATCH v6] mfd: MAX6650/6651 support
From: Laszlo Papp <lpapp@kde.org>
To: Mark Brown <broonie@kernel.org>
Cc: Lee Jones <lee.jones@linaro.org>, Linus Walleij <linus.walleij@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Jean Delvare <jdelvare@suse.de>, Guenter Roeck <linux@roeck-us.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 14, 2014 at 8:57 PM, Mark Brown <broonie@kernel.org> wrote:
> On Fri, Feb 14, 2014 at 09:02:20AM +0000, Laszlo Papp wrote:
>> On Wed, Feb 12, 2014 at 5:50 PM, Mark Brown <broonie@kernel.org> wrote:
>> > On Wed, Feb 12, 2014 at 04:02:40AM +0000, Laszlo Papp wrote:
>
>> >> +const struct regmap_config max665x_regmap_config = {
>> >> +     .reg_bits = 5,
>> >> +};
>
>> > This would normally be static too, and I'd *really* expect to see a
>> > val_bits set here.  I'm a bit surprised this works without one.
>
>> Makes sense, thanks. Shall I also set the .max_register or any other
>> mandatory variables in here?
>
> It's better to set max_register since that makes the debug features of
> the regmap API more useful but it's not required, only reg_bits and
> val_bits are absolutely required.  In general the more complete the
> description of the register map in the driver the better.

OK, thanks.

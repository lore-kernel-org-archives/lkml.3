Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752190AbaBNK7L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 05:59:11 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:43314 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751585AbaBNK7J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 05:59:09 -0500
MIME-Version: 1.0
In-Reply-To: <20140214101949.GD9462@lee--X1>
References: <1392177760-17959-1-git-send-email-lpapp@kde.org>
	<20140212175018.GJ28112@sirena.org.uk>
	<CAOMwXhNd69KMDcBLjfiw16T3bWWki-Dvxbz+zhgNe6OESnVaSw@mail.gmail.com>
	<20140214101949.GD9462@lee--X1>
Date: Fri, 14 Feb 2014 10:59:08 +0000
X-Google-Sender-Auth: yKlW9FYfvWv3tcjApJ2y0VOTojM
Message-ID: <CAOMwXhOYnKfAU0JfharnV3SoDUUyJ8i_6ePkcU6h+7AZDWmf6A@mail.gmail.com>
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

On Fri, Feb 14, 2014 at 10:19 AM, Lee Jones <lee.jones@linaro.org> wrote:
>> >> +     mutex_init(&max665x->iolock);
>> >
>> > What is this needed for?
>>
>> It was done for consistency with the other mfd drivers (maxim), e.g.
>> 8997 or 8998 as the closest resemblence in this family. Would you
>> prefer me removing this mutex locker?
>
> If you're not using mutexes, why would you need to initialise it?

Yeah, I had the same thought about an hour ago that this sneaked in
because I was not originally using regmap, but now with the regmap
usage, it is just a left-over. So, it is not even for consistency
anymore. I was wrong claiming that.

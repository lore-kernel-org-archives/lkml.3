Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752395AbaBLJee (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 04:34:34 -0500
Received: from mail-pb0-f45.google.com ([209.85.160.45]:42589 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752366AbaBLJe3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 04:34:29 -0500
MIME-Version: 1.0
In-Reply-To: <20140212083224.GM15081@lee--X1>
References: <1392177760-17959-1-git-send-email-lpapp@kde.org>
	<CAK9yfHztuCSBSJUjc1xcf-f+O+kaKQQ=ExpWB-LoCkLoaZPfWA@mail.gmail.com>
	<CAOMwXhNp-+Fr87NxdquEOtEriqt20E4b08W8JBrKMbCqh1K6_Q@mail.gmail.com>
	<20140212083224.GM15081@lee--X1>
Date: Wed, 12 Feb 2014 09:34:28 +0000
X-Google-Sender-Auth: JJAl4ZBmg0duNHTNkNQygAcMGWQ
Message-ID: <CAOMwXhNWyLakYpkcuDLh5+yThjtrPkmcRDd8TQrStEDcuMO7_Q@mail.gmail.com>
Subject: Re: [PATCH v6] mfd: MAX6650/6651 support
From: Laszlo Papp <lpapp@kde.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: Sachin Kamat <sachin.kamat@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Jean Delvare <jdelvare@suse.de>, Guenter Roeck <linux@roeck-us.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 12, 2014 at 8:32 AM, Lee Jones <lee.jones@linaro.org> wrote:
>> >> +       max665x->map = devm_regmap_init_i2c(i2c, &max665x_regmap_config);
>> >
>> > Don't you need to check the return value of devm_regmap_init_i2c?
>>
>> I personally think I should. I strived for consistency though with
>> other similar drivers. After this many reviews about such things, it
>> seems that consistency matters here less than other projects which I
>> can cope with, thanks.
>
> The right thing to do is normally preferred.

Yes, sure.

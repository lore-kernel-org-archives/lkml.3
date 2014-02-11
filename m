Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751589AbaBKKKV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 05:10:21 -0500
Received: from mail-pb0-f53.google.com ([209.85.160.53]:48370 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750975AbaBKKKS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 05:10:18 -0500
MIME-Version: 1.0
In-Reply-To: <CAK9yfHwxmtEXQwPZJfU980G6g7sbrLDU=nZiN=dkwVwvg7UXyA@mail.gmail.com>
References: <1391859219-3102-1-git-send-email-lpapp@kde.org>
	<CAK9yfHx2W3KXzBJavpDwXqBUxM8Uw6tWLRGBLjUq1jS_yWYw-Q@mail.gmail.com>
	<CAOMwXhNmjehcd+aiWGuKs7CijheXXngsXTHMfG9SDLpHO=KaPw@mail.gmail.com>
	<CAK9yfHwxmtEXQwPZJfU980G6g7sbrLDU=nZiN=dkwVwvg7UXyA@mail.gmail.com>
Date: Tue, 11 Feb 2014 10:10:17 +0000
X-Google-Sender-Auth: HsEYsb7UK_-9iCbigdYcKuk93cY
Message-ID: <CAOMwXhNcYpBvMEhcxtvsnByeB7QxO56gjAC+JP2s0tRvmyQiXQ@mail.gmail.com>
Subject: Re: [PATCH v2] mfd: MAX6650/6651 support
From: Laszlo Papp <lpapp@kde.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Lee Jones <lee.jones@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> [snip]
>>>> +
>>>> +struct max665x_dev {
>>>> +       struct device *dev;
>>>> +       struct mutex iolock;
>>>> +
>>>> +       struct i2c_client *i2c;
>>>> +       struct regmap     *map;
>>>> +
>>>> +       int type;
>>>
>>> Unnecessary extra lines above could be removed.
>>
>> I prefer it that way, but I will remove the two extra lines as you wish.
>
> As I already said, these are just nits and only since you were
> re-spinning the patch,
> I suggested them. Also, since this is a new file being added, it
> avoids further patches
> doing these same things.

Well, it is worse in my opinion because it makes the code more bloated
without separation between units, but I made the requested change
anyway because the feature matters lotta more to me than this styling.
Hope it is OK now?

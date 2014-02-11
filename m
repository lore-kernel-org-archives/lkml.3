Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751602AbaBKLjm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 06:39:42 -0500
Received: from mail-pb0-f44.google.com ([209.85.160.44]:42667 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751076AbaBKLjl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 06:39:41 -0500
MIME-Version: 1.0
In-Reply-To: <CAK9yfHxUf_nyd0aYyMGHS5tCEKo-GrLxGNu_18dSL12cPe+J6Q@mail.gmail.com>
References: <1391859219-3102-1-git-send-email-lpapp@kde.org>
	<CAK9yfHx2W3KXzBJavpDwXqBUxM8Uw6tWLRGBLjUq1jS_yWYw-Q@mail.gmail.com>
	<CAOMwXhNmjehcd+aiWGuKs7CijheXXngsXTHMfG9SDLpHO=KaPw@mail.gmail.com>
	<CAK9yfHwxmtEXQwPZJfU980G6g7sbrLDU=nZiN=dkwVwvg7UXyA@mail.gmail.com>
	<CAOMwXhNcYpBvMEhcxtvsnByeB7QxO56gjAC+JP2s0tRvmyQiXQ@mail.gmail.com>
	<CAK9yfHxUf_nyd0aYyMGHS5tCEKo-GrLxGNu_18dSL12cPe+J6Q@mail.gmail.com>
Date: Tue, 11 Feb 2014 11:39:40 +0000
X-Google-Sender-Auth: Ycumd7S18RDFfuxPXooQ3F-InsE
Message-ID: <CAOMwXhOaJoYgrtBuXgZO3PGym+-ndNrrN2NGTX90vWZWTuG=Kg@mail.gmail.com>
Subject: Re: [PATCH v2] mfd: MAX6650/6651 support
From: Laszlo Papp <lpapp@kde.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Lee Jones <lee.jones@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 11, 2014 at 11:14 AM, Sachin Kamat <sachin.kamat@linaro.org> wrote:
> On 11 February 2014 15:40, Laszlo Papp <lpapp@kde.org> wrote:
>>>>> [snip]
>>>>>> +
>>>>>> +struct max665x_dev {
>>>>>> +       struct device *dev;
>>>>>> +       struct mutex iolock;
>>>>>> +
>>>>>> +       struct i2c_client *i2c;
>>>>>> +       struct regmap     *map;
>>>>>> +
>>>>>> +       int type;
>>>>>
>>>>> Unnecessary extra lines above could be removed.
>>>>
>>>> I prefer it that way, but I will remove the two extra lines as you wish.
>>>
>>> As I already said, these are just nits and only since you were
>>> re-spinning the patch,
>>> I suggested them. Also, since this is a new file being added, it
>>> avoids further patches
>>> doing these same things.
>>
>> Well, it is worse in my opinion because it makes the code more bloated
>> without separation between units, but I made the requested change
>> anyway because the feature matters lotta more to me than this styling.
>> Hope it is OK now?
>
> The only thing that you missed among what you agreed to change is the
> arrangement of
> "depends on" and "select" in Kconfig. Rest look OK. Thanks for taking care.

Ah, true. I will do that tomorrow if it is a blocker for the integration.

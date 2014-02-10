Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752666AbaBJPUF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 10:20:05 -0500
Received: from mail-oa0-f51.google.com ([209.85.219.51]:55482 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752158AbaBJPUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 10:20:03 -0500
MIME-Version: 1.0
In-Reply-To: <20140210122129.GA23053@lee--X1>
References: <1391859219-3102-1-git-send-email-lpapp@kde.org>
	<CAK9yfHx2W3KXzBJavpDwXqBUxM8Uw6tWLRGBLjUq1jS_yWYw-Q@mail.gmail.com>
	<20140210122129.GA23053@lee--X1>
Date: Mon, 10 Feb 2014 20:50:02 +0530
Message-ID: <CAK9yfHyBRvr5fDCiCsNWV2q83PDsY=b1H3ocmk4pQ96m5m0cHg@mail.gmail.com>
Subject: Re: [PATCH v2] mfd: MAX6650/6651 support
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: Laszlo Papp <lpapp@kde.org>, Linus Walleij <linus.walleij@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10 February 2014 17:51, Lee Jones <lee.jones@linaro.org> wrote:
>> > +#include <linux/device.h>
>> > +#include <linux/mfd/core.h>
>> > +#include <linux/module.h>
>> > +#include <linux/i2c.h>
>>
>> Please arrange these alphabetically.
>
> Why?

1. It makes it easier to avoid adding duplicate includes.
2. Code looks more ordered/organized.
3. Prevents further clean up patches arranging them so :)

-- 
With warm regards,
Sachin

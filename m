Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752676AbaBJSgy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 13:36:54 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:39933 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752526AbaBJSgs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 13:36:48 -0500
MIME-Version: 1.0
In-Reply-To: <CAK9yfHyBRvr5fDCiCsNWV2q83PDsY=b1H3ocmk4pQ96m5m0cHg@mail.gmail.com>
References: <1391859219-3102-1-git-send-email-lpapp@kde.org>
	<CAK9yfHx2W3KXzBJavpDwXqBUxM8Uw6tWLRGBLjUq1jS_yWYw-Q@mail.gmail.com>
	<20140210122129.GA23053@lee--X1>
	<CAK9yfHyBRvr5fDCiCsNWV2q83PDsY=b1H3ocmk4pQ96m5m0cHg@mail.gmail.com>
Date: Mon, 10 Feb 2014 18:36:47 +0000
X-Google-Sender-Auth: cHUq7dfx5V2x2GcW8jeDDHw22OM
Message-ID: <CAOMwXhOz5gMg5xTfh7QAPji8okzK8ZNjd=_mC1Rq9TUkn2SD_Q@mail.gmail.com>
Subject: Re: [PATCH v2] mfd: MAX6650/6651 support
From: Laszlo Papp <lpapp@kde.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Lee Jones <lee.jones@linaro.org>, Linus Walleij <linus.walleij@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 10, 2014 at 3:20 PM, Sachin Kamat <sachin.kamat@linaro.org> wrote:
> On 10 February 2014 17:51, Lee Jones <lee.jones@linaro.org> wrote:
>>> > +#include <linux/device.h>
>>> > +#include <linux/mfd/core.h>
>>> > +#include <linux/module.h>
>>> > +#include <linux/i2c.h>
>>>
>>> Please arrange these alphabetically.
>>
>> Why?
>
> 1. It makes it easier to avoid adding duplicate includes.
> 2. Code looks more ordered/organized.
> 3. Prevents further clean up patches arranging them so :)

1) I am sorry, but I need to disagree with this one, personally. Check
duplicates could be done by a util at any given moment if it becomes a
pressing issue.

2) Not for me. I prefer hierarchical dependency based inclusion
between headers if there is such a thing, or just orthogonal if not.

3) It does not apply to my taste due to 1-2).

I would also like to add further detriments:

4) file rename could rearrange the list with your suggestion.

5) It would be inconsistent with a large code base out there.

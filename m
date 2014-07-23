Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757510AbaGWIpo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 04:45:44 -0400
Received: from mail-oa0-f50.google.com ([209.85.219.50]:62764 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757367AbaGWIpl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 04:45:41 -0400
MIME-Version: 1.0
In-Reply-To: <CAJAp7Ojgf6iuSKtRnvyTCOxj5AwDA6W4eOeCpsfRqGAxcMPM1w@mail.gmail.com>
References: <1404782785-1824-1-git-send-email-bjorn.andersson@sonymobile.com>
	<1404782785-1824-4-git-send-email-bjorn.andersson@sonymobile.com>
	<CACRpkdYqzsbisK-X22dwCcLFdvRm6-uJjNoEjv-h1-Jn6Uy-iw@mail.gmail.com>
	<CAJAp7Ojgf6iuSKtRnvyTCOxj5AwDA6W4eOeCpsfRqGAxcMPM1w@mail.gmail.com>
Date: Wed, 23 Jul 2014 10:45:40 +0200
Message-ID: <CACRpkdZynmMjzB78ZUvxMiBEK_Lox5j0+Z8qGf_jvK184BLwHg@mail.gmail.com>
Subject: Re: [PATCH 3/3] pinctrl: Introduce pinctrl driver for Qualcomm pm8xxx
From: Linus Walleij <linus.walleij@linaro.org>
To: Bjorn Andersson <bjorn@kryo.se>
Cc: Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 15, 2014 at 12:48 AM, Bjorn Andersson <bjorn@kryo.se> wrote:
> On Wed, Jul 9, 2014 at 2:32 AM, Linus Walleij <linus.walleij@linaro.org> wrote:
>> On Tue, Jul 8, 2014 at 3:26 AM, Bjorn Andersson
> [...]

>> "direction" also seems a bit bool ... even "output_value".
>>
>
> "direction" is 2 bits that can be both be set, unfortunately it's not entirely
> clear to me what's expected when setting both; so I've copied the logic as good
> as possible from the codeaurora driver.

Oh, can you do this?

u8 foo:2;

?

Yours,
Linus Walleij

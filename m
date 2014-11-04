Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753244AbaKDKGx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 05:06:53 -0500
Received: from mail-ig0-f178.google.com ([209.85.213.178]:35056 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753094AbaKDKGu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 05:06:50 -0500
MIME-Version: 1.0
In-Reply-To: <20141103175851.GU12011@x1>
References: <1414490816-13574-1-git-send-email-linus.walleij@linaro.org>
	<20141103175851.GU12011@x1>
Date: Tue, 4 Nov 2014 11:06:49 +0100
Message-ID: <CACRpkdbmL-D8PzAcbm6Wm-cOzB6BZfkRk5Pgfw+VHnSyoEZv3Q@mail.gmail.com>
Subject: Re: [PATCH] mfd: tc3589x: get rid of static base
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 3, 2014 at 6:58 PM, Lee Jones <lee.jones@linaro.org> wrote:
> On Tue, 28 Oct 2014, Linus Walleij wrote:
>
>> The TC3589x driver is now a device tree-only driver, so we want
>> only dynamic IRQs and GPIO numbers from the tc3589x, no static
>> assignments.
>>
>> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
>> ---
>>  drivers/gpio/gpio-tc3589x.c | 2 +-
>>  drivers/mfd/tc3589x.c       | 9 +++------
>>  include/linux/mfd/tc3589x.h | 8 --------
>>  3 files changed, 4 insertions(+), 15 deletions(-)
>
> Acked-by: Lee Jones <lee.jones@linaro.org>
>
> How would you like me to handle this patch?
>
> ib-mfd-gpio?

Nah just merge it into MFD and let's hope nothing clashes.
I have no dependent patches for this cycle AFAIK.

Yours,
Linus Walleij

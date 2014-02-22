Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754774AbaBVB5X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 20:57:23 -0500
Received: from mail-ve0-f172.google.com ([209.85.128.172]:34685 "EHLO
	mail-ve0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753865AbaBVB5W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 20:57:22 -0500
MIME-Version: 1.0
In-Reply-To: <E44A8A90-550C-438C-9EA0-61E033BB988E@codeaurora.org>
References: <1392150132-21877-1-git-send-email-galak@codeaurora.org> <E44A8A90-550C-438C-9EA0-61E033BB988E@codeaurora.org>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Sat, 22 Feb 2014 10:57:01 +0900
Message-ID: <CAAVeFuLDAhrS+ntNhOoszRXSrBLFaEhVTKkYbRtiAfogbjbexQ@mail.gmail.com>
Subject: Re: [PATCH] gpio: msm: switch Kconfig to ARCH_QCOM depends
To: Kumar Gala <galak@codeaurora.org>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 22, 2014 at 12:33 AM, Kumar Gala <galak@codeaurora.org> wrote:
>
> On Feb 11, 2014, at 2:22 PM, Kumar Gala <galak@codeaurora.org> wrote:
>
>> We've split Qualcomm MSM support into legacy and multiplatform.  The gpio
>> msm-v2 driver is only relevant on the multiplatform supported SoCs so
>> switch the Kconfig depends to ARCH_QCOM.
>>
>> CC: Linus Walleij <linus.walleij@linaro.org>
>> Signed-off-by: Kumar Gala <galak@codeaurora.org>
>> ---
>> Linus,
>>
>> If you can ack this I'll send it via linux-qcom/arm-soc tree's
>>
>> thanks
>>
>> - k
>
> ping.

Linus is slow to answer for some reason, but I guess that as the
co-maintainer my Ack would do for such a simple patch?

Acked-by: Alexandre Courbot <gnurou@gmail.com>

Linus, please rap on my knuckles if you feel I overstepped.

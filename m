Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756727Ab3H2SqH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 14:46:07 -0400
Received: from mail-oa0-f50.google.com ([209.85.219.50]:33070 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755548Ab3H2SqE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 14:46:04 -0400
MIME-Version: 1.0
In-Reply-To: <20130829180040.GI18542@quad.lixom.net>
References: <ADE657CA350FB648AAC2C43247A983F0021DAC7DA184@AUSP01VMBX24.collaborationhost.net>
	<1859873512.636800.1377798778897.JavaMail.root@mail>
	<20130829180040.GI18542@quad.lixom.net>
Date: Thu, 29 Aug 2013 20:46:04 +0200
Message-ID: <CACRpkdaK4XBPejAC6EezhTi_CkWZpj4A9+FzAhzSDib9dhJJNw@mail.gmail.com>
Subject: Re: [PATCH] gpio: (gpio-pca953x) move header to linux/platform_data/
From: Linus Walleij <linus.walleij@linaro.org>
To: Olof Johansson <olof@lixom.net>
Cc: Vivien Didelot <vivien.didelot@savoirfairelinux.com>,
        "arm@kernel.org" <arm@kernel.org>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        kernel@savoirfairelinux.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        H Hartley Sweeten <hartleys@visionengravers.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 29, 2013 at 8:00 PM, Olof Johansson <olof@lixom.net> wrote:
> On Thu, Aug 29, 2013 at 01:52:58PM -0400, Vivien Didelot wrote:
>> As this patch mainly touches arch/arm/*, Olof/Kevin, would you mind
>> applying it?
>>
>> The first message in thread is here: https://lkml.org/lkml/2013/7/31/552
>> Here are the previous ACKs:
>>
>> Acked-by: Linus Walleij <linus.walleij@linaro.org>
>> Acked-by: H Hartley Sweeten <hsweeten@visionengravers.com>
>
> Looks like i2c or gpio maintainers should be taking it, but since Linus acked
> it instead of applied it, I guess we can take it. :)
>
> I'll apply it to next/cleanup for 3.12 if you resend me the patch with the
> acks. Thanks!

Thanks a lot Olof, I worried about all the hunks hitting the arch/arm/*
hierarchy, and not much is happening in drivers/gpio this cycle
so think it is better off in ARM SoC.

Yours,
Linus Walleij

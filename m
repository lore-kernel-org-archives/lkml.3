Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757601Ab3EHRXj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 13:23:39 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:47631 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756740Ab3EHRXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 13:23:37 -0400
MIME-Version: 1.0
In-Reply-To: <CACRpkdZE5Q6Y7ZxEEz4SF3a1jiAqu8n0J+kWEyae_bUWmVE9Bw@mail.gmail.com>
References: <A874F61F95741C4A9BA573A70FE3998F82E5C8EB@DQHE06.ent.ti.com> <CACRpkdZE5Q6Y7ZxEEz4SF3a1jiAqu8n0J+kWEyae_bUWmVE9Bw@mail.gmail.com>
From: Bryan Wu <cooloney@gmail.com>
Date: Wed, 8 May 2013 10:23:17 -0700
Message-ID: <CAK5ve-LCR=7ZBU_efGn2N=E3EK9jbA2Bm9aT41gjeyqf3=FpDw@mail.gmail.com>
Subject: Re: [PATCH 2/2] leds: lp5562: support the device tree feature
To: Linus Walleij <linus.walleij@linaro.org>
Cc: "Kim, Milo" <Milo.Kim@ti.com>,
        Gabriel Fernandez <gabriel.fernandez@stericsson.com>,
        "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 7, 2013 at 1:00 PM, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Tue, May 7, 2013 at 9:14 AM, Kim, Milo <Milo.Kim@ti.com> wrote:
>
>> The LP55xx DT structure is applicable to the LP5562 device.
>> The driver and documentation are updated.
>>
>> Compatible property of the DT
>> : LP5521 and LP5223 were manufactured by National Semiconductor.
>>   LP5562 is a new device from Texas Instruments.
>>
>> Cc: Linus Walleij <linus.walleij@linaro.org>
>> Cc: Gabriel Fernandez <gabriel.fernandez@stericsson.com>
>> Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
>
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
>

Thanks, I merged it to my for-next branch.

-Bryan

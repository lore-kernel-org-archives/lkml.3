Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752180AbaGKJWa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 05:22:30 -0400
Received: from mail-vc0-f181.google.com ([209.85.220.181]:48991 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751638AbaGKJW2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 05:22:28 -0400
MIME-Version: 1.0
In-Reply-To: <CAK5sBcFvPo38LtWAhee0xO=KONM5V-UEDzgjCc=uEXtG32NowA@mail.gmail.com>
References: <1405069589-10388-1-git-send-email-ch.naveen@samsung.com>
 <1405069589-10388-3-git-send-email-ch.naveen@samsung.com> <CAK5sBcFvPo38LtWAhee0xO=KONM5V-UEDzgjCc=uEXtG32NowA@mail.gmail.com>
From: Naveen Krishna Ch <naveenkrishna.ch@gmail.com>
Date: Fri, 11 Jul 2014 14:52:07 +0530
Message-ID: <CAHfPSqCZqefvqe3DZiBN_g1O6mvhTLbJXLikuBw2YiTtVYeBmg@mail.gmail.com>
Subject: Re: [PATCH 2/4] Documentation: dt-bindings: move exynos-adc.txt to
 more iio/adc/
To: Sachin Kamat <spk.linux@gmail.com>
Cc: Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        linux-iio@vger.kernel.org,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Lars-Peter Clausen <lars@metafoo.de>, cpgs@samsung.com,
        grundler@chromium.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Sachin,

On 11 July 2014 14:47, Sachin Kamat <spk.linux@gmail.com> wrote:
> Hi Naveen,
>
> On Fri, Jul 11, 2014 at 2:36 PM, Naveen Krishna Chatradhi
> <ch.naveen@samsung.com> wrote:
>> The DT bindings in exynos-adc.txt applies to the ADC
>> driver (exynos-adc.c) developed based on IIO framework.
>>
>> The bindings are more appropriate to be under
>> Documentation/devicetree/bindings/iio/adc/
>>
>> Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
>> To: devicetree@vger.kernel.org
>> ---
>>  .../devicetree/bindings/arm/samsung/exynos-adc.txt |   82 --------------------
>>  .../devicetree/bindings/iio/adc/exynos-adc.txt     |   82 ++++++++++++++++++++
>>  2 files changed, 82 insertions(+), 82 deletions(-)
>>  delete mode 100644 Documentation/devicetree/bindings/arm/samsung/exynos-adc.txt
>>  create mode 100644 Documentation/devicetree/bindings/iio/adc/exynos-adc.txt
>>
>
> Tip: For only a file move or rename please use "-M" with git
> format-patch. That will make the
> patch concise.

Sure, Thanks.
>
> --
> Regards,
> Sachin.



-- 
Shine bright,
(: Nav :)

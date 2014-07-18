Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965696AbaGRQsW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 12:48:22 -0400
Received: from mail-ig0-f182.google.com ([209.85.213.182]:54285 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756009AbaGRQsT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 12:48:19 -0400
MIME-Version: 1.0
In-Reply-To: <10264770.8SXiIS8qhq@wuerfel>
References: <1405663186-26464-1-git-send-email-cw00.choi@samsung.com>
	<32226622.5gSmvBRKvZ@wuerfel>
	<CAGTfZH3vz9MLN+1fPM22zKE64oMNDgcib3is0nfzZhhLkmdNvw@mail.gmail.com>
	<10264770.8SXiIS8qhq@wuerfel>
Date: Sat, 19 Jul 2014 01:48:18 +0900
Message-ID: <CAGTfZH1jOEj8D6kJSd=-dgpSiU=sxs5W2TM=-rNtsZb-SkRD9Q@mail.gmail.com>
Subject: Re: [PATCHv6 2/4] iio: adc: exynos_adc: Control special clock of ADC
 to support Exynos3250 ADC
From: Chanwoo Choi <cwchoi00@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Mark Rutland <mark.rutland@arm.com>,
        devicetree <devicetree@vger.kernel.org>,
        Kukjin Kim <kgene.kim@samsung.com>, pawel.moll@arm.com,
        ijc+devicetree@hellion.org.uk, linux-iio@vger.kernel.org,
        Tomasz Figa <t.figa@samsung.com>, rdunlap@infradead.org,
        linux-doc@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Chanwoo Choi <cw00.choi@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Kumar Gala <galak@codeaurora.org>,
        naveen krishna <ch.naveen@samsung.com>, jic23@kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 19, 2014 at 1:31 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Saturday 19 July 2014 01:11:53 Chanwoo Choi wrote:
>>
>>   Exynos3250/Exynos4/Exynos5 has 'adc' clock as following:
>>   - 'adc' clock: bus clock for ADC
>>
>>   Exynos3250 has additional 'sclk_adc' clock as following:
>>   - 'sclk_adc' clock: special clock for ADC which provide clock to internal ADC
>
> The bus clock is often named "apb_pclk", but it's too late to change
> that now, and it's not clear if the device is actually on APB.
>
> The problem with "sclk_adc" is that it's very close to the name used
> in the clock provider, with is CLK_SCLK_TSADC. Please try to avoid
> the ambiguity here and make it clear that they are not referring
> to the same thing. "internal" or "special" might be good if you want
> to avoid "sclk".

OK, thanks for your feedback.
I'll try to find proper name.

Chanwoo Choi

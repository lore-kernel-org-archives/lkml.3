Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965069AbaGRPPi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 11:15:38 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:63626 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755944AbaGRPPg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 11:15:36 -0400
MIME-Version: 1.0
In-Reply-To: <6917971.QKItNU3coA@wuerfel>
References: <1405663186-26464-1-git-send-email-cw00.choi@samsung.com>
	<6485839.CnzmD0SeQj@wuerfel>
	<53C8F050.6060104@samsung.com>
	<6917971.QKItNU3coA@wuerfel>
Date: Sat, 19 Jul 2014 00:15:35 +0900
Message-ID: <CAGTfZH1EHiTpo2Abua=+kDfNoOQx+ydPHU51=+qW8mgCL4Lwvg@mail.gmail.com>
Subject: Re: [PATCHv6 2/4] iio: adc: exynos_adc: Control special clock of ADC
 to support Exynos3250 ADC
From: Chanwoo Choi <cwchoi00@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Chanwoo Choi <cw00.choi@samsung.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        jic23@kernel.org, naveen krishna <ch.naveen@samsung.com>,
        Mark Rutland <mark.rutland@arm.com>,
        devicetree <devicetree@vger.kernel.org>,
        Kukjin Kim <kgene.kim@samsung.com>, pawel.moll@arm.com,
        ijc+devicetree@hellion.org.uk, linux-iio@vger.kernel.org,
        Tomasz Figa <t.figa@samsung.com>, rdunlap@infradead.org,
        linux-doc@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Rob Herring <robh+dt@kernel.org>, galak@codeaurora.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 18, 2014 at 8:14 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Friday 18 July 2014 19:00:48 Chanwoo Choi wrote:
>> On 07/18/2014 06:47 PM, Arnd Bergmann wrote:
>> >
>> > Further, why is it called "sclk_adc" rather than just "sclk"?
>>
>> The sclk means 'special clock' in Exynos TRM. Exynos SoC has varisou sclk clocks.
>> 'sclk_adc' is only used for ADC IP.
>
> But that sounds like sclk_adc is the name of the global name
> of the clock signal coming out of the clock controller.
>
> I still think it would be best to name it 'sclk' as the input
> for the adc. It shouldn't rely on a particular name of the
> clock controller.

I think 'sclk' is too common name. 'sclk' don't include specific device name.
As I know, usual clock name includes the name of IP or includes the
specific meaning for each IP.

In my opinion, I think sclk_adc is better than 'sclk'.

Thanks,
Chanwoo Choi

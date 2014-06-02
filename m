Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754945AbaFBRPy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 13:15:54 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:54824 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752260AbaFBRPv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 13:15:51 -0400
Message-ID: <538CB143.5020504@wwwdotorg.org>
Date: Mon, 02 Jun 2014 11:15:47 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Olof Johansson <olof@lixom.net>, Marcel Ziswiler <marcel@ziswiler.com>
CC: Thierry Reding <thierry.reding@gmail.com>,
        "arm@kernel.org" <arm@kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        stefan@agner.ch
Subject: Re: [PATCH 1/3] arm: multi_v7: enable igb, stmpe, spidev, lm95245,
 pwm leds
References: <cc612cd3f24f01cfc8fd3e81b1027ff94862e8b4.1401700579.git.marcel@ziswiler.com> <CAOesGMg6aBpH18VO6XF1HxbXsJy92QadT3MVT2vOY41s=oCRrw@mail.gmail.com>
In-Reply-To: <CAOesGMg6aBpH18VO6XF1HxbXsJy92QadT3MVT2vOY41s=oCRrw@mail.gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/02/2014 11:01 AM, Olof Johansson wrote:
> On Mon, Jun 2, 2014 at 2:43 AM, Marcel Ziswiler <marcel@ziswiler.com> wrote:
>> The NVIDIA Tegra 3 based Apalis T30 module contains an Intel i210 resp.
>> i211 gigabit Ethernet controller, an STMPE811 ADC/touch controller,
>> SPI bus and PWM LEDs generically accessible from user space and an
>> LM95245 temperature sensor chip. The later four can also be found on
>> the Colibri T30 module.
>>
>> While at it move the NEON entry down to its proper place to have it all
>> nicely ordered again.
>>
>> Signed-off-by: Marcel Ziswiler <marcel@ziswiler.com>
>> ---
>> BTW: How about TEGRA_EMC_SCALING_ENABLE, MACH_UX500_DT, OMAP_USB3 and
>> MMC_SUNXI which I haven't found any mentioning anywhere, MTD_M25P80
>> which depends on MTD_SPI_NOR or DOVE_THERMAL which depends on the
>> legacy ARCH_DOVE (besides USE_OF of course) being not much of multi
>> compatible?
> 
> Can you resend towards the end of the merge window, please? We should
> make a pass and update anything new that has been merged for 3.16
> around then.

I think the content in this patch is for 3.17. The issues mentioned
below --- would be worth fixing for 3.16.

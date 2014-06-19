Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932687AbaFSLmQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 07:42:16 -0400
Received: from top.free-electrons.com ([176.31.233.9]:59293 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932579AbaFSLmN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 07:42:13 -0400
Message-ID: <53A2CC92.6050508@free-electrons.com>
Date: Thu, 19 Jun 2014 13:42:10 +0200
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Bo Shen <voice.shen@atmel.com>
CC: Thierry Reding <thierry.reding@gmail.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        David Airlie <airlied@linux.ie>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>, devicetree@vger.kernel.org,
        Jean-Jacques Hiblot <jjhiblot@traphandler.com>,
        linux-doc@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, linux-pwm@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 4/7] ARM: at91/dt: split sama5d3 lcd pin definitions
 to match RGB mode configs
References: <1402329860-27520-1-git-send-email-boris.brezillon@free-electrons.com> <1402329860-27520-5-git-send-email-boris.brezillon@free-electrons.com> <53A28C2C.1010001@atmel.com>
In-Reply-To: <53A28C2C.1010001@atmel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 19/06/2014 09:07, Bo Shen wrote:
> Hi Boris,
>
> On 06/10/2014 12:04 AM, Boris BREZILLON wrote:
>> The HLCDC (High LCD Controller) IP supports 4 different output mode
>> (RGB444, RGB565, RGB666 and RGB888) and the pin muxing depends on the
>> chosen RGB mode.
>>
>> Split the pin definition to be able to set the pin config according
>> to the
>> selected mode.
>>
>> Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
>> ---
>>   arch/arm/boot/dts/sama5d3_lcd.dtsi | 127
>> ++++++++++++++++++++++++++++---------
>>   1 file changed, 96 insertions(+), 31 deletions(-)
>
> On sama5d3xek board, it only works in 24bits output mode. And it
> depends on the hardware design. So, I think only keep only one pinctrl
> configuration.

As you pointed out (during our discussion on IRC) sama5d3 SoCs support
several pin muxing for LCDDAT pins.
I'll take care to define all these pin mux here and select the
appropriate ones in sama5d3xdm.dtsi (patch 6) instead of
sama5d3_lcd.dtsi (patch 5).


Best Regards,

Boris

-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com


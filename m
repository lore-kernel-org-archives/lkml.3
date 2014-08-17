Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751652AbaHQPVI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2014 11:21:08 -0400
Received: from mail-ig0-f171.google.com ([209.85.213.171]:35926 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751282AbaHQPVG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2014 11:21:06 -0400
MIME-Version: 1.0
In-Reply-To: <20140817080204.GY15297@lukather>
References: <1408247538-16950-1-git-send-email-wens@csie.org>
 <1408247538-16950-12-git-send-email-wens@csie.org> <20140817080204.GY15297@lukather>
From: Chen-Yu Tsai <wens@csie.org>
Date: Sun, 17 Aug 2014 23:20:44 +0800
X-Google-Sender-Auth: uHUu4VUxLuGWCVKFiCuG4PqTmpM
Message-ID: <CAGb2v67NwsJORoFrgEECDtexXGtF5qOx7NX1PVpZHkjVs-mG2A@mail.gmail.com>
Subject: Re: [PATCH 11/12] ARM: dts: sun8i: Add i2c controller nodes
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-sunxi <linux-sunxi@googlegroups.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, Aug 17, 2014 at 4:02 PM, Maxime Ripard
<maxime.ripard@free-electrons.com> wrote:
> Hi,
>
> On Sun, Aug 17, 2014 at 11:52:17AM +0800, Chen-Yu Tsai wrote:
>> Add nodes for the 3 i2c controllers found on A23 SoCs to the sun8i DTSI.
>>
>> Signed-off-by: Chen-Yu Tsai <wens@csie.org>
>> ---
>>  arch/arm/boot/dts/sun8i-a23.dtsi | 36 ++++++++++++++++++++++++++++++++++++
>>  1 file changed, 36 insertions(+)
>>
>> diff --git a/arch/arm/boot/dts/sun8i-a23.dtsi b/arch/arm/boot/dts/sun8i-a23.dtsi
>> index 4658998..53ef350 100644
>> --- a/arch/arm/boot/dts/sun8i-a23.dtsi
>> +++ b/arch/arm/boot/dts/sun8i-a23.dtsi
>> @@ -387,6 +387,42 @@
>>                       status = "disabled";
>>               };
>>
>> +             i2c0: i2c@01c2ac00 {
>> +                     compatible = "allwinner,sun6i-a31-i2c";
>> +                     reg = <0x01c2ac00 0x400>;
>> +                     interrupts = <0 6 4>;
>> +                     clocks = <&apb2_gates 0>;
>> +                     clock-frequency = <100000>;
>
> It's the default, you don't need to set it.

Ah, just checked the driver, it is indeed the default.
All the other sunxi dtsi have it though. Do we want to be consistent?


ChenYu

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751878AbaHRP53 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 11:57:29 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:57014 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751372AbaHRP52 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 11:57:28 -0400
MIME-Version: 1.0
In-Reply-To: <20140818142737.GC15297@lukather>
References: <1408247538-16950-1-git-send-email-wens@csie.org>
 <1408247538-16950-12-git-send-email-wens@csie.org> <20140817080204.GY15297@lukather>
 <CAGb2v67NwsJORoFrgEECDtexXGtF5qOx7NX1PVpZHkjVs-mG2A@mail.gmail.com> <20140818142737.GC15297@lukather>
From: Chen-Yu Tsai <wens@csie.org>
Date: Mon, 18 Aug 2014 23:57:06 +0800
X-Google-Sender-Auth: f3ZQWvqD0o27EmQXgH1SP-95VCQ
Message-ID: <CAGb2v65ODS83D2LfiHs0o1D4yJ6xmOJ8vULPcfrcUu79SQvfTw@mail.gmail.com>
Subject: Re: [linux-sunxi] Re: [PATCH 11/12] ARM: dts: sun8i: Add i2c
 controller nodes
To: "maxime.ripard" <maxime.ripard@free-electrons.com>
Cc: linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-sunxi <linux-sunxi@googlegroups.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 18, 2014 at 10:27 PM, Maxime Ripard
<maxime.ripard@free-electrons.com> wrote:
> On Sun, Aug 17, 2014 at 11:20:44PM +0800, Chen-Yu Tsai wrote:
>> Hi,
>>
>> On Sun, Aug 17, 2014 at 4:02 PM, Maxime Ripard
>> <maxime.ripard@free-electrons.com> wrote:
>> > Hi,
>> >
>> > On Sun, Aug 17, 2014 at 11:52:17AM +0800, Chen-Yu Tsai wrote:
>> >> Add nodes for the 3 i2c controllers found on A23 SoCs to the sun8i DTSI.
>> >>
>> >> Signed-off-by: Chen-Yu Tsai <wens@csie.org>
>> >> ---
>> >>  arch/arm/boot/dts/sun8i-a23.dtsi | 36 ++++++++++++++++++++++++++++++++++++
>> >>  1 file changed, 36 insertions(+)
>> >>
>> >> diff --git a/arch/arm/boot/dts/sun8i-a23.dtsi b/arch/arm/boot/dts/sun8i-a23.dtsi
>> >> index 4658998..53ef350 100644
>> >> --- a/arch/arm/boot/dts/sun8i-a23.dtsi
>> >> +++ b/arch/arm/boot/dts/sun8i-a23.dtsi
>> >> @@ -387,6 +387,42 @@
>> >>                       status = "disabled";
>> >>               };
>> >>
>> >> +             i2c0: i2c@01c2ac00 {
>> >> +                     compatible = "allwinner,sun6i-a31-i2c";
>> >> +                     reg = <0x01c2ac00 0x400>;
>> >> +                     interrupts = <0 6 4>;
>> >> +                     clocks = <&apb2_gates 0>;
>> >> +                     clock-frequency = <100000>;
>> >
>> > It's the default, you don't need to set it.
>>
>> Ah, just checked the driver, it is indeed the default.
>> All the other sunxi dtsi have it though. Do we want to be consistent?
>
> Yep, it's usually a good thing :)

I'll do additional patches to remove them from the other dtsi then.

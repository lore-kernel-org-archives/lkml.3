Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932280AbaJHNln (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 09:41:43 -0400
Received: from mail-ig0-f180.google.com ([209.85.213.180]:35816 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756119AbaJHNlk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 09:41:40 -0400
MIME-Version: 1.0
In-Reply-To: <54353CE5.5070808@gmail.com>
References: <1412773376-25212-1-git-send-email-wens@csie.org>
 <1412773376-25212-4-git-send-email-wens@csie.org> <54353CE5.5070808@gmail.com>
From: Chen-Yu Tsai <wens@csie.org>
Date: Wed, 8 Oct 2014 21:41:18 +0800
X-Google-Sender-Auth: iV6RutdT5utW4qxZfKnMr0irQuM
Message-ID: <CAGb2v65bPWvcs8CkOVgUhRRfhU6dz=WDt98wRMAjD+Hb3wbk8A@mail.gmail.com>
Subject: Re: [PATCH v3 3/5] ARM: dts: sun9i: Add A80 Optimus Board support
To: Dinh Nguyen <dinh.linux@gmail.com>
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        devicetree <devicetree@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Shuge <shuge@allwinnertech.com>, Meng Zhang <kevin@allwinnertech.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 8, 2014 at 9:32 PM, Dinh Nguyen <dinh.linux@gmail.com> wrote:
>
>
> On 10/8/14, 8:02 AM, Chen-Yu Tsai wrote:
>> The A80 Optimus Board is was launched with the Allwinner A80 SoC.
>> It was jointly developed by Allwinner and Merrii.
>>
>> This board has a UART port, a JTAG connector, USB host ports, a USB
>> 3.0 OTG connector, an HDMI output, a micro SD slot, 8G NAND flash,
>> 4G DRAM, a camera sensor interface, a WiFi/BT combo chip, a headphone
>> jack, IR receiver, and additional GPIO headers.
>>
>> This patch adds only basic support.
>>
>> Signed-off-by: Chen-Yu Tsai <wens@csie.org>
>> ---
>>  arch/arm/boot/dts/Makefile              |  2 +
>>  arch/arm/boot/dts/sun9i-a80-optimus.dts | 66 +++++++++++++++++++++++++++++++++
>>  2 files changed, 68 insertions(+)
>>  create mode 100644 arch/arm/boot/dts/sun9i-a80-optimus.dts
>>
> [...]
>> +
>> +/dts-v1/;
>> +/include/ "sun9i-a80.dtsi"
>> +
>> +/ {
>> +     model = "Merrii A80 Optimus Board";
>> +     compatible = "merrii,a80-optimus", "allwinner,sun9i-a80";
>
> "merrii" should be added to vendor-prefixes.txt

A patch for that was already queued by Maxime.

ChenYu

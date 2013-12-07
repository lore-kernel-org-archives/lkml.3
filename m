Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758339Ab3LGQUn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Dec 2013 11:20:43 -0500
Received: from mail-vc0-f180.google.com ([209.85.220.180]:36501 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755184Ab3LGQUj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Dec 2013 11:20:39 -0500
MIME-Version: 1.0
In-Reply-To: <20131207101510.GJ24519@lukather>
References: <1386350983-13281-1-git-send-email-wens@csie.org>
 <1386350983-13281-11-git-send-email-wens@csie.org> <20131207101510.GJ24519@lukather>
From: Chen-Yu Tsai <wens@csie.org>
Date: Sun, 8 Dec 2013 00:20:18 +0800
X-Google-Sender-Auth: _hv0NJUCP7wzLeF3SSPLZQ2Lj44
Message-ID: <CAGb2v65uX8tgsBuSsnCOJ=qTeqjBXC3aRTJrk53gbJfJQqWXtA@mail.gmail.com>
Subject: Re: [PATCH 10/10] ARM: dts: sun7i: Add ethernet alias for GMAC
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        netdev <netdev@vger.kernel.org>, Rob Herring <rob.herring@calxeda.com>,
        devicetree <devicetree@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-sunxi <linux-sunxi@googlegroups.com>,
        Srinivas Kandagatla <srinivas.kandagatla@st.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I will rebase onto 3.13-rc3 or 3.13 when it comes out.

On Sat, Dec 7, 2013 at 6:15 PM, Maxime Ripard
<maxime.ripard@free-electrons.com> wrote:
> Hi Chen-Yu,
>
> On Sat, Dec 07, 2013 at 01:29:43AM +0800, Chen-Yu Tsai wrote:
>> U-Boot will insert MAC address into the device tree image.
>> It looks up ethernet[0-5] aliases to find the ethernet nodes.
>> Alias GMAC as ethernet0, as it is the only ethernet controller used.
>>
>> Signed-off-by: Chen-Yu Tsai <wens@csie.org>
>> ---
>>  arch/arm/boot/dts/sun7i-a20.dtsi | 4 ++++
>>  1 file changed, 4 insertions(+)
>>
>> diff --git a/arch/arm/boot/dts/sun7i-a20.dtsi b/arch/arm/boot/dts/sun7i-a20.dtsi
>> index 64b1391..f7c57c6 100644
>> --- a/arch/arm/boot/dts/sun7i-a20.dtsi
>> +++ b/arch/arm/boot/dts/sun7i-a20.dtsi
>> @@ -16,6 +16,10 @@
>>  / {
>>       interrupt-parent = <&gic>;
>>
>> +     aliases {
>> +             ethernet0 = &gmac;
>> +     };
>> +
>
> Actually, it conflicts with
> http://lists.infradead.org/pipermail/linux-arm-kernel/2013-November/211695.html
>
> Please rebase accordingly.
>
> Thanks,
> Maxime
>
> --
> Maxime Ripard, Free Electrons
> Embedded Linux, Kernel and Android engineering
> http://free-electrons.com

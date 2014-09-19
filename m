Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755353AbaISJzy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 05:55:54 -0400
Received: from mail-vc0-f171.google.com ([209.85.220.171]:49224 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751978AbaISJzw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 05:55:52 -0400
MIME-Version: 1.0
In-Reply-To: <20140918134613.GK4796@dragon>
References: <cover.1410873422.git.maitysanchayan@gmail.com>
	<1015e874d5b13795e38069402a66b4798d79b632.1410873422.git.maitysanchayan@gmail.com>
	<20140918134613.GK4796@dragon>
Date: Fri, 19 Sep 2014 15:25:51 +0530
Message-ID: <CANkTNWDXkGSENi0QE2RJ96mWvRpiGdudMP24Wrw=Q_Df=1jKpw@mail.gmail.com>
Subject: Re: [PATCH 1/2] ARM: dts: vf610-colibri: Add ADC support
From: Sanchayan Maity <maitysanchayan@gmail.com>
To: Shawn Guo <shawn.guo@freescale.com>
Cc: Stefan Agner <stefan@agner.ch>, B38611@freescale.com,
        linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, jic23@kernel.org,
        linux-iio@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Enable ADC support for Colibri VF61 modules
>>
>> Signed-off-by: Sanchayan Maity <maitysanchayan@gmail.com>
>> ---
>>  arch/arm/boot/dts/vf610-colibri.dtsi |   10 ++++++++++
>>  1 file changed, 10 insertions(+)
>>
>> diff --git a/arch/arm/boot/dts/vf610-colibri.dtsi b/arch/arm/boot/dts/vf610-colibri.dtsi
>> index 0cd8343..275ebec 100644
>> --- a/arch/arm/boot/dts/vf610-colibri.dtsi
>> +++ b/arch/arm/boot/dts/vf610-colibri.dtsi
>> @@ -69,6 +69,16 @@
>>       status = "okay";
>>  };
>>
>> +&adc0 {
>> +     pinctrl-names = "default";
>> +     status = "okay";
>> +};
>> +
>> +&adc1 {
>> +     pinctrl-names = "default";
>> +     status = "okay";
>> +};
>> +
>
> Please sort the nodes alphabetically in node name.

Thanks for the input. Will clean and resend.

Sanchayan

>
> Shawn
>
>>  &iomuxc {
>>       vf610-colibri {
>>               pinctrl_esdhc1: esdhc1grp {
>> --
>> 1.7.9.5
>>

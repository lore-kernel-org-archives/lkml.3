Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934165AbaFRIvl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 04:51:41 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:53437 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933839AbaFRIvg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 04:51:36 -0400
X-AuditID: cbfee68e-b7fb96d000004bfc-8b-53a153159190
Message-id: <53A15315.6060304@samsung.com>
Date: Wed, 18 Jun 2014 17:51:33 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Tomasz Figa <tomasz.figa@gmail.com>
Cc: jic23@kernel.org, ch.naveen@samsung.com, t.figa@samsung.com,
        kgene.kim@samsung.com, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, rdunlap@infradead.org, sachin.kamat@linaro.org,
        linux-iio@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: Re: [PATCHv4 4/4] ARM: dts: Fix wrong compatible string for Exynos3250
 ADC
References: <1403058061-24271-1-git-send-email-cw00.choi@samsung.com>
 <1403058061-24271-5-git-send-email-cw00.choi@samsung.com>
 <53A14FAC.3050700@gmail.com>
In-reply-to: <53A14FAC.3050700@gmail.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmphleLIzCtJLcpLzFFi42JZI2JSoCsavDDYYPpURYu7zw8zWsw/co7V
	ov/NQlaLc69WMlo8aFrFZNG74CqbxcK2JSwW8468Y7G4vGsOm8WM8/uYLJZev8hkMWH6WhaL
	t3ems1i07j3CbnHyTy+jxfoZr1ksVu36w+gg6LFm3hpGj8t9vUweO2fdZfdYufwLm8fmFVoe
	m1Z1snncubaHzaNvyypGj8+b5AI4o7hsUlJzMstSi/TtErgyurdNZS5o565oX+XWwPiPo4uR
	k0NCwETi+pH1rBC2mMSFe+vZuhi5OIQEljJKPN+zlxWmaN67A0wQiemMEh9/PWSEcF4zSkxt
	fMoOUsUroCVx7sVGFhCbRUBV4sf6b0wgNhtQfP+LG2wgtqhAmMTK6VdYIOoFJX5Mvgdmiwio
	S3yb0g82h1lgGrNEyywfEFtYIFTi84ROFohlC4A232sGG8QpoClxY+YtJogGHYn9rdPYIGx5
	ic1r3jKDNEgIrOWQeLp4HjvERQIS3yYfAprEAZSQldh0gBniNUmJgytusExgFJuF5KZZSMbO
	QjJ2ASPzKkbR1ILkguKk9CIjveLE3OLSvHS95PzcTYzAFHD637O+HYw3D1gfYkwGWjmRWUo0
	OR+YQvJK4g2NzYwsTE1MjY3MLc1IE1YS5130MClISCA9sSQ1OzW1ILUovqg0J7X4ECMTB6dU
	A2PErmdsH+UjK1ZO8t1/t+7p5eh5/KsEvj1cnfyv48sJPa99EnOLmu4dO3Zcasvd+1pHL9tu
	+5On+yOo7mNE3JrgxUyp32aVTHjmuZcre2X7hI+JPbKtvczBHx9wROXwyEktVN/Wqno76MZP
	vvUdOb+L7jJ6xZ9WSjs5Re24a/SKV79lF7vYVb9RYinOSDTUYi4qTgQAv5/ZHRcDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrIKsWRmVeSWpSXmKPExsVy+t9jQV3R4IXBBjdbJCzuPj/MaDH/yDlW
	i/43C1ktzr1ayWjxoGkVk0XvgqtsFgvblrBYzDvyjsXi8q45bBYzzu9jslh6/SKTxYTpa1ks
	3t6ZzmLRuvcIu8XJP72MFutnvGaxWLXrD6ODoMeaeWsYPS739TJ57Jx1l91j5fIvbB6bV2h5
	bFrVyeZx59oeNo++LasYPT5vkgvgjGpgtMlITUxJLVJIzUvOT8nMS7dV8g6Od443NTMw1DW0
	tDBXUshLzE21VXLxCdB1y8wBekZJoSwxpxQoFJBYXKykb4dpQmiIm64FTGOErm9IEFyPkQEa
	SFjDmNG9bSpzQTt3RfsqtwbGfxxdjJwcEgImEvPeHWCCsMUkLtxbz9bFyMUhJDCdUeLjr4eM
	EM5rRompjU/ZQap4BbQkzr3YyAJiswioSvxY/w2smw0ovv/FDTYQW1QgTGLl9CssEPWCEj8m
	3wOzRQTUJb5N6QebwywwjVmiZZYPiC0sECrxeUInC8SyBUCb7zWDDeIU0JS4MfMWE0SDjsT+
	1mlsELa8xOY1b5knMArMQrJjFpKyWUjKFjAyr2IUTS1ILihOSs810itOzC0uzUvXS87P3cQI
	TjDPpHcwrmqwOMQowMGoxMPLkbsgWIg1say4MvcQowQHs5II7xTPhcFCvCmJlVWpRfnxRaU5
	qcWHGJOBQTCRWUo0OR+Y/PJK4g2NTcyMLI3MDS2MjM1JE1YS5z3Yah0oJJCeWJKanZpakFoE
	s4WJg1OqgXED+xe5+3FCBZOyvxhsuDN3U36Z6LOjQWzxOzpDGYzsfxrWM8X8M9r/+8/vb9ZP
	zc7cTH13pEVHzJVxU3G4S/Ly7dw/IuZfryo4Ip4ybdnMKRvLVeRjNXZmX4wQcVnF/JH3j7Vr
	0kfml7EP3xVYL+duFGcT47i4jOPwhnKVCKFGc75q3hN8M5RYijMSDbWYi4oTATCNtX90AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomasz,

On 06/18/2014 05:37 PM, Tomasz Figa wrote:
> Hi Chanwoo,
> 
> On 18.06.2014 04:21, Chanwoo Choi wrote:
>> This patchset fix wrong compatible string for Exynos3250 ADC. Exynos3250 SoC
>> need to control only special clock for ADC. Exynos SoC except for Exynos3250
>> has not included special clock for ADC. The exynos ADC driver can control
>> special clock if compatible string is 'exynos3250-adc-v2'.
>>
>> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
>> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
>> ---
>>  arch/arm/boot/dts/exynos3250.dtsi | 4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/arm/boot/dts/exynos3250.dtsi b/arch/arm/boot/dts/exynos3250.dtsi
>> index 6c1fb67..107dc44 100644
>> --- a/arch/arm/boot/dts/exynos3250.dtsi
>> +++ b/arch/arm/boot/dts/exynos3250.dtsi
>> @@ -414,10 +414,10 @@
>>  		};
>>  
>>  		adc: adc@126C0000 {
>> -			compatible = "samsung,exynos-adc-v3";
>> +			compatible = "samsung,exynos3250-adc-v2";
>>  			reg = <0x126C0000 0x100>, <0x10020718 0x4>;
>>  			interrupts = <0 137 0>;
>> -			clock-names = "adc", "sclk_tsadc";
>> +			clock-names = "adc", "sclk_adc";
> 
> So, is it "sclk_adc" or "sclk_tsadc"? The code uses the former, while
> the documentation mentions the latter. Please fix this.

OK, I'll fix it by using 'sclk_adc' clock name.

Best Regards,
Chanwoo Choi


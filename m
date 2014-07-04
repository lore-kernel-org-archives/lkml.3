Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756243AbaGDIAm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 04:00:42 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:11661 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752539AbaGDIAj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 04:00:39 -0400
X-AuditID: cbfee691-b7f2f6d0000040c4-5f-53b65f241b3b
Message-id: <53B65F1C.5060303@samsung.com>
Date: Fri, 04 Jul 2014 17:00:28 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: linux@arm.linux.org.uk, t.figa@samsung.com, kyungmin.park@samsung.com,
        ideal.song@samsung.com, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: dts: Add I2S dt node for Exynos3250
References: <1404373939-10510-1-git-send-email-cw00.choi@samsung.com>
 <02fa01cf975b$947d6e20$bd784a60$@samsung.com>
In-reply-to: <02fa01cf975b$947d6e20$bd784a60$@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrDIsWRmVeSWpSXmKPExsWyRsSkUFclfluwQec3NYtdf+8zWvQuuMpm
	cbbpDbvFpsfXWC0u75rDZjHj/D4mi9uXeS3Wz3jN4sDh0dLcw+axeUm9R9+WVYwenzfJBbBE
	cdmkpOZklqUW6dslcGV8fPSXueA5d8WSJwtZGxgvcXYxcnJICJhI7D72mA3CFpO4cG89kM3F
	ISSwlFGi599GFpii/W1T2SESixglbj+bDpYQEnjNKPH3gn0XIwcHr4CWxN8bOiBhFgFViSfz
	P7KD2GxA4f0vboAtEBUIk1g5/QpYK6+AoMSPyffAbBEBNYmexVsZQeYzC5xhlPj0/RtYg7CA
	rUTXsQaoXaUSj48sYAKxOQWsJJ6eegW2gFlAR2J/6zQ2CFteYvOat8wggyQEzrFLHLsygQ3i
	IgGJb5MPsYAcKiEgK7HpADPEY5ISB1fcYJnAKDYLyU2zkIydhWTsAkbmVYyiqQXJBcVJ6UWm
	esWJucWleel6yfm5mxiBMXf637OJOxjvH7A+xJgMtHIis5Rocj4wZvNK4g2NzYwsTE1MjY3M
	Lc1IE1YS501/lBQkJJCeWJKanZpakFoUX1Sak1p8iJGJg1OqgdFQ+6Tv+VN8MtWxkrteBUkr
	Trgipx/aPcdFcatLxL3AlY9PNuvNkC/d9fn33R/aCS3nzqx5aHVofTEXq8m9Vytctvu+Xbb8
	tTnrdYtrJrzblp0sNKmSW+HXvEBY9IqBe4qB/+S/+9wr/cx6Il52Kqp632I7IxIZLT3PWPql
	tfjK09Eux16qrFRiKc5INNRiLipOBAAlqKK7zwIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNIsWRmVeSWpSXmKPExsVy+t9jAV3Z+G3BBss7GC12/b3PaNG74Cqb
	xdmmN+wWmx5fY7W4vGsOm8WM8/uYLG5f5rVYP+M1iwOHR0tzD5vH5iX1Hn1bVjF6fN4kF8AS
	1cBok5GamJJapJCal5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQN0hZJC
	WWJOKVAoILG4WEnfDtOE0BA3XQuYxghd35AguB4jAzSQsIYx4+Ojv8wFz7krljxZyNrAeImz
	i5GTQ0LARGJ/21R2CFtM4sK99WxdjFwcQgKLGCVuP5vOApIQEnjNKPH3gn0XIwcHr4CWxN8b
	OiBhFgFViSfzP4L1sgGF97+4wQZiiwqESaycfgWslVdAUOLH5HtgtoiAmkTP4q2MIPOZBc4w
	Snz6/g2sQVjAVqLrWAPUrlKJx0cWMIHYnAJWEk9PvQJbwCygI7G/dRobhC0vsXnNW+YJjAKz
	kOyYhaRsFpKyBYzMqxhFUwuSC4qT0nMN9YoTc4tL89L1kvNzNzGCI/qZ1A7GlQ0WhxgFOBiV
	eHg9irYGC7EmlhVX5h5ilOBgVhLhrVLaFizEm5JYWZValB9fVJqTWnyI0RQYBBOZpUST84HJ
	Jq8k3tDYxMzI0sjc0MLI2FxJnPdAq3WgkEB6YklqdmpqQWoRTB8TB6dUA+OUep/iHZdu1ahl
	fvZrUzm25odyxeS5t4R+M4q81n7q75GQ4DaVPSuR7V/WjzfCR56LPRdyWT/n6KHysrnT9jXN
	/mjdpv5Nlfew6cH+/9rRhQXeE7b8ef1LrTSEkfVOk8SqA2pTxe5J5j0sZN3H+3Pazc165Uv8
	ryZfe/DpaNm9TtfY81ZpG6YrsRRnJBpqMRcVJwIAQbbCL/4CAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/04/2014 04:43 PM, Kukjin Kim wrote:
> Chanwoo Choi wrote:
>>
>> From: Tomasz Figa <t.figa@samsung.com>
>>
>> This patch add I2S (Inter-IC Sound) dt node which supports 1-port stereo
>> (1 channels) IIS-bus for audio interface with DMA-based operation.
>>
>> Signed-off-by: Tomasz Figa <t.figa@samsung.com>
>> Signed-off-by: Inha Song <ideal.song@samsung.com>
>> Tested-by: Inha Song <ideal.song@samsung.com>
>> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
>> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
>> ---
>>  arch/arm/boot/dts/exynos3250.dtsi | 13 +++++++++++++
>>  1 file changed, 13 insertions(+)
>>
>> diff --git a/arch/arm/boot/dts/exynos3250.dtsi b/arch/arm/boot/dts/exynos3250.dtsi
>> index 1f8384f..e9017ef 100644
>> --- a/arch/arm/boot/dts/exynos3250.dtsi
>> +++ b/arch/arm/boot/dts/exynos3250.dtsi
>> @@ -644,6 +644,19 @@
>>  			status = "disabled";
>>  		};
>>
>> +		i2s: i2s@13970000 {
>> +			compatible = "samsung,s3c6410-i2s";
>> +			reg = <0x13970000 0x100>;
>> +			interrupts = <0 126 0>;
>> +			clocks = <&cmu CLK_I2S>, <&cmu CLK_SCLK_I2S>;
>> +			clock-names = "iis", "i2s_opclk0";
>> +			dmas = <&pdma0 14>, <&pdma0 13>;
>> +			dma-names = "tx", "rx";
>> +			pinctrl-0 = <&i2s2_bus>;
>> +			pinctrl-name = "default";
> 
> To put 'pinctrl-name' and then 'pinctrl-0' is better? :-)

The i2s dt node can drop "pinctrl-0/pinctrl-name" properties.

I will re-send this patchset (v2) after fixing it.

Best Regards,
Chanwoo Choi

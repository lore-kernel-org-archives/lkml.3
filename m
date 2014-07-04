Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932094AbaGDJST (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 05:18:19 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:21595 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752028AbaGDJSR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 05:18:17 -0400
X-AuditID: cbfee68d-b7fd46d000005f36-99-53b67156729f
Message-id: <53B67156.2020702@samsung.com>
Date: Fri, 04 Jul 2014 18:18:14 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Tomasz Figa <tomasz.figa@gmail.com>
Cc: linux@arm.linux.org.uk, kgene.kim@samsung.com, t.figa@samsung.com,
        kyungmin.park@samsung.com, ideal.song@samsung.com,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: dts: Add I2S dt node for Exynos3250
References: <1404373939-10510-1-git-send-email-cw00.choi@samsung.com>
 <53B66066.4030202@gmail.com>
In-reply-to: <53B66066.4030202@gmail.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrOIsWRmVeSWpSXmKPExsWyRsSkUDescFuwQd98EYtdf+8zWvQuuMpm
	cbbpDbvFpsfXWC0u75rDZjHj/D4mi9uXeS3Wz3jNYrFq1x9GB06PluYeNo+ds+6ye2xeUu/R
	t2UVo8fnTXIBrFFcNimpOZllqUX6dglcGW+a5jIV/BWqODrrE1MD41z+LkZODgkBE4lnW9ay
	QNhiEhfurWfrYuTiEBJYyigx4XILaxcjB1jR4zZhiPgiRoknjZ2MEM5rRolJC5ayg3TzCmhJ
	/L40nwnEZhFQlehofgkWZwOK739xgw3EFhUIk1g5/QoLRL2gxI/J98BsEQF1iW9T+tlBhjIL
	PGWU2NQykREkISxgK9F1rAGsSEggRaL//CewOKeApkT3sSVgQ5kFdCT2t06DsuUlNq95ywwy
	SELgFrvEjZ/fWCAuEpD4NvkQC8Q7shKbDjBDvCwpcXDFDZYJjGKzkNw0C8nYWUjGLmBkXsUo
	mlqQXFCclF5kqFecmFtcmpeul5yfu4kRGImn/z3r3cF4+4D1IcZkoJUTmaVEk/OBkZxXEm9o
	bGZkYWpiamxkbmlGmrCSOG/Sw6QgIYH0xJLU7NTUgtSi+KLSnNTiQ4xMHJxSDYyZ6R61q5me
	xq3yqniklKp85HRWfGIs139FDt7AK6t26Io+XKCTIcEy7+GJ29mTkjV/Z09tUj7cNm3GleOa
	J9SCO6XWvJrwa/Nz33tx4UwypZmT3BfN/azqzf84lWPSPz8JB5MJYp5XbIqa9h4+n/vz7tlO
	4yueNjMmB1jfDi47azm7ZnPDvClKLMUZiYZazEXFiQBex3BZ2gIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrGIsWRmVeSWpSXmKPExsVy+t9jAd2wwm3BBl9n81js+nuf0aJ3wVU2
	i7NNb9gtNj2+xmpxedccNosZ5/cxWdy+zGuxfsZrFotVu/4wOnB6tDT3sHnsnHWX3WPzknqP
	vi2rGD0+b5ILYI1qYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneONzUzMNQ1tLQwV1LIS8xNtVVy
	8QnQdcvMAbpHSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5vSBBcj5EBGkhYw5jxpmkuU8Ff
	oYqjsz4xNTDO5e9i5OCQEDCReNwm3MXICWSKSVy4t56ti5GLQ0hgEaPEk8ZORgjnNaPEpAVL
	2UGqeAW0JH5fms8EYrMIqEp0NL8Ei7MBxfe/uMEGYosKhEmsnH6FBaJeUOLH5HtgtoiAusS3
	Kf3sIEOZBZ4ySmxqmcgIkhAWsJXoOtYAViQkkCLRf/4TWJxTQFOi+9gSsKHMAjoS+1unQdny
	EpvXvGWewCgwC8mOWUjKZiEpW8DIvIpRNLUguaA4KT3XSK84Mbe4NC9dLzk/dxMjOM6fSe9g
	XNVgcYhRgINRiYfXo2hrsBBrYllxZe4hRgkOZiUR3uSUbcFCvCmJlVWpRfnxRaU5qcWHGE2B
	QTCRWUo0OR+YgvJK4g2NTcyMLI3MDS2MjM2VxHkPtloHCgmkJ5akZqemFqQWwfQxcXBKNTCq
	m54+sPeEwKGInZnf2c2FlrAu81pufeTEL8G+xsDSovunXdlLbj2y6Ddtl/2d0fNu+1y7145Z
	ItUbXbR7inns5k8zLAm7uuBf/p3YpacUVhZNvPO/bX9M73r7/+WbN0VIpv3mWcCotWd6YskS
	trBeXuWU3sLG31dV/rW1Mj82dWCZ0cpz744SS3FGoqEWc1FxIgDicitVCQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Kukjin and Tomasz,

On 07/04/2014 05:05 PM, Tomasz Figa wrote:
> Hi Chanwoo,
> 
> On 03.07.2014 09:52, Chanwoo Choi wrote:
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
> 
> Shouldn't the label be rather called "i2s2" as the pinctrl entry below
> suggests?
> 
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
> "pinctrl-name" is not a valid property. I suppose it should be
> "pinctrl-names".

I modify this patch as following. If you confirm following patch, I'll re-send patchset(v2).

diff --git a/arch/arm/boot/dts/exynos3250.dtsi b/arch/arm/boot/dts/exynos3250.dtsi
index 3e678fa..77a06df 100644
--- a/arch/arm/boot/dts/exynos3250.dtsi
+++ b/arch/arm/boot/dts/exynos3250.dtsi
@@ -425,6 +425,19 @@
 			status = "disabled";
 		};
 
+		i2s2: i2s@13970000 {
+			compatible = "samsung,s3c6410-i2s";
+			reg = <0x13970000 0x100>;
+			interrupts = <0 126 0>;
+			clocks = <&cmu CLK_I2S>, <&cmu CLK_SCLK_I2S>;
+			clock-names = "iis", "i2s_opclk0";
+			dmas = <&pdma0 14>, <&pdma0 13>;
+			dma-names = "tx", "rx";
+			pinctrl-0 = <&i2s2_bus>;
+			pinctrl-names = "default";
+			status = "disabled";
+		};
+
 		pwm: pwm@139D0000 {
 			compatible = "samsung,exynos4210-pwm";
 			reg = <0x139D0000 0x1000>;
-- 
1.8.0


Best Regards,
Chanwoo Choi


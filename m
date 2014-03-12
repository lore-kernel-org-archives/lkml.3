Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754924AbaCLD1k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 23:27:40 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:11776 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754433AbaCLD1i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 23:27:38 -0400
X-AuditID: cbfee691-b7efc6d0000039d3-9e-531fd429780f
Message-id: <531FD428.4000008@samsung.com>
Date: Wed, 12 Mar 2014 12:27:36 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Tomasz Figa <t.figa@samsung.com>
Cc: kgene.kim@samsung.com, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, kyungmin.park@samsung.com,
        rob.herring@calxeda.com, pawel.moll@arm.com, mark.rutland@arm.com,
        swarren@wwwdotorg.org, ijc+devicetree@hellion.org.uk,
        linux@arm.linux.org.uk
Subject: Re: [PATCH 3/5] ARM: dts: exynos4x12: Add GPS_ALIVE power domain
References: <1394524494-30641-1-git-send-email-cw00.choi@samsung.com>
 <1394524494-30641-4-git-send-email-cw00.choi@samsung.com>
 <531F0154.9040409@samsung.com>
In-reply-to: <531F0154.9040409@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrJIsWRmVeSWpSXmKPExsWyRsSkUFfzinywwdUuDov5R86xWpx7tZLR
	onfBVTaLs01v2C02Pb7GanF51xw2ixnn9zFZ3L7Ma7H0+kUmiwnT17JYHF5xgMni1cE2Fov1
	M16zOPB6rJm3htGjpbmHzWPB5yvsHiuXf2Hz2Lyk3qNvyypGj8+b5Dw2zg0N4IjisklJzcks
	Sy3St0vgytg6V7ZgA0/FynPf2BsYf3J2MXJySAiYSExpaWCDsMUkLtxbD2RzcQgJLGWU+L12
	ATtM0eq1X5kgEosYJWbcmwtV9YpR4nTLTyaQKl4BLYmj5xuYQWwWAVWJbT/ng41lA4rvf3ED
	zBYVCJNYOf0KC0S9oMSPyffAbBEBFYnLp6YzgtjMAheYJPbsLQKxhQU8Jb7uWMMIt/n569us
	IAlOAW2Jzr8H2SEadCT2t05jg7DlJTavecsM0iAh0MohcerHRTaIiwQkvk0+BLSNAyghK7Hp
	ADPEa5ISB1fcYJnAKDYLyU2zkIydhWTsAkbmVYyiqQXJBcVJ6UWmesWJucWleel6yfm5mxiB
	0Xz637OJOxjvH7A+xJgMtHIis5Rocj4wGeSVxBsamxlZmJqYGhuZW5qRJqwkzpv+KClISCA9
	sSQ1OzW1ILUovqg0J7X4ECMTB6dUA6N7Y3jgxlCB9+ctl/Sl/7fpdDDVFFo4t3jme+GN5fef
	qeRuDT3/uGgbR3DzubdiIvLPT6/8vFPn3loZqa8rS05v1H9du+lZLou68zo++Xtuz9uS+d3W
	3530Ve3Rwd9amzW3iJcc7djc+nCC6OvQ9furLk6ROvWs7Ynj0q+Z0RdWXLh/cHva0ppNSizF
	GYmGWsxFxYkAjn9+wvwCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrGKsWRmVeSWpSXmKPExsVy+t9jAV2NK/LBBnOm2FjMP3KO1eLcq5WM
	Fr0LrrJZnG16w26x6fE1VovLu+awWcw4v4/J4vZlXoul1y8yWUyYvpbF4vCKA0wWrw62sVis
	n/GaxYHXY828NYweLc09bB4LPl9h91i5/Aubx+Yl9R59W1YxenzeJOexcW5oAEdUA6NNRmpi
	SmqRQmpecn5KZl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtDFSgpliTmlQKGA
	xOJiJX07TBNCQ9x0LWAaI3R9Q4LgeowM0EDCGsaMrXNlCzbwVKw89429gfEnZxcjJ4eEgInE
	6rVfmSBsMYkL99azdTFycQgJLGKUmHFvLpTzilHidMtPsCpeAS2Jo+cbmEFsFgFViW0/57OB
	2GxA8f0vboDZogJhEiunX2GBqBeU+DH5HpgtIqAicfnUdEYQm1ngApPEnr1FILawgKfE1x1r
	GOE2P399mxUkwSmgLdH59yA7RIOOxP7WaWwQtrzE5jVvmScwCsxCsmMWkrJZSMoWMDKvYhRN
	LUguKE5KzzXUK07MLS7NS9dLzs/dxAhOFc+kdjCubLA4xCjAwajEw7tAUz5YiDWxrLgy9xCj
	BAezkgjvR5AQb0piZVVqUX58UWlOavEhxmRgEExklhJNzgemsbySeENjEzMjSyNzQwsjY3PS
	hJXEeQ+0WgcKCaQnlqRmp6YWpBbBbGHi4JRqYKxaUGlwPWL78g1anAU7jY5cemim/57z7ckD
	hT58h8zdvvK1czAsPcDwrbXFjKnJfs3im18uyz9yiOrvNfWZmfl0dqDQh6OapbfbDiypbPl3
	ca3rzrd1D0Lnnpx1rGKL9+mLBXsl98yNK5z1b1+n6Zojd9ojS51nRDgFTP+8uuzOXMdbH+5N
	PLJWiaU4I9FQi7moOBEAbdmKzlkDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomasz,

On 03/11/2014 09:28 PM, Tomasz Figa wrote:
> Hi Chanwoo,
> 
> On 11.03.2014 08:54, Chanwoo Choi wrote:
>> This patch add GPS_ALIVE power domain for Exynos4x12 SoC. GPS_ALIVE power domain
>> include GPS_BLK for GPS IP. Exynos SoC used generic power-domain driver to
>> control power domain. After completed kernel booting, Exynos power-domain driver
>> disable un-used power domain to reduce power-consumption/leak.
>>
>> If GPS_ALIVE power domain isn't registered to Exynos power-domain driver,
>> happen power-leakage because GPS_ALIVE_CONFIGURATION is default power on state.
>>
>> - 0x10023D00 : GPS_ALIVE_CONFIGURATION register address
>>
>> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
>> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
>> ---
>>   arch/arm/boot/dts/exynos4x12.dtsi | 5 +++++
>>   1 file changed, 5 insertions(+)
>>
>> diff --git a/arch/arm/boot/dts/exynos4x12.dtsi b/arch/arm/boot/dts/exynos4x12.dtsi
>> index 1ec77f6..066eb35 100644
>> --- a/arch/arm/boot/dts/exynos4x12.dtsi
>> +++ b/arch/arm/boot/dts/exynos4x12.dtsi
>> @@ -41,6 +41,11 @@
>>           compatible = "samsung,exynos4210-pd";
>>           reg = <0x10023CA0 0x20>;
>>       };
>> +   
>> +    pd_gps_alive: gps-alive-power-domain@10023D00 {
>> +        compatible = "samsung,exynos4210-pd";
>> +        reg = <0x10023D00 0x20>;
>> +    };
>>
> 
> Exynos4210 seems to have this power domain as well, so I guess this change should be done to exynos4.dtsi instead.
> 

You are right. I will modify it.

Thanks,
Chanwoo Choi


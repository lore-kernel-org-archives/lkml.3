Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752066AbaBNKy5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 05:54:57 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:43788 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751851AbaBNKyz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 05:54:55 -0500
X-AuditID: cbfec7f5-b7fc96d000004885-d5-52fdf5fd3844
Message-id: <52FDF5FA.4000909@samsung.com>
Date: Fri, 14 Feb 2014 11:54:50 +0100
From: Tomasz Figa <t.figa@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.1.1
MIME-version: 1.0
To: Kukjin Kim <kgene.kim@samsung.com>,
        Naveen Krishna Chatradhi <ch.naveen@samsung.com>
Cc: linux-crypto@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, vzapolskiy@gmail.com,
        herbert@gondor.apana.org.au, naveenkrishna.ch@gmail.com,
        cpgs@samsung.com
Subject: Re: [PATCH 6/9 v6] ARM: dts: exynos5250/5420: add dt node for sss
 module
References: <1389095509-14357-6-git-send-email-ch.naveen@samsung.com>
 <1391750695-27447-1-git-send-email-ch.naveen@samsung.com>
 <52FD552E.8040008@samsung.com>
In-reply-to: <52FD552E.8040008@samsung.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrILMWRmVeSWpSXmKPExsVy+t/xK7p/v/4NMpi+Xsbi7vPDjBYvD2la
	dL+SsehdcJXN4v69n0wWl3fNYbOYcX4fk8Wibf+ZLc7OOcTkwOmxc9Zddo9tB1Q9+rasYvT4
	vEkugCWKyyYlNSezLLVI3y6BK+N+RxtbQZtIxb7729kbGM/ydzFycEgImEh83CndxcgJZIpJ
	XLi3nq2LkYtDSGApo8S3We9YIJzPjBJdtx+zglTxCmhJnOo8wwhiswioSpzYsAzMZhNQk/jc
	8IgNxBYViJD4O289I0S9oMSPyfdYQGwRgSiJpj3nmEGGMgscY5S4s2crWEJYIFhi6d13UKsX
	MUps7H4PluAU0JZouv8TbDOzgLXEyknbGCFseYnNa94yT2AUmIVkySwkZbOQlC1gZF7FKJpa
	mlxQnJSea6RXnJhbXJqXrpecn7uJERLsX3cwLj1mdYhRgINRiYf3w90/QUKsiWXFlbmHGCU4
	mJVEeN33/w0S4k1JrKxKLcqPLyrNSS0+xMjEwSnVwKj+XUBua97O7piGhZ521xg9RVcGCSzZ
	rDv3Z20j97vYKQaLpoafM7hjsFAna9uJGPObTcb3Zhk7/LkqExZs2htZ4/B83vpPMY8zo1oE
	Nj7MEN9/ZNck4zdpHm4vXtTZbWJTV0p6kRRQybzA8mftoQvvT9SF7l11eGb04sT4H0/Ush5r
	qG5pMVJiKc5INNRiLipOBADQNqJ2VAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kukjin,

On 14.02.2014 00:28, Kukjin Kim wrote:
> On 02/07/14 14:24, Naveen Krishna Chatradhi wrote:
>> This patch adds the device tree node for SSS module
>> found on Exynos5420 and Exynos5250
>>
>> Signed-off-by: Naveen Krishna Chatradhi<ch.naveen@samsung.com>
>> Reviewed-by: Tomasz Figa<t.figa@samsung.com>
>> TO:<linux-samsung-soc@vger.kernel.org>
>> CC: Kukjin Kim<kgene.kim@samsung.com>
>> CC:<linux-crypto@vger.kernel.org>
>> ---
>> changes since v5:
>> 1. Added Reviewed-by: Tomasz Figa<t.figa@samsung.com>
>>
>>   arch/arm/boot/dts/exynos5250.dtsi |    8 ++++++++
>>   arch/arm/boot/dts/exynos5420.dtsi |   10 ++++++++++
>>   2 files changed, 18 insertions(+)
>>
>> diff --git a/arch/arm/boot/dts/exynos5250.dtsi
>> b/arch/arm/boot/dts/exynos5250.dtsi
>> index b7dec41..46b04e8 100644
>> --- a/arch/arm/boot/dts/exynos5250.dtsi
>> +++ b/arch/arm/boot/dts/exynos5250.dtsi
>> @@ -706,4 +706,12 @@
>>           io-channel-ranges;
>>           status = "disabled";
>>       };
>> +
>> +    sss@10830000 {
>> +        compatible = "samsung,exynos4210-secss";
>> +        reg =<0x10830000 0x10000>;
>> +        interrupts =<0 112 0>;
>> +        clocks =<&clock 348>;
>> +        clock-names = "secss";
>> +    };
>>   };
>> diff --git a/arch/arm/boot/dts/exynos5420.dtsi
>> b/arch/arm/boot/dts/exynos5420.dtsi
>> index 8db792b..b503e96 100644
>> --- a/arch/arm/boot/dts/exynos5420.dtsi
>> +++ b/arch/arm/boot/dts/exynos5420.dtsi
>> @@ -652,4 +652,14 @@
>>           clocks =<&clock 319>,<&clock 318>;
>>           clock-names = "tmu_apbif", "tmu_triminfo_apbif";
>>       };
>> +
>> +    sss@10830000 {
>> +        compatible = "samsung,exynos4210-secss";
>> +        reg =<0x10830000 0x10000>;
>> +        interrupts =<0 112 0>;
>> +        clocks =<&clock 471>;
>> +        clock-names = "secss";
>> +        samsung,power-domain =<&g2d_pd>;
>> +    };
>> +
>>   };
>
> Applied, thanks.
>
> BTW, I think the numbering is strange...maybe I missed something?
> [PATCH 5/5], [PATCH 5/6 V2], [PATCH 6/8 V3] and this [PATCH 6/9 V6]

I would wait with applying any patches from this series until they are 
acked by crypto subsystem maintainer and DT bindings by DT maintainers.

I'd like Naveen to resend this series in separate thread, with proper 
message threading, so we can make sure that we are not missing anything. 
Naveen, please also add

David S. Miller <davem@davemloft.net>

to Cc list, as he is also listed as crypto maintainer in MAINTAINERS file.

Best regards,
Tomasz

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754502AbaB0BcP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 20:32:15 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:32458 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754452AbaB0BcN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 20:32:13 -0500
X-AuditID: cbfee691-b7efc6d0000039d3-11-530e959b9007
Message-id: <530E996A.9080208@samsung.com>
Date: Thu, 27 Feb 2014 10:48:26 +0900
From: Pankaj Dubey <pankaj.dubey@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130308
 Thunderbird/17.0.4
MIME-version: 1.0
To: Mike Turquette <mturquette@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>, Ben Dooks <ben-linux@fluff.org>
Subject: Re: [PATCH 3/3] ARM: S3C24XX: select COMMON_CLK_SAMSUNG for S3C24XX
References: <1393392247-6247-1-git-send-email-pankaj.dubey@samsung.com>
 <1393392247-6247-4-git-send-email-pankaj.dubey@samsung.com>
 <20140227001620.12081.28601@quantum>
In-reply-to: <20140227001620.12081.28601@quantum>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrAIsWRmVeSWpSXmKPExsVy+t8zI93ZU/mCDfa8lrOYtO4Ak0Xvgqts
	FpseX2O1uLxrDpvFjPP7mCxuX+a1eDrhIpsDu0dLcw+bx99VL5g97lzbw+axeUm9R9+WVYwe
	nzfJBbBFcdmkpOZklqUW6dslcGV8v9rDWDCVv+L51n6WBsbL3F2MnBwSAiYSMz/MYISwxSQu
	3FvP1sXIxSEksIxRYvXm+cxdjBxgRRt310LEFzFKbJtwhR3Cec0ocW7NWnaQbl4BLYkNXY0s
	IDaLgKrErB0bmUBsNgFdiSfv5zKD2KICYRKbpvexQtQLSvyYfA+sXgSod9uBVrDNzAI3GSWO
	H1zOBLJZWMBHoq/XAqRGSGANo8T7F6wgYU4BQ4nnl9JAwswCZhKPWtYxQ9jyEpvXvGUGGSMh
	cI1dYu2l24wQ9whIfJt8iAXiGVmJTQeYIR6WlDi44gbLBEaxWUgumoVk7CwkYxcwMq9iFE0t
	SC4oTkovMtUrTswtLs1L10vOz93ECIm9iTsY7x+wPsSYDLRyIrOUaHI+MHbzSuINjc2MLExN
	TI2NzC3NSBNWEudNf5QUJCSQnliSmp2aWpBaFF9UmpNafIiRiYNTqoHx7JQXGRr1gVxv3LIi
	Hy00FNyxk6lX7s/KRW2Cm7Knr369K9riyYzZN8Lle+7PUfxll3kzb9nXn1aNLxIkricybFmQ
	cTdDW57321bm1g3OqyQW+lyOmckdqOvnbKUqwiXI13Jkjk7Q7FqJvSvn+Bj0bX0ou/3VynXL
	zj1fJpwxeaNEVvXiE9zflViKMxINtZiLihMBt3Ff69MCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprLKsWRmVeSWpSXmKPExsVy+t9jAd3ZU/mCDS7dl7KYtO4Ak0Xvgqts
	FpseX2O1uLxrDpvFjPP7mCxuX+a1eDrhIpsDu0dLcw+bx99VL5g97lzbw+axeUm9R9+WVYwe
	nzfJBbBFNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE6Lpl
	5gCdoqRQlphTChQKSCwuVtK3wzQhNMRN1wKmMULXNyQIrsfIAA0krGPM+H61h7FgKn/F8639
	LA2Ml7m7GDk4JARMJDburu1i5AQyxSQu3FvP1sXIxSEksIhRYtuEK+wQzmtGiXNr1rKDVPEK
	aEls6GpkAbFZBFQlZu3YyARiswnoSjx5P5cZxBYVCJPYNL2PFaJeUOLH5Htg9SJAvdsOtIJt
	YBa4yShx/OByJpArhAV8JPp6LUBqhATWMEq8f8EKEuYUMJR4fikNJMwsYCbxqGUdM4QtL7F5
	zVvmCYwCs5BsmIWkbBaSsgWMzKsYRVMLkguKk9JzDfWKE3OLS/PS9ZLzczcxgiP7mdQOxpUN
	FocYBTgYlXh4Fdj4goVYE8uKK3MPMUpwMCuJ8B5yAQrxpiRWVqUW5ccXleakFh9iTAYGwERm
	KdHkfGDSySuJNzQ2MTOyNDKzMDIxNydNWEmc90CrdaCQQHpiSWp2ampBahHMFiYOTqkGxorc
	wstrMwIT2HgPVbmrxHwsD37/39Phd3a4ZJIH3/cSf5UaJ4fHy9YlCe728rnLW3qnS+sr6+uy
	z8cvHuMOX2Gw2DfWNKXpx5b8mwpZXqWSDo9u1vGVmEuqPohY/GGRXNCkq1uddayVz6b+faXF
	++Vu82auNaWKDRr5zk8Pr9r72lxKuEpJiaU4I9FQi7moOBEA3jNhBjADAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/27/2014 09:16 AM, Mike Turquette wrote:
> Quoting Pankaj Dubey (2014-02-25 21:24:07)
>> CC: Ben Dooks <ben-linux@fluff.org>
>> CC: Kukjin Kim <kgene.kim@samsung.com>
>> CC: Russell King <linux@arm.linux.org.uk>
>> Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
>> ---
>>   arch/arm/mach-s3c24xx/Kconfig |    3 +++
>>   1 file changed, 3 insertions(+)
>>
>> diff --git a/arch/arm/mach-s3c24xx/Kconfig b/arch/arm/mach-s3c24xx/Kconfig
>> index 80373da..5cf82a1 100644
>> --- a/arch/arm/mach-s3c24xx/Kconfig
>> +++ b/arch/arm/mach-s3c24xx/Kconfig
>> @@ -40,6 +40,7 @@ config CPU_S3C2410
>>   config CPU_S3C2412
>>          bool "SAMSUNG S3C2412"
>>          select COMMON_CLK
>> +       select COMMON_CLK_SAMSUNG
> I guess this depends on Heiko's "[PATCH 00/12] ARM: S3C24XX: convert
> s3c2410, s3c2440 s3c2442 to common clock framework" series?
>
> Regards,
> Mike

Yes, this series is based on latest kgene/for-next branch where Heiko's 
series is merged.

>>          select CPU_ARM926T
>>          select CPU_LLSERIAL_S3C2440
>>          select S3C2412_COMMON_CLK
>> @@ -51,6 +52,7 @@ config CPU_S3C2412
>>   config CPU_S3C2416
>>          bool "SAMSUNG S3C2416/S3C2450"
>>          select COMMON_CLK
>> +       select COMMON_CLK_SAMSUNG
>>          select CPU_ARM926T
>>          select CPU_LLSERIAL_S3C2440
>>          select S3C2416_PM if PM
>> @@ -89,6 +91,7 @@ config CPU_S3C244X
>>   config CPU_S3C2443
>>          bool "SAMSUNG S3C2443"
>>          select COMMON_CLK
>> +       select COMMON_CLK_SAMSUNG
>>          select CPU_ARM920T
>>          select CPU_LLSERIAL_S3C2440
>>          select S3C2443_COMMON_CLK
>> -- 
>> 1.7.9.5
>>
>>
>> _______________________________________________
>> linux-arm-kernel mailing list
>> linux-arm-kernel@lists.infradead.org
>> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel


-- 
Best Regards,
Pankaj Dubey


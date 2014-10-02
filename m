Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753314AbaJBCgN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 22:36:13 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:42558 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752659AbaJBCgK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 22:36:10 -0400
X-AuditID: cbfee68e-f79b46d000002b74-1c-542cba1708f6
From: Kukjin Kim <kgene@kernel.org>
To: "'Stephen Rothwell'" <sfr@canb.auug.org.au>,
        "'Olof Johansson'" <olof@lixom.net>, "'Arnd Bergmann'" <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org, mturquette@linaro.org
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "'Javier Martinez Canillas'" <javier.martinez@collabora.co.uk>
References: <20141002113742.2b521495@canb.auug.org.au>
In-reply-to: <20141002113742.2b521495@canb.auug.org.au>
Subject: RE: linux-next: build failure after merge of the arm-soc tree
Date: Thu, 02 Oct 2014 11:36:05 +0900
Message-id: <019c01cfdde9$9eb22ff0$dc168fd0$@kernel.org>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQMZ032i/hgGbfuk3GcF9lVBjIX9/ZmIKO6Q
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrHIsWRmVeSWpSXmKPExsVy+t8zfV3xXTohBvMaLCz+TjrGbnH0d4HF
	psfXWC0u75rDZnFwYRujxdMJF9ksTl3/zGaxde9VdgcOj9+/JjF6NN64webx9/l1Fo871/aw
	eWxeUu9x5UQTq8fnTXIB7FFcNimpOZllqUX6dglcGV9XTmYvOMlf8WbmEcYGxnfcXYycHBIC
	JhIzpzSzQNhiEhfurWfrYuTiEBJYxiixdv5UZpiiiz3LmCESixgl+r/8YQVJCAn8ZZR4eMem
	i5GDg01AWaKxSR8kLCygJbFwSxMLSL2IwCZGie/3PoINYhaokTi++QsjRK+ZxJMJh8HinALm
	ElfnrWIHmSMs4CbxpD0OJMwioCrxcm4TO4jNK2AhsePIETYIW1Dix+R7LBAjtSTW7zzOBGHL
	S2xe8xbqZgWJHWdfM4KMFBEwkrh+JBaiRERi34t3jCCnSQh0ckg8mzSRDWKXgMS3yYdYQOol
	BGQlNh2AGiMpcXDFDZYJjJKzkGyehWTzLCSbZyFZsYCRZRWjaGpBckFxUnqRkV5xYm5xaV66
	XnJ+7iZGSLT37WC8ecD6EKMAB6MSD29Gg06IEGtiWXFl7iFGU6CLJjJLiSbnA1NKXkm8obGZ
	kYWpiamxkbmlmZI4b4LUz2AhgfTEktTs1NSC1KL4otKc1OJDjEwcnFINjOu8I5ZKz3gze9+3
	VelHzcQ+nv51QiGdQfqO6ebWI0kTv8xmeGcdcdlqk2Jq6MQuqUNxk9tydzypftwTX/r7+Nqy
	H7dqmftzl97mPfZHb1m03rMVc9tMlXwuHhDkO1L0dEL4yxtzw+V3LG9r+nUhIvubudNDfg32
	ScpGokpJn7VsGfTjplivuaPEUpyRaKjFXFScCAASxnaV8QIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrBKsWRmVeSWpSXmKPExsVy+t9jAV3xXTohBi+OGFv8nXSM3eLo7wKL
	TY+vsVpc3jWHzeLgwjZGi6cTLrJZnLr+mc1i696r7A4cHr9/TWL0aLxxg83j7/PrLB53ru1h
	89i8pN7jyokmVo/Pm+QC2KMaGG0yUhNTUosUUvOS81My89JtlbyD453jTc0MDHUNLS3MlRTy
	EnNTbZVcfAJ03TJzgI5SUihLzCkFCgUkFhcr6dthmhAa4qZrAdMYoesbEgTXY2SABhLWMWZ8
	XTmZveAkf8WbmUcYGxjfcXcxcnJICJhIXOxZxgxhi0lcuLeerYuRi0NIYBGjRP+XP6wgCSGB
	v4wSD+/YdDFycLAJKEs0NumDhIUFtCQWbmliAakXEdjEKPH93kewQcwCNRLHN39hhOg1k3gy
	4TBYnFPAXOLqvFXsIHOEBdwknrTHgYRZBFQlXs5tYgexeQUsJHYcOcIGYQtK/Jh8jwVipJbE
	+p3HmSBseYnNa95C3awgsePsa0aQkSICRhLXj8RClIhI7HvxjnECo/AsJJNmIZk0C8mkWUha
	FjCyrGIUTS1ILihOSs810itOzC0uzUvXS87P3cQITiXPpHcwrmqwOMQowMGoxMOb0aATIsSa
	WFZcmXuIUYKDWUmEd9VkoBBvSmJlVWpRfnxRaU5q8SFGU6BHJzJLiSbnA9NcXkm8obGJmZGl
	kZmFkYm5uZI478FW60AhgfTEktTs1NSC1CKYPiYOTqkGxlkmd4N23HB6V3DU4vLnq817/hYt
	uH9gtaepzMWfahrdCo47250tArYIWN6ddXdZQ7p/RUp3Z80555S4/V8Vcq1dw8521QWbhsfl
	SR+Kvailz+q7/f3nQ32T/nrM52gKFl3YJNHLOsWovu59+fu/ToGH8vTP976duDX465OkKtGF
	kzevZH2SqMRSnJFoqMVcVJwIALycmk87AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+ Mike

Stephen Rothwell wrote:
> 
> Hi all,
> 
Hi,

> After merging the arm-soc tree, today's linux-next build (arm
> multi_v7_defconfig) failed like this:
> 
> arch/arm/boot/dts/exynos5250-snow.dts:13:46: fatal error: dt-bindings/clock/maxim,max77686.h: No such
> file or directory
>  #include <dt-bindings/clock/maxim,max77686.h>
>                                               ^
> 
> Caused by commit c04c92ed5614 ("ARM: dts: Add rtc_src clk for s3c-rtc
> on exynos5250-snow").
> 
> Presumably there is some dependency on some tree that someone has
> forgotten to merge :-(
> 
Hmm...I thought it should be fine once Mike's clk tree is landing into the
-next tree. Firstly sorry about that and how should I do in this case?

> I reverted that commit for today.
> 
> Which then got to:
> 
> /scratch/sfr/next/arch/arm/boot/dts/exynos5420-peach-pit.dts:15:46: fatal error: dt-
> bindings/clock/maxim,max77802.h: No such file or directory
>  #include <dt-bindings/clock/maxim,max77802.h>
>                                               ^
> compilation terminated.
> /scratch/sfr/next/arch/arm/boot/dts/exynos5800-peach-pi.dts:15:46: fatal error: dt-
> bindings/clock/maxim,max77802.h: No such file or directory
>  #include <dt-bindings/clock/maxim,max77802.h>
>                                               ^
> compilation terminated.
> Error: /scratch/sfr/next/arch/arm/boot/dts/hisi-x5hd2.dtsi:417.21-22 syntax error
> FATAL ERROR: Unable to parse input tree
> 
> Caused by 8bd43b6e6df7 ("ARM: dts: Add rtc_src clk for s3c-rtc on
> exynos Peach boards").
> 
> I give up ... please test your trees better ...
> 
So sorry, actually it's my fault, I missed the information to arm-soc when I
sent a pull-request, just I thought arm-soc were aware of that before happening
the error when samsung tree merged...

- Kukjin

> I have used the arm-soc tree form next-20141001 for today (which still
> needs 5 reverts to get it to build :-().


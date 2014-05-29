Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934184AbaE2OrK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 10:47:10 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:24947 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932782AbaE2OrH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 10:47:07 -0400
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-15; format=flowed
X-AuditID: cbfec7f5-b7f626d000004b39-2a-538748676016
Content-transfer-encoding: 8BIT
Message-id: <53874862.5080809@samsung.com>
Date: Thu, 29 May 2014 18:46:58 +0400
From: Tarek Dakhran <t.dakhran@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.5.0
To: =?ISO-8859-15?Q?Andreas_F=E4rber?= <afaerber@suse.de>,
        Kevin Hilman <khilman@linaro.org>
Cc: linux-kernel@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>, Ben Dooks <ben-linux@fluff.org>,
        Tomasz Figa <t.figa@samsung.com>,
        Mike Turquette <mturquette@linaro.org>,
        Vyacheslav Tyrtov <v.tyrtov@samsung.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Romain Naour <romain.naour@openwide.fr>,
        Chander Kashyap <chander.kashyap@linaro.org>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, Tarek Dakhran <t.dakhran@gmail.com>
Subject: Re: [PATCH v11 0/3] Exynos 5410 support
References: <1401074613-29227-1-git-send-email-t.dakhran@samsung.com>
 <7hr43f9mmn.fsf@paris.lan> <538737CA.4070709@suse.de>
In-reply-to: <538737CA.4070709@suse.de>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrPIsWRmVeSWpSXmKPExsVy+t/xK7rpHu3BBus6tCyaNxVbTFp3gMni
	4fqbLBbzj5xjteh/s5DV4v+j16wW516tZLToXXCVzeLr4RWMFmeb3rBbbHp8jdViYdsSFovL
	u+awWcw4v4/J4vZlXoul1y8yWTydcJHNYsL0tSwW615OZ7Fo3XuE3WLLzw5Gi989n5gt1s94
	zWJxbMYSRoupM36wO0h6rJm3htGjpbmHzeNyXy+Tx99VL5g9ds66y+6xcvkXNo9NqzrZPF6t
	nsnqcefaHjaPzUvqPV5dY/Ho27KK0WP7tXnMHptPV3t83iQXwB/FZZOSmpNZllqkb5fAlXG0
	tY+p4D9nxb/l0xkbGFs4uhg5OSQETCRe7jrHDmGLSVy4t56ti5GLQ0hgKaPE/s7HzCAJXgFB
	iR+T77F0MXJwMAvISxy5lA1h2kgcnJ8GUiEk8IFR4sl1S4hqLYnu9q1gI1kEVCW2flnMDFLO
	JqAtsWWHF4gpKhAh8fiCEEiFiECcRPvGBawgS5kFnrNJHHh8D6xVWMBA4saszYwQ42slls6+
	wgpicwqoS3R0X2KawCgwC8ltsxBum4Vw2wJG5lWMoqmlyQXFSem5RnrFibnFpXnpesn5uZsY
	IZH+dQfj0mNWhxgFOBiVeHgzXNqDhVgTy4orcw8xSnAwK4nw6pkAhXhTEiurUovy44tKc1KL
	DzEycXBKNTCaJRXXv3p6+8jpiJkHgo8d0/AM10/vT/VX10o91nq731Xi6XH9iTLpYU/m5QnU
	7S/Tibmwwi67dKLj2XkzuS4ZeBy4s31mzZ7mSp4nq3ycRe6E5sQx+KtyiZbwPy2s3cHLVd1X
	OzX1zuc52izF+5XN331J4TIubDAP3XRf8730nhlM0rnXrZVYijMSDbWYi4oTAQaiX0jSAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andreas,

On 05/29/2014 05:36 PM, Andreas Färber wrote:
> Hi Tarek and Kevin,
>
> Am 27.05.2014 19:06, schrieb Kevin Hilman:
>> Tarek Dakhran <t.dakhran@samsung.com> writes:
>>
>>> The series of patches represent support of Exynos 5410 SoC
>>>
>>> The Exynos 5410 is the first Samsung SoC based on big.LITTLE architecture
>>>
>>> Patches add new platform description, support of clock controller and device
>>> tree for Exynos 5410.
>>>
>>> Has been build on Samsung Linux Kernel
>>>    (branch: for-next, commit: 97eae6c Merge branch 'v3.16-next/multiplatform' into for-next)
>>>
>>> Has been tested on: 1) Exynos 5410 reference board (exynos_defconfig)
>>> 		    2) Exynos 5410 reference board (multi_v7_defconfig)
>>> 		    3) Odroid-XU board (exynos_defconfig)
>>> 		    4) Odroid-XU board (multi_v7_defconfig)
>> Tested-by: Kevin Hilman <khilman@linaro.org>
>>
>> FYI, I boot tested this on an odroid-xu (exynos_defconfig and
>> multi_v7_defconfig.)
> Could you clarify: Are you using exynos5410-smdk5410.dts with the
> ODROID-XU or do you have some upcoming exynos5410-odroidxu.dts based on
> exynos5410.dtsi?
We use exynos5410-smdk5410.dts for booting ODROID-XU.

>
> Thanks,
> Andreas
>


-- 
Best regards,
     Tarek Dakhran


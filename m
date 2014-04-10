Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965101AbaDJHZ3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 03:25:29 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:61622 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933287AbaDJHZ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 03:25:27 -0400
X-AuditID: cbfee68e-b7f566d000002344-1f-53464765248b
Message-id: <53464B7E.8080507@samsung.com>
Date: Thu, 10 Apr 2014 16:42:54 +0900
From: Pankaj Dubey <pankaj.dubey@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130308
 Thunderbird/17.0.4
MIME-version: 1.0
To: Pankaj Dubey <pankaj.dubey@samsung.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org
Subject: Re: [PATCH v3 0/4] Introduce new Kconfig for Samsung common clock
References: <1394598781-3848-1-git-send-email-pankaj.dubey@samsung.com>
 <1395291325-4043-1-git-send-email-pankaj.dubey@samsung.com>
In-reply-to: <1395291325-4043-1-git-send-email-pankaj.dubey@samsung.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrKIsWRmVeSWpSXmKPExsVy+t8zY91Ud7dgg92LDS02Pb7GanF51xw2
	ixnn9zFZLNr6hd2BxWPzknqPvi2rGD0+b5ILYI7isklJzcksSy3St0vgytj0aiVjwSK+igfd
	+1gaGDu4uxg5OSQETCQOvj7GCGGLSVy4t56ti5GLQ0hgGaPEm/n9LDBF3z7cZ4VILGKUmP6t
	A8p5zShxqPE5M0gVr4CWxNK/nWAdLAKqEre2nwYbyyagK/Hk/VywGlGBMIlN0/tYIeoFJX5M
	vgdWLyKgLdF5+R5YnFkgW+LIly3sXYwcHMICXhLnPllD7GpllFj2YTnYHE4BD4k78++zQNRb
	S6yctI0RwpaX2LzmLTNIg4TAKnaJ7ttT2SAOEpD4NvkQC8hQCQFZiU0HmCE+k5Q4uOIGywRG
	sVlITpqFZOwsJGMXMDKvYhRNLUguKE5KLzLSK07MLS7NS9dLzs/dxAiJor4djDcPWB9iTAZa
	OZFZSjQ5HxiFeSXxhsZmRhamJqbGRuaWZqQJK4nzLnqYFCQkkJ5YkpqdmlqQWhRfVJqTWnyI
	kYmDU6qBkTPtyG1p8ztzDJoy0lmlLp2xqZPeNJ+NRSPNfGqSr8vZYzNqFv5wmXf/oJ1W1eUw
	D7uiFw2rVW1jY2U3V7a/XRF3eNKDoE/2/cqihgff9USdez/ZvYqlp31D92ql1LlqlV3xB+9/
	/bHlQ8IZBRu+q+ESn6U+L7Hvf9jinvS7ZsXZWztPfDvnqcRSnJFoqMVcVJwIAAzmQ8C4AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpileLIzCtJLcpLzFFi42I5/e+xgG6qu1uwwerFuhabHl9jtbi8aw6b
	xYzz+5gsFm39wu7A4rF5Sb1H35ZVjB6fN8kFMEc1MNpkpCampBYppOYl56dk5qXbKnkHxzvH
	m5oZGOoaWlqYKynkJeam2iq5+AToumXmAG1TUihLzCkFCgUkFhcr6dthmhAa4qZrAdMYoesb
	EgTXY2SABhLWMWZserWSsWARX8WD7n0sDYwd3F2MnBwSAiYS3z7cZ4WwxSQu3FvP1sXIxSEk
	sIhRYvq3DlYI5zWjxKHG58wgVbwCWhJL/3aygNgsAqoSt7afZgSx2QR0JZ68nwtWIyoQJrFp
	eh8rRL2gxI/J98DqRQS0JTov3wOLMwtkSxz5soW9i5GDQ1jAS+LcJ2uIXa2MEss+LAebwyng
	IXFn/n0WiHpriZWTtjFC2PISm9e8ZZ7AKDALyYpZSMpmISlbwMi8ilE0tSC5oDgpPddIrzgx
	t7g0L10vOT93EyM4Rp9J72Bc1WBxiFGAg1GJh/fAMtdgIdbEsuLK3EOMEhzMSiK8CkJuwUK8
	KYmVValF+fFFpTmpxYcYk4EhMJFZSjQ5H5g+8kriDY1NzIwsjcwsjEzMzUkTVhLnPdhqHSgk
	kJ5YkpqdmlqQWgSzhYmDU6qB0T4vfNexNR8d/2iGe1myPrMJC+KsaNoda2Lx/ceKiMy+nVEZ
	D31PMr69+ajiZMeMZV29P9RYRESLitzfKTnMqbcMytDwlE3KNWW5tWnNgp+dE3vXd2ieNYvw
	kmVZfDN46yHfNSsmTXSZn75/wZJ6ic7WHYrXVC4tmfpMi+83V5OzSq6lR8NUJZbijERDLeai
	4kQAw8mpJxUDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/20/2014 01:55 PM, Pankaj Dubey wrote:
> Introduce a new Kconfig file for Samsung common clock infrastructure
> related config options. As current Samsung common clock gets compiled
> based on PLAT_SAMSUNG, but moving ahead with ARM64 we can not have any
> more such config options, so this patch introduce new COMMON_CLK_SAMSUNG
> invisible option. This option also select COMMON_CLK so ARCH Kconfig just
> need to select COMMON_CLK_SAMSUNG in case they want to use Samsung common
> clock.
>
> This series is based on Kukjin's for-next branch.
>
> V3:
>   1) Re-organized patches for preventing bisect issues.
>   2) Rebase on top of latest Kukjin's for-next branch.
>   3) Compile tested exynos_defconfig, s3c6400_defconfig and s3c2410_defconfig
>      after each commit.
>
> V2:
>   1) Adding new Kconfig file for Samsung common clock.
>   2) Make COMMON_CLK_SAMSUNG option invisible. (as suggested by Tomasz Figa)
>   3) Let COMMON_CLK_SAMSUNG select COMMON_CLK. (as suggested by Tomasz Figa)
>   4) Move S3C24XX clock config option in new Kconfig file.
>
> Pankaj Dubey (4):
>    clk: samsung: add new Kconfig for Samsung common clock option
>    ARM: select COMMON_CLK_SAMSUNG for ARCH_EXYNOS and ARCH_S3C64XX
>    ARM: S3C24XX: move S3C24XX clock Kconfig options to Samsung clock
>      Kconfig file
>    drivers: clk: use COMMON_CLK_SAMSUNG for Samsung clock support
>
>   arch/arm/Kconfig              |    4 ++--
>   arch/arm/mach-s3c24xx/Kconfig |   14 --------------
>   drivers/clk/Kconfig           |    2 ++
>   drivers/clk/Makefile          |    2 +-
>   drivers/clk/samsung/Kconfig   |   12 ++++++++++++
>   5 files changed, 17 insertions(+), 17 deletions(-)
>   create mode 100644 drivers/clk/samsung/Kconfig
>

Gentle Ping.

-- 
Best Regards,
Pankaj Dubey


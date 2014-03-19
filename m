Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933610AbaCSKWn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 06:22:43 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:32238 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758259AbaCSKWk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 06:22:40 -0400
X-AuditID: cbfee691-b7efc6d0000039d3-d8-53296fee3dd9
Message-id: <532973E0.6060904@samsung.com>
Date: Wed, 19 Mar 2014 19:39:28 +0900
From: Pankaj Dubey <pankaj.dubey@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130308
 Thunderbird/17.0.4
MIME-version: 1.0
To: Pankaj Dubey <pankaj.dubey@samsung.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, Tomasz Figa <t.figa@samsung.com>,
        Mike Turquette <mturquette@linaro.org>
Subject: Re: [PATCH v2 0/4] Introduce new Kconfig for Samsung common clock
References: <1394598781-3848-1-git-send-email-pankaj.dubey@samsung.com>
In-reply-to: <1394598781-3848-1-git-send-email-pankaj.dubey@samsung.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMIsWRmVeSWpSXmKPExsVy+t8zI913+ZrBBu8uKllsenyN1eLyrjls
	FjPO72OyeDrhIpvFoq1f2C3Wz3jN4sDmcefaHjaPzUvqPfq2rGL0+LxJLoAlissmJTUnsyy1
	SN8ugStjy9NDrAXHeCseb4lrYDzD1cXIySEhYCKxe+90dghbTOLCvfVsXYxcHEICyxglpm+9
	wgZTtHXOcxaIxHRGiYYjx9khnNeMEr3b3wJVcXDwCmhJ3F7LA9LAIqAqMbX/OCOIzSagK/Hk
	/VxmEFtUIExi0/Q+VhCbV0BQ4sfkeywgtoiAtkTn5XusIDOZBbYzStx6sYoJJCEs4CXxZcEn
	sAYhAXeJXYd2gp3KKeAhsfPnKbAFzALWEisnbYOy5SU2r3nLDDJIQuAYu0T39XXsEBcJSHyb
	fIgF5FAJAVmJTQeYIT6TlDi44gbLBEaxWUhumoVk7CwkYxcwMq9iFE0tSC4oTkovMtUrTswt
	Ls1L10vOz93ECImwiTsY7x+wPsSYDLRyIrOUaHI+MELzSuINjc2MLExNTI2NzC3NSBNWEudN
	f5QUJCSQnliSmp2aWpBaFF9UmpNafIiRiYNTqoFxzYObknUFW6J25O8+eMVI6JSq9tn33VOy
	V8xjC/i4wZQn2/ej712R2k0rl4Zf0iwxWXTIXcjJbovGffW8E7yOrmcb8mqbD6hOl5/Adc/j
	xeHN65kVWXZ2th0K9IvzPbh332lhdRHr75c99p9Rv5uW0Pfeef/1fQe35z5aet31yXcexq9b
	Vj3fosRSnJFoqMVcVJwIAL0OwUHGAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprAKsWRmVeSWpSXmKPExsVy+t9jQd13+ZrBBj82y1lsenyN1eLyrjls
	FjPO72OyeDrhIpvFoq1f2C3Wz3jN4sDmcefaHjaPzUvqPfq2rGL0+LxJLoAlqoHRJiM1MSW1
	SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwdouZJCWWJOKVAoILG4
	WEnfDtOE0BA3XQuYxghd35AguB4jAzSQsI4xY8vTQ6wFx3grHm+Ja2A8w9XFyMkhIWAisXXO
	cxYIW0ziwr31bF2MXBxCAtMZJRqOHGeHcF4zSvRufwuU4eDgFdCSuL2WB6SBRUBVYmr/cUYQ
	m01AV+LJ+7nMILaoQJjEpul9rCA2r4CgxI/J98AWiAhoS3RevscKMpNZYDujxK0Xq5hAEsIC
	XhJfFnwCaxAScJfYdWgnO4jNKeAhsfPnKbAFzALWEisnbYOy5SU2r3nLPIFRYBaSHbOQlM1C
	UraAkXkVo2hqQXJBcVJ6rpFecWJucWleul5yfu4mRnD8PpPewbiqweIQowAHoxIP74EojWAh
	1sSy4srcQ4wSHMxKIrzCwOgX4k1JrKxKLcqPLyrNSS0+xJgMDIKJzFKiyfnA1JJXEm9obGJm
	ZGlkZmFkYm5OmrCSOO/BVutAIYH0xJLU7NTUgtQimC1MHJxSDYz6OxIvv5O/bbyDcRaDWyJP
	2ptZV2rm+MxTCLuW/nz6SkNtvdTLU3wUZhdGpQaWnZEvMYn+YfOz3OvBovp9n4+nc6eX+8cn
	LrzP0HvozJVLl1dHHD0Y2/ijOM/W1apiUdWkfQc33nzyuJjH8M2lt1sFp/o5ThE62XZk7YXd
	6dc+ZDb9dAuKV7mrxFKckWioxVxUnAgAMBeLMCMDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/12/2014 01:32 PM, Pankaj Dubey wrote:
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
> V2:
>   1) Adding new Kconfig file for Samsung common clock.
>   2) Make COMMON_CLK_SAMSUNG option invisible. (as suggested by Tomasz Figa)
>   3) Let COMMON_CLK_SAMSUNG select COMMON_CLK. (as suggested by Tomasz Figa)
>   4) Move S3C24XX clock config option in new Kconfig file.
>
> Pankaj Dubey (4):
>    clk: samsung: add new Kconfig for Samsung common clock options
>    drivers: clk: use CONFIG_COMMON_CLK_SAMSUNG for Samsung clock support
>    ARM: select COMMON_CLK_SAMSUNG for ARCH_EXYNOS and ARCH_S3C64XX
>    ARM: S3C24XX: remove S3C24XX specific clock Kconfig options
>
>   arch/arm/Kconfig              |    4 ++--
>   arch/arm/mach-s3c24xx/Kconfig |   14 --------------
>   drivers/clk/Kconfig           |    2 ++
>   drivers/clk/Makefile          |    2 +-
>   drivers/clk/samsung/Kconfig   |   11 +++++++++++
>   5 files changed, 16 insertions(+), 17 deletions(-)
>   create mode 100644 drivers/clk/samsung/Kconfig
>

+CC: Mike and Tomasz Figa

Sorry, during posting second version I forgot to CC Clock maintainer's,
so CC'ing now.

Link for this series: http://lkml.org/lkml/2014/3/12/10

-- 
Best Regards,
Pankaj Dubey


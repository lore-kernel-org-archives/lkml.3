Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753845AbaGHO0Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 10:26:25 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:8569 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750957AbaGHO0Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 10:26:24 -0400
X-AuditID: cbfec7f5-b7f626d000004b39-39-53bbff8d4407
Message-id: <53BBFF6D.8070203@samsung.com>
Date: Tue, 08 Jul 2014 16:25:49 +0200
From: Tomasz Figa <t.figa@samsung.com>
Organization: Samsung R&D Institute Poland
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.5.0
MIME-version: 1.0
To: Pankaj Dubey <pankaj.dubey@samsung.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: kgene.kim@samsung.com, linux@arm.linux.org.uk, vikas.sajjan@samsung.com,
        joshi@samsung.com, naushad@samsung.com, thomas.ab@samsung.com,
        chow.kim@samsung.com
Subject: Re: [PATCH v6 1/4] ARM: EXYNOS: Add support for mapping PMU base
 address via DT
References: <1404710376-16448-1-git-send-email-pankaj.dubey@samsung.com>
 <1404710376-16448-2-git-send-email-pankaj.dubey@samsung.com>
In-reply-to: <1404710376-16448-2-git-send-email-pankaj.dubey@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrBLMWRmVeSWpSXmKPExsVy+t/xK7q9/3cHG8y8w2ixbNJdNovvu76w
	W/QuuMpmsenxNVaLy7vmsFnMOL+PyeL2ZV6LT0f/s1os2gpU0bGM0eLms+1MDtweLc09bB6b
	l9R79G1ZxejxeZNcAEsUl01Kak5mWWqRvl0CV8bHrr2MBT+ZK5ZO72RrYJzN3MXIySEhYCKx
	6951VghbTOLCvfVsXYxcHEICSxklVk/8yg7hfGaUOPvnOQtIFa+AlsTCZ2fBulkEVCWmrF7I
	BGKzCahJfG54xAZi8wPVrGm6DlTPwSEqECHx+IIQRKugxI/J91hAZooITGOUuHjpNtgCZoEl
	jBJ7ZpxiBKkSFoiSeNqzlxliczujxK9V+8G2cQp4SmyZ0g22jVlAR2J/6zQ2CFteYvOat8wT
	GAVnIdkyC0nZLCRlCxiZVzGKppYmFxQnpeca6RUn5haX5qXrJefnbmKExMbXHYxLj1kdYhTg
	YFTi4TU4vztYiDWxrLgy9xCjBAezkgjvl1NAId6UxMqq1KL8+KLSnNTiQ4xMHJxSDYzGBdLu
	haaZ7D+u2dbm7mjgWcixeWdYWfdsLqs9zBuX87z9ahWt+aahvu5565TpdsVfW8tNQ3ZMexMu
	UhOZ3LjvU4GuZV3IRKb538RE8uraTj98/2F1zLl4/e8vw1Zz3p579GqDTrdge7/4xA7eefVh
	u81ry2bnZpw6dXKRdAzrC8tfV70X3FdiKc5INNRiLipOBAD6BnS/awIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07.07.2014 07:19, Pankaj Dubey wrote:
> Add support for mapping Samsung Power Management Unit (PMU)
> base address from device tree.
> 
> Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
> ---
>  arch/arm/mach-exynos/common.h |    1 +
>  arch/arm/mach-exynos/exynos.c |   37 +++++++++++++++++++++++++++++++++++++
>  2 files changed, 38 insertions(+)
> 

Thanks for keeping up with addressing the comments.

Reviewed-by: Tomasz Figa <t.figa@samsung.com>

--
Best regards,
Tomasz

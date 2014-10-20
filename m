Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753988AbaJTXl5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 19:41:57 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:49756 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751192AbaJTXly (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 19:41:54 -0400
X-AuditID: cbfee68f-f791c6d000004834-27-54459dc054b4
Message-id: <54459DC0.4040507@samsung.com>
Date: Tue, 21 Oct 2014 08:41:52 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Kukjin Kim <kgene.kim@samsung.com>, Doug Anderson <dianders@chromium.org>,
        Mark Brown <broonie@kernel.org>, Tomasz Figa <tomasz.figa@gmail.com>,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/2] Revert
 "mfd: sec-core: Prepare regulators for suspend state to reduce
 power-consumption"
References: <1413839151-10875-1-git-send-email-javier.martinez@collabora.co.uk>
 <1413839151-10875-2-git-send-email-javier.martinez@collabora.co.uk>
In-reply-to: <1413839151-10875-2-git-send-email-javier.martinez@collabora.co.uk>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrEIsWRmVeSWpSXmKPExsWyRsSkWPfAXNcQg5f3JS2mPnzCZnF22UE2
	i6O/Cyx6F1xls9j0+BqrxeVdc9gsZpzfx2SxatcfRgcOj9kNF1k8/j6/zuKxc9Zddo9NqzrZ
	PDYvqffo27KK0ePzJrkA9igum5TUnMyy1CJ9uwSujHk/G5gLTghWzJp+hbGBcSlfFyMnh4SA
	icTsTQ9YIWwxiQv31rN1MXJxCAksZZToaX3KDlO0bel3ZojEdEaJJzN/s0A4rxklDjZPZgKp
	4hXQkjjefR2sg0VAVWLD8T4wmw0ovv/FDTYQW1QgTGLl9CssEPWCEj8m3wOzRQTsJG6sfsgM
	YjMLNDBJXPgWBWILC1RIdO3+wAixbCqjxIK7i8AaOAUCJH4s+sUG0aAjsb91GpQtL7F5zVuw
	UyUEbrFLnN2/kAniIgGJb5MPATVzACVkJTYdYIZ4TVLi4IobLBMYxWYhuWkWkrGzkIxdwMi8
	ilE0tSC5oDgpvchYrzgxt7g0L10vOT93EyMwKk//e9a/g/HuAetDjAIcjEo8vDvMXEKEWBPL
	iitzDzGaAl0xkVlKNDkfGPt5JfGGxmZGFqYmpsZG5pZmSuK8C6V+BgsJpCeWpGanphakFsUX
	leakFh9iZOLglGpg9PT6O+9oYfmXOxxb1oq2se+/YSrPukOgZuHFubNNW9a0KjtKOmwpXLiA
	UURYnrOmYvcJwaoJy57WLfjG++BKMlNPYfmcgp2dJyLr1QWjFVbpzv9a8G+GuH9rUdZB7z0b
	NrlZ12l+D9fjuW24Z/MTwxkx3/cVPnzwas/DqattOPSf8QWrnbkuosRSnJFoqMVcVJwIAA3Z
	HuLFAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrDIsWRmVeSWpSXmKPExsVy+t9jQd0Dc11DDLreC1pMffiEzeLssoNs
	Fkd/F1j0LrjKZrHp8TVWi8u75rBZzDi/j8li1a4/jA4cHrMbLrJ4/H1+ncVj56y77B6bVnWy
	eWxeUu/Rt2UVo8fnTXIB7FENjDYZqYkpqUUKqXnJ+SmZeem2St7B8c7xpmYGhrqGlhbmSgp5
	ibmptkouPgG6bpk5QEcpKZQl5pQChQISi4uV9O0wTQgNcdO1gGmM0PUNCYLrMTJAAwlrGDPm
	/WxgLjghWDFr+hXGBsalfF2MnBwSAiYS25Z+Z4awxSQu3FvP1sXIxSEkMJ1R4snM3ywQzmtG
	iYPNk5lAqngFtCSOd19nB7FZBFQlNhzvA7PZgOL7X9xgA7FFBcIkVk6/wgJRLyjxY/I9MFtE
	wE7ixuqHYNuYBRqYJC58iwKxhQUqJLp2f2CEWDaVUWLB3UVgDZwCARI/Fv1ig2jQkdjfOg3K
	lpfYvOYt8wRGgVlIdsxCUjYLSdkCRuZVjKKpBckFxUnpuYZ6xYm5xaV56XrJ+bmbGMEx/0xq
	B+PKBotDjAIcjEo8vDvMXEKEWBPLiitzDzFKcDArifD+jXENEeJNSaysSi3Kjy8qzUktPsRo
	CgyCicxSosn5wHSUVxJvaGxiZmRpZG5oYWRsriTOe6DVOlBIID2xJDU7NbUgtQimj4mDU6qB
	8VjJm4DJaX9ddm96Eit5tem6qq/JP4utr90sL/Nq/U210ZVqsTn0zZg/Zn6SssM/h4LbCWWr
	At3T9HRllhwsONuR4mkv5v7KZ0PmvKgFS2b+P1/VV892oWbqnzfPtaunbjn2W9wwc3XOvqyD
	wkUee2fkLnxelcGg63BhzvTwSW813OdnLCz2UGIpzkg01GIuKk4EACj34y4PAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Javier,

On 10/21/2014 06:05 AM, Javier Martinez Canillas wrote:
> This reverts commit b7cde7078d2344073c310aa65fc2b0a845d2cb5b
> ("mfd: sec-core: Prepare regulators for suspend state to reduce power-consumption")
> 
> Commit b7cde7078d23 called regulator_suspend_prepare() to prepare the
> regulators for a suspend state. But it did from the device pm suspend
> handler while the regulator suspend prepare function iterates over all
> regulators and not only the one managed by this device so it doesn't
> seems to be correct to call it from within a device driver.
> 
> It is better to call the regulator suspend prepare/finish functions
> from platform code instead so this patch reverts the mentioned commit.
> 
> Suggested-by: Doug Anderson <dianders@chromium.org>
> Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
> ---
>  drivers/mfd/Kconfig    |  1 -
>  drivers/mfd/sec-core.c | 10 ----------
>  2 files changed, 11 deletions(-)
> 
> diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
> index 1456ea7..fd8cc4c 100644
> --- a/drivers/mfd/Kconfig
> +++ b/drivers/mfd/Kconfig
> @@ -655,7 +655,6 @@ config MFD_SEC_CORE
>  	select MFD_CORE
>  	select REGMAP_I2C
>  	select REGMAP_IRQ
> -	select REGULATOR
>  	help
>  	 Support for the Samsung Electronics MFD series.
>  	 This driver provides common support for accessing the device,
> diff --git a/drivers/mfd/sec-core.c b/drivers/mfd/sec-core.c
> index dba7e2b..5993608 100644
> --- a/drivers/mfd/sec-core.c
> +++ b/drivers/mfd/sec-core.c
> @@ -31,7 +31,6 @@
>  #include <linux/mfd/samsung/s2mpu02.h>
>  #include <linux/mfd/samsung/s5m8763.h>
>  #include <linux/mfd/samsung/s5m8767.h>
> -#include <linux/regulator/machine.h>
>  #include <linux/regmap.h>
>  
>  static const struct mfd_cell s5m8751_devs[] = {
> @@ -432,15 +431,6 @@ static int sec_pmic_suspend(struct device *dev)
>  	 */
>  	disable_irq(sec_pmic->irq);
>  
> -	switch (sec_pmic->device_type) {
> -	case S2MPS14X:
> -	case S2MPU02:
> -		regulator_suspend_prepare(PM_SUSPEND_MEM);
> -		break;
> -	default:
> -		break;
> -	}
> -
>  	return 0;
>  }
>  
> 

Reviewed-by: Chanwoo Choi <cw00.choi@samsung.com>

Thanks,
Chanwoo Choi

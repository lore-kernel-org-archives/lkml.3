Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751600Ab3GXGAs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 02:00:48 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:16605 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876Ab3GXGAq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 02:00:46 -0400
X-AuditID: cbfee690-b7f6f6d00000740c-f9-51ef6d8d70bd
From: Jingoo Han <jg1.han@samsung.com>
To: "'Michal Simek'" <michal.simek@xilinx.com>,
        "'Jean-Christophe Plagniol-Villard'" <plagnioj@jcrosoft.com>
Cc: "'Michal Simek'" <monstr@monstr.eu>,
        "'Tomi Valkeinen'" <tomi.valkeinen@ti.com>,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "'Stepan Moskovchenko'" <stepanm@codeaurora.org>,
        Jingoo Han <jg1.han@samsung.com>
References: <ed64cda456be840147ae1f04bec6a99733f41c24.1374643896.git.michal.simek@xilinx.com>
In-reply-to: <ed64cda456be840147ae1f04bec6a99733f41c24.1374643896.git.michal.simek@xilinx.com>
Subject: Re: [PATCH] video: xilinxfb: Fix compilation warning
Date: Wed, 24 Jul 2013 15:00:44 +0900
Message-id: <007401ce8833$22ce0600$686a1200$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQDhIjeOE8YCk8uEU8q7i3UDvN0bdptOHzsw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrAIsWRmVeSWpSXmKPExsVy+t8zA93e3PeBBquusFhcXniJ1eJE3wdW
	i8u75rBZvHsZYfHk42kWi3UPXzBZvFzkarF+/i02Bw6Py329TB6vLtxh8fjbNYXZo2/LKkaP
	4ze2M3l83iTnsffzb5YA9igum5TUnMyy1CJ9uwSujKfnz7MUvOeraLzwg62B8S13FyMnh4SA
	icTae32MELaYxIV769m6GLk4hASWMUp0TX3DDlN09MMNZojEIqDEmW4WCOcXo8SaBwvZQKrY
	BNQkvnw5DNYhIpAlsf/aLkaQImaBR4wS36/tY+pi5ADqiJf4dCsTpIZTIEGiYf0WJhBbWMBW
	4kV3O9gcFgFViS3ta1hBbF4BS4muFe3MELagxI/J91hAbGYBLYn1O48zQdjyEpvXvGWGuFRB
	YsfZ14wQNxhJdD14xwxRIyKx78U7sHskBFo5JNY9/88CsUxA4tvkQywgt0kIyEpsOgA1R1Li
	4IobLBMYJWYhWT0LyepZSFbPQrJiASPLKkbR1ILkguKk9CITveLE3OLSvHS95PzcTYyQ2J6w
	g/HeAetDjMlA6ycyS4km5wNTQ15JvKGxmZGFqYmpsZG5pRlpwkrivOot1oFCAumJJanZqakF
	qUXxRaU5qcWHGJk4OKUaGLlPPRS/qH5+1aQ95349dmFcXvLvSZRf1aMllwxXzV52v9IuXNEz
	/8iXj7UK/0pVPRJvBy4zW7GHUyEtdXrMlDSl862F3+MuiOx89qtP+t7BA0wJzn95TDivhyfK
	LmlLWaL5Kfi0fvWKpcst+N7NLDBKWtN48NNSNsuus436O074vjLmTjzpdVOJpTgj0VCLuag4
	EQCjh++5AwMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDKsWRmVeSWpSXmKPExsVy+t9jAd3e3PeBBmdkLS4vvMRqcaLvA6vF
	5V1z2CzevYywePLxNIvFuocvmCxeLnK1WD//FpsDh8flvl4mj1cX7rB4/O2awuzRt2UVo8fx
	G9uZPD5vkvPY+/k3SwB7VAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5i
	bqqtkotPgK5bZg7QTUoKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBAwjrGjKfn
	z7MUvOeraLzwg62B8S13FyMnh4SAicTRDzeYIWwxiQv31rN1MXJxCAksYpToOtPNAuH8YpRY
	82AhG0gVm4CaxJcvh9lBbBGBLIn913YxghQxCzxilPh+bR9TFyMHUEe8xKdbmSA1nAIJEg3r
	tzCB2MICthIvutvB5rAIqEpsaV/DCmLzClhKdK1oZ4awBSV+TL7HAmIzC2hJrN95nAnClpfY
	vOYt1KUKEjvOvmaEuMFIouvBO2aIGhGJfS/eMU5gFJqFZNQsJKNmIRk1C0nLAkaWVYyiqQXJ
	BcVJ6bmGesWJucWleel6yfm5mxjBaeOZ1A7GlQ0WhxgFOBiVeHgLZr0LFGJNLCuuzD3EKMHB
	rCTC+0LmfaAQb0piZVVqUX58UWlOavEhxmSgTycyS4km5wNTWl5JvKGxiZmRpZGZhZGJuTlp
	wkrivAdarQOFBNITS1KzU1MLUotgtjBxcEo1MIqkPnbayr5lfy0zd6ShReCnCXLxjgevbHmv
	eWMx8+a47a8+TjjDJWXau5930ou64iMXCz9eC7H/JhNz8ubJXazOMXP11Q8e2bHfwGldQnHI
	mbj9zqF37nPXLqrc9dSwfOa5d5WB/wuVErbzvbN457Q3t2B7o/jm+z9u34hi+3Fk73uVS2If
	4o8qsRRnJBpqMRcVJwIAUnB2xF8DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, July 24, 2013 2:32 PM, Michal Simek wrote:
> 
> regs_phys is phys_addr_t (u32 or u64).
> Lets retype it to u64.
> 
> Fixes compilation warning introduced by:
> video: xilinxfb: Use drvdata->regs_phys instead of physaddr
> (sha1: c88fafef0135e1e1c3e23c3e32ccbeeabc587f81)

CC'ed Stepan Moskovchenko


phys_addr_t is defined as below:

#ifdef CONFIG_PHYS_ADDR_T_64BIT
typedef u64 phys_addr_t;
#else
typedef u32 phys_addr_t;
#endif

According to 'Documentation/printk-formats.txt',
Physical addresses:
       %pa     0x01234567 or 0x0123456789abcdef
       For printing a phys_addr_t type (and its derivatives, such as
       resource_size_t) which can vary based on build options, regardless of
       the width of the CPU data path. Passed by reference.

Thus, '%pa' option looks proper, instead of casting (unsigned long long).

		dev_dbg(dev, "regs: phys=%pa, virt=%p\n", drvdata->regs_phys,
					drvdata->regs);


Best regards,
Jingoo Han


> 
> Signed-off-by: Michal Simek <michal.simek@xilinx.com>
> ---
> ppc44x_defconfig
> Fixes regressions in v3.11-rc2
> 
> ---
>  drivers/video/xilinxfb.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/video/xilinxfb.c b/drivers/video/xilinxfb.c
> index f3d4a69..79175a6 100644
> --- a/drivers/video/xilinxfb.c
> +++ b/drivers/video/xilinxfb.c
> @@ -341,8 +341,8 @@ static int xilinxfb_assign(struct platform_device *pdev,
> 
>  	if (drvdata->flags & BUS_ACCESS_FLAG) {
>  		/* Put a banner in the log (for DEBUG) */
> -		dev_dbg(dev, "regs: phys=%x, virt=%p\n", drvdata->regs_phys,
> -					drvdata->regs);
> +		dev_dbg(dev, "regs: phys=%llx, virt=%p\n",
> +			(unsigned long long)drvdata->regs_phys, drvdata->regs);
>  	}
>  	/* Put a banner in the log (for DEBUG) */
>  	dev_dbg(dev, "fb: phys=%llx, virt=%p, size=%x\n",
> --
> 1.8.2.3
> 


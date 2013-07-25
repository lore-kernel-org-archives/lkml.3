Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757685Ab3GYXOg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 19:14:36 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:19714 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756722Ab3GYXOe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 19:14:34 -0400
X-AuditID: cbfee690-b7f6f6d00000740c-87-51f1b1585fec
From: Jingoo Han <jg1.han@samsung.com>
To: "'Michal Simek'" <michal.simek@xilinx.com>,
        "'Jean-Christophe Plagniol-Villard'" <plagnioj@jcrosoft.com>
Cc: "'Michal Simek'" <monstr@monstr.eu>,
        "'Tomi Valkeinen'" <tomi.valkeinen@ti.com>,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "'Geert Uytterhoeven'" <geert@linux-m68k.org>,
        Jingoo Han <jg1.han@samsung.com>
References: <b8701d73538d37495b41ef465440a6d5f3018870.1374759923.git.michal.simek@xilinx.com>
In-reply-to: <b8701d73538d37495b41ef465440a6d5f3018870.1374759923.git.michal.simek@xilinx.com>
Subject: Re: [PATCH v3] video: xilinxfb: Fix compilation warning
Date: Fri, 26 Jul 2013 08:14:32 +0900
Message-id: <000e01ce898c$b865f740$2931e5c0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQGv6KqJYYunoL8LFwWZ4j+gRWEXl5mzR3uw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrIIsWRmVeSWpSXmKPExsVy+t8zQ92IjR8DDRZfkrV4dmsvk8XlhZdY
	LU70fWC1uLxrDpvFu5cRFk8+nmaxWPfwBZPF+vm32Bw4PF5duMPicehwB6PH364pzB59W1Yx
	ehy/sZ3J4/MmOY+9n3+zBLBHcdmkpOZklqUW6dslcGVMuzGBsaCFu+LgtsWsDYwvOboYOTkk
	BEwkDk9tZ4KwxSQu3FvP1sXIxSEksIxR4lHvWTaYovan96ASixglbsw/xQLh/GKU6NvVyAxS
	xSagJvHly2F2EFtEIEti/7VdjCBFzAL3GSW+/v8GNkpIIF6ide1uVhCbUyBBonPFSbBmYQEH
	iZvn24BsDg4WAVWJ3++tQcK8ApYSe1cvZYWwBSV+TL7HAmIzC2hJrN95nAnClpfYvOYtM8Sl
	ChI7zr5mhLjBSGJ63w9GiBoRiX0v3oHdIyHQyCFx8sFRsGYWAQGJb5MPsYDslRCQldh0AGqO
	pMTBFTdYJjBKzEKyehaS1bOQrJ6FZMUCRpZVjKKpBckFxUnpRSZ6xYm5xaV56XrJ+bmbGCHR
	PWEH470D1ocYk4HWT2SWEk3OByaHvJJ4Q2MzIwtTE1NjI3NLM9KElcR51VusA4UE0hNLUrNT
	UwtSi+KLSnNSiw8xMnFwSjUwZkju7Pxa9Zznt7nQhMMdnfsn55s6n6t5O1HvWAD3Ya2V748Z
	blqopxjR+OPk0jCJkG0Hy4+wK05Xs1urPfm6Fof4Irtw75YYuSMZS9O9btbGmBdcvWW45NlH
	njnvLX74n73MuzDvtvkVhyuV738XhikLy2c8WrJKvCTmyml9n+NsDSff7qtersRSnJFoqMVc
	VJwIACQ1a5sEAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHKsWRmVeSWpSXmKPExsVy+t9jAd2IjR8DDY79lLB4dmsvk8XlhZdY
	LU70fWC1uLxrDpvFu5cRFk8+nmaxWPfwBZPF+vm32Bw4PF5duMPicehwB6PH364pzB59W1Yx
	ehy/sZ3J4/MmOY+9n3+zBLBHNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp
	5CXmptoqufgE6Lpl5gBdpaRQlphTChQKSCwuVtK3wzQhNMRN1wKmMULXNyQIrsfIAA0krGPM
	mHZjAmNBC3fFwW2LWRsYX3J0MXJySAiYSLQ/vccGYYtJXLi3Hsjm4hASWMQocWP+KRYI5xej
	RN+uRmaQKjYBNYkvXw6zg9giAlkS+6/tYgQpYha4zyjx9f83sFFCAvESrWt3s4LYnAIJEp0r
	ToI1Cws4SNw83wZkc3CwCKhK/H5vDRLmFbCU2Lt6KSuELSjxY/I9FhCbWUBLYv3O40wQtrzE
	5jVvmSEuVZDYcfY1I8QNRhLT+34wQtSISOx78Y5xAqPQLCSjZiEZNQvJqFlIWhYwsqxiFE0t
	SC4oTkrPNdIrTswtLs1L10vOz93ECE4dz6R3MK5qsDjEKMDBqMTDq+D0MVCINbGsuDL3EKME
	B7OSCO+tXqAQb0piZVVqUX58UWlOavEhxmSgRycyS4km5wPTWl5JvKGxiZmRpZGZhZGJuTlp
	wkrivAdbrQOFBNITS1KzU1MLUotgtjBxcEo1MCoErJnNYeycceCrrfW8uPslx4V2fGYMYpZg
	6jx5SukKd7nPuhDlc07H3p7sn3/db/eTJqssY6e6f2aFpWWcG5+93VJnJzE1oeRU0M+0rglN
	Fy1nmV7mZzphbHU3aI1g5sRzrrrL+oIXcFn66XhLzyp5+3Au/7uXFT4FV7M7Vn3mmLA7W131
	kxJLcUaioRZzUXEiAD3kpjBhAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, July 25, 2013 10:45 PM, Michal Simek wrote:
> 
> regs_phys is phys_addr_t (u32 or u64).
> Lets use %pa printk format specifier.
> 
> Fixes compilation warning introduced by:
> video: xilinxfb: Use drvdata->regs_phys instead of physaddr
> (sha1: c88fafef0135e1e1c3e23c3e32ccbeeabc587f81)
> 
> Signed-off-by: Michal Simek <michal.simek@xilinx.com>

It looks good.

Reviewed-by: Jingoo Han <jg1.han@samsung.com>

Best regards,
Jingoo Han

> ---
> Changes in v3:
> - Fix commit message reported by Geert
> 
> Changes in v2:
> - Use %pa instead of casting
> 
> ppc44x_defconfig
> Fixes regressions in v3.11-rc2
> 
> ---
>  drivers/video/xilinxfb.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/video/xilinxfb.c b/drivers/video/xilinxfb.c
> index f3d4a69..6629b29 100644
> --- a/drivers/video/xilinxfb.c
> +++ b/drivers/video/xilinxfb.c
> @@ -341,8 +341,8 @@ static int xilinxfb_assign(struct platform_device *pdev,
> 
>  	if (drvdata->flags & BUS_ACCESS_FLAG) {
>  		/* Put a banner in the log (for DEBUG) */
> -		dev_dbg(dev, "regs: phys=%x, virt=%p\n", drvdata->regs_phys,
> -					drvdata->regs);
> +		dev_dbg(dev, "regs: phys=%pa, virt=%p\n",
> +			&drvdata->regs_phys, drvdata->regs);
>  	}
>  	/* Put a banner in the log (for DEBUG) */
>  	dev_dbg(dev, "fb: phys=%llx, virt=%p, size=%x\n",
> --
> 1.8.2.3
>


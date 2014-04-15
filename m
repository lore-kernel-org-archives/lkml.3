Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754632AbaDOMIr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 08:08:47 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:40745 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751605AbaDOMIp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 08:08:45 -0400
X-AuditID: cbfee68e-b7f566d000002344-e4-534d214b5020
From: Jingoo Han <jg1.han@samsung.com>
To: "'Paul Bolle'" <pebolle@tiscali.nl>,
        "'Tomi Valkeinen'" <tomi.valkeinen@ti.com>
Cc: "'Jean-Christophe Plagniol-Villard'" <plagnioj@jcrosoft.com>,
        "'Richard Weinberger'" <richard@nod.at>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, "'Jingoo Han'" <jg1.han@samsung.com>
References: <1397561044.1985.47.camel@x220>
In-reply-to: <1397561044.1985.47.camel@x220>
Subject: Re: [PATCH 1/2] video: mmp: Remove references to CPU_MMP3
Date: Tue, 15 Apr 2014 21:08:43 +0900
Message-id: <000001cf58a3$720382e0$560a88a0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac9YnUxJ63GjdUQcRESaD4efEJ3gWwABdfSQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMIsWRmVeSWpSXmKPExsVy+t8zQ11vRd9ggzm9shaXF15itTjR94HV
	4vKuOWwWi26dYbZY9/AFk8XknW8YLdbPv8XmwO7x6sIdFo+b8wo9+rasYvQ4fmM7k8fG7U+Y
	PD5vkgtgi+KySUnNySxLLdK3S+DK2HRvBmtBo0DFtz2/GRsYL/F0MXJySAiYSPRt+MkIYYtJ
	XLi3nq2LkYtDSGAZo8TEmYeYYIoef9vICJGYziix+NlmFgjnN6PElP1XWUGq2ATUJL58OcwO
	YosI+Ess3r2JGaSIWeAEo8Teea+A2jmAOrQlji4rBanhFNCRmNWxFmy1sICTxP3LB5hBbBYB
	VYk/O/vA5vAK2EpsXtIKZQtK/Jh8jwVkDLOAusSUKbkgYWYBeYnNa94yg4QlgMKP/uqCmCIC
	RhLve3wgKkQk9r14B3a+hMBPdonOHSfYITYJSHybfIgFolVWYhPEARICkhIHV9xgmcAoMQvJ
	3lkIe2ch2TsLyYYFjCyrGEVTC5ILipPSi4z0ihNzi0vz0vWS83M3MUIiuG8H480D1ocYk4G2
	T2SWEk3OByaAvJJ4Q2MzIwtTE1NjI3NLM9KElcR5Fz1MChISSE8sSc1OTS1ILYovKs1JLT7E
	yMTBKdXAaOZ9K/mQWoRHyILLO0Uafuuv2frKfPnRw5/jEnzK3rtr+prP3HZu0QaH6ZGL7rIX
	u02tY7nu8HjZg5rpU96HPTd7khQ9wSvG+9FrRemI6wvu9hlE8iseM0q/0t19cCOT0iV9R6GZ
	LyMtjGWO+++IlbR8GV4scfEmC+veexdvtrsy5ihtKavMV2Ipzkg01GIuKk4EAGYfV372AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrAKsWRmVeSWpSXmKPExsVy+t9jQV1vRd9gg43bJCwuL7zEanGi7wOr
	xeVdc9gsFt06w2yx7uELJovJO98wWqyff4vNgd3j1YU7LB435xV69G1Zxehx/MZ2Jo+N258w
	eXzeJBfAFtXAaJORmpiSWqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6Dr
	lpkDdIuSQlliTilQKCCxuFhJ3w7ThNAQN10LmMYIXd+QILgeIwM0kLCOMWPTvRmsBY0CFd/2
	/GZsYLzE08XIySEhYCLx+NtGRghbTOLCvfVsXYxcHEIC0xklFj/bzALh/GaUmLL/KitIFZuA
	msSXL4fZQWwRAX+Jxbs3MYMUMQucYJTYO+8V0CgOoA5tiaPLSkFqOAV0JGZ1rAXbICzgJHH/
	8gFmEJtFQFXiz84+sDm8ArYSm5e0QtmCEj8m32MBGcMsoC4xZUouSJhZQF5i85q3zCBhCaDw
	o7+6IKaIgJHE+x4fiAoRiX0v3jFOYBSahWTOLIQ5s5DMmYWkYwEjyypG0dSC5ILipPRcI73i
	xNzi0rx0veT83E2M4PTwTHoH46oGi0OMAhyMSjy8E955BwuxJpYVV+YeYpTgYFYS4f3I7Rss
	xJuSWFmVWpQfX1Sak1p8iDEZ6MuJzFKiyfnA1JVXEm9obGJmZGlkZmFkYm5OmrCSOO/BVutA
	IYH0xJLU7NTUgtQimC1MHJxSDYwxG2y9a/atCdb/0uup5ayob1PEKJ6lWBS/fdoRn6Wij9fx
	NCmZ3G949VZxaU6TCM82zxPn7R29bjJtFD+yPqIlMo+HQ2ODy5da2TnTW2e/Pmj2k0OPJWTS
	ZRPdX0LnumfOzrQ70jj5qzOjrKrCm+6JS4/MCrjgf7DBYw2n6B+3d6k/zJb5iiuxFGckGmox
	FxUnAgBKfFC2UwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, April 15, 2014 8:24 PM, Paul Bolle wrote:
> 
> From: Richard Weinberger <richard@nod.at>
> 
> References to the Kconfig symbol CPU_MMP3 were added to the tree since
> v3.6. But that Kconfig symbol has never been part of the tree. So get
> rid of these references.
> 
> Signed-off-by: Richard Weinberger <richard@nod.at>
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>

Reviewed-by: Jingoo Han <jg1.han@samsung.com>

Best regards,
Jingoo Han

> ---
> 0) Tested with git grep.
> 
> 1) Originally sent as "[PATCH 01/28] Remove CPU_MMP3" two months ago.
> Added a proper commit explanation to aid reviewers.
> 
> 2) One reference to CPU_MMP3 remains. I'll remove that in a more
> elaborate patch.
> 
>  drivers/video/mmp/Kconfig    | 2 +-
>  drivers/video/mmp/hw/Kconfig | 4 ++--
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/video/mmp/Kconfig b/drivers/video/mmp/Kconfig
> index e9ea39e13722..969925d694c9 100644
> --- a/drivers/video/mmp/Kconfig
> +++ b/drivers/video/mmp/Kconfig
> @@ -1,6 +1,6 @@
>  menuconfig MMP_DISP
>          tristate "Marvell MMP Display Subsystem support"
> -        depends on CPU_PXA910 || CPU_MMP2 || CPU_MMP3 || CPU_PXA988
> +        depends on CPU_PXA910 || CPU_MMP2 || CPU_PXA988
>          help
>  	  Marvell Display Subsystem support.
> 
> diff --git a/drivers/video/mmp/hw/Kconfig b/drivers/video/mmp/hw/Kconfig
> index 02f109a20cd0..99f0506afc99 100644
> --- a/drivers/video/mmp/hw/Kconfig
> +++ b/drivers/video/mmp/hw/Kconfig
> @@ -2,12 +2,12 @@ if MMP_DISP
> 
>  config MMP_DISP_CONTROLLER
>  	bool "mmp display controller hw support"
> -	depends on CPU_PXA910 || CPU_MMP2 || CPU_MMP3 || CPU_PXA988
> +	depends on CPU_PXA910 || CPU_MMP2 || CPU_PXA988
>  	default n
>  	help
>  		Marvell MMP display hw controller support
>  		this controller is used on Marvell PXA910,
> -		MMP2, MMP3, PXA988 chips
> +		MMP2, PXA988 chips
> 
>  config MMP_DISP_SPI
>  	bool "mmp display controller spi port"
> --
> 1.9.0


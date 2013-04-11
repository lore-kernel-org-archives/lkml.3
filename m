Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752808Ab3DKFHH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 01:07:07 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:9150 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751225Ab3DKFHE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 01:07:04 -0400
X-AuditID: cbfee691-b7f5f6d000002fda-18-516644f6f7c9
From: Jingoo Han <jg1.han@samsung.com>
To: "'Arnd Bergmann'" <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org
Cc: "'Tomi Valkeinen'" <tomi.valkeinen@ti.com>, linux-kernel@vger.kernel.org,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-fbdev@vger.kernel.org,
        "'Inki Dae'" <inki.dae@samsung.com>,
        "'Donghwa Lee'" <dh09.lee@samsung.com>,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <1365638712-1028578-1-git-send-email-arnd@arndb.de>
 <1365638712-1028578-13-git-send-email-arnd@arndb.de>
In-reply-to: <1365638712-1028578-13-git-send-email-arnd@arndb.de>
Subject: Re: [PATCH 12/30] video/exynos: remove unnecessary header inclusions
Date: Thu, 11 Apr 2013 14:07:02 +0900
Message-id: <003201ce3672$66f72e50$34e58af0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac42SHilCvWhzLyNTT+YTyjfM5mdMAAKYGbw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrOIsWRmVeSWpSXmKPExsVy+t8zQ91vLmmBBg//S1j8nXSM3eLlIU2L
	6+ftLCbdn8BicXnhJVaL3gVX2SzONr1ht9j0+BqrxYm+D6wWl3fNYbOYcX4fk8X6+bfYHHg8
	fv+axOixeUm9R9+WVYwex29sZ/L4vEkugDWKyyYlNSezLLVI3y6BK+Pdpl3sBdMEKx7fPcbW
	wHiEr4uRk0NCwERi0r//zBC2mMSFe+vZQGwhgWWMEnN/2sLULHvxFKiGCyi+iFGi78pedgjn
	F6NE/6dJLCBVbAJqEl++HGYHsUUEPCXOnFzAAlLELHCJSeLQ42tQY8skZn+6xdrFyMHBKeAo
	cbxZHSQsLOArMeP8AlYQm0VAVWLSmuNgF/EK2EocbDjFBmELSvyYfA9sF7OAlsTmbU2sELa8
	xOY1b5lBRkoIqEs8+qsLcYKRRNPliewQJSIS+168YwQ5R0JgIofE9UWfmCF2CUh8m3yIBaJX
	VmLTAWhASEocXHGDZQKjxCwkm2ch2TwLyeZZSFYsYGRZxSiaWpBcUJyUXmSqV5yYW1yal66X
	nJ+7iRES6RN3MN4/YH2IMRlo/URmKdHkfGCiyCuJNzQ2M7IwNTE1NjK3NCNNWEmcV73FOlBI
	ID2xJDU7NbUgtSi+qDQntfgQIxMHp1QDY55bo//TPfuZ6iJ5F3zv7ThuvPa0vKbBC4WelwY/
	co7n9S4TqDlso+D3e3l84rNq75k/rv1PnrDdyPSfYcWp9TtX72e+P88x5nnzTmOpWdsTe67N
	vxEvmMx98IqBgM3m5J50MevVE9/ererpaDnCKbt220P/wEDm+IXadSsWem3wzjs0S44lXIml
	OCPRUIu5qDgRAB24SFAKAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKKsWRmVeSWpSXmKPExsVy+t9jAd1vLmmBBhefC1v8nXSM3eLlIU2L
	6+ftLCbdn8BicXnhJVaL3gVX2SzONr1ht9j0+BqrxYm+D6wWl3fNYbOYcX4fk8X6+bfYHHg8
	fv+axOixeUm9R9+WVYwex29sZ/L4vEkugDWqgdEmIzUxJbVIITUvOT8lMy/dVsk7ON453tTM
	wFDX0NLCXEkhLzE31VbJxSdA1y0zB+g6JYWyxJxSoFBAYnGxkr4dpgmhIW66FjCNEbq+IUFw
	PUYGaCBhHWPGu0272AumCVY8vnuMrYHxCF8XIyeHhICJxLIXT5khbDGJC/fWs3UxcnEICSxi
	lOi7spcdwvnFKNH/aRILSBWbgJrEly+H2UFsEQFPiTMnF7CAFDELXGKSOPT4GhtIQkigTGL2
	p1usXYwcHJwCjhLHm9VBwsICvhIzzi9gBbFZBFQlJq05DraZV8BW4mDDKTYIW1Dix+R7YLuY
	BbQkNm9rYoWw5SU2r3nLDDJSQkBd4tFfXYgTjCSaLk9khygRkdj34h3jBEahWUgmzUIyaRaS
	SbOQtCxgZFnFKJpakFxQnJSea6hXnJhbXJqXrpecn7uJEZxInkntYFzZYHGIUYCDUYmH90RD
	aqAQa2JZcWXuIUYJDmYlEV6unUAh3pTEyqrUovz4otKc1OJDjMlAj05klhJNzgcmubySeENj
	EzMjSyMzCyMTc3PShJXEeQ+0WgcKCaQnlqRmp6YWpBbBbGHi4JRqYPSfqvTe539Y079wtrmL
	b68xPtE+00X7yb15nIYGB665VCr/nrjPMvC4fC7zCW09jd65cwLYas/FndF+J32N+5Pl7tSg
	h/N1SrnankafZPzo9FKy6tAyXt85RjufuPhah0dUO/D7/rHQNuoN8BHc9Otg8ORfQk3rjgtM
	PFTEWpb2faNDyfvo+0osxRmJhlrMRcWJAD2/jd5oAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, April 11, 2013 9:05 AM, Arnd Bergmann wrote:
> 
> In multiplatform configurations, we cannot include headers
> provided by only the exynos platform. Fortunately a number
> of drivers that include those headers do not actually need
> them, so we can just remove the inclusions.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: linux-fbdev@vger.kernel.org
> Cc: Jingoo Han <jg1.han@samsung.com>

CC'ed Tomi Valkeinen, Inki Dae, Donghwa Lee, Kyungmin Park


Acked-by: Jingoo Han <jg1.han@samsung.com>

Best regards,
Jingoo Han

> ---
>  drivers/video/exynos/exynos_mipi_dsi.c          | 2 --
>  drivers/video/exynos/exynos_mipi_dsi_common.c   | 2 --
>  drivers/video/exynos/exynos_mipi_dsi_lowlevel.c | 2 --
>  3 files changed, 6 deletions(-)
> 
> diff --git a/drivers/video/exynos/exynos_mipi_dsi.c b/drivers/video/exynos/exynos_mipi_dsi.c
> index fac7df6..3dd43ca 100644
> --- a/drivers/video/exynos/exynos_mipi_dsi.c
> +++ b/drivers/video/exynos/exynos_mipi_dsi.c
> @@ -35,8 +35,6 @@
> 
>  #include <video/exynos_mipi_dsim.h>
> 
> -#include <plat/fb.h>
> -
>  #include "exynos_mipi_dsi_common.h"
>  #include "exynos_mipi_dsi_lowlevel.h"
> 
> diff --git a/drivers/video/exynos/exynos_mipi_dsi_common.c
> b/drivers/video/exynos/exynos_mipi_dsi_common.c
> index c70cb89..520fc9b 100644
> --- a/drivers/video/exynos/exynos_mipi_dsi_common.c
> +++ b/drivers/video/exynos/exynos_mipi_dsi_common.c
> @@ -31,8 +31,6 @@
>  #include <video/mipi_display.h>
>  #include <video/exynos_mipi_dsim.h>
> 
> -#include <mach/map.h>
> -
>  #include "exynos_mipi_dsi_regs.h"
>  #include "exynos_mipi_dsi_lowlevel.h"
>  #include "exynos_mipi_dsi_common.h"
> diff --git a/drivers/video/exynos/exynos_mipi_dsi_lowlevel.c
> b/drivers/video/exynos/exynos_mipi_dsi_lowlevel.c
> index 95cb99a..15c5abd 100644
> --- a/drivers/video/exynos/exynos_mipi_dsi_lowlevel.c
> +++ b/drivers/video/exynos/exynos_mipi_dsi_lowlevel.c
> @@ -26,8 +26,6 @@
> 
>  #include <video/exynos_mipi_dsim.h>
> 
> -#include <mach/map.h>
> -
>  #include "exynos_mipi_dsi_regs.h"
> 
>  void exynos_mipi_dsi_func_reset(struct mipi_dsim_device *dsim)
> --
> 1.8.1.2


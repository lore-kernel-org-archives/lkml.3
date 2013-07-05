Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933751Ab3GENBz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 09:01:55 -0400
Received: from co9ehsobe004.messaging.microsoft.com ([207.46.163.27]:43680
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757340Ab3GENBx convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 09:01:53 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VPS-3(zz9371I542I1432Izz1f42h1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz17326ah8275dhz2dh668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh15d0h162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1155h)
X-WSS-ID: 0MPGS6Z-01-84D-02
X-M-MSG: 
From: "Deucher, Alexander" <Alexander.Deucher@amd.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>, David Airlie <airlied@linux.ie>
CC: "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>
Subject: RE: [PATCH -next] drm/radeon/dpm: Add missing #include
 <linux/seq_file.h>
Thread-Topic: [PATCH -next] drm/radeon/dpm: Add missing #include
 <linux/seq_file.h>
Thread-Index: AQHOeXJmS222rxy6E0mqGD0hILAZ1ZlWDI5g
Date: Fri, 5 Jul 2013 13:01:45 +0000
Message-ID: <A3397C8B8B789E45844E7EC5DEAD89D02E500B6B@sausexdag04.amd.com>
References: <1373023528-3361-1-git-send-email-geert@linux-m68k.org>
In-Reply-To: <1373023528-3361-1-git-send-email-geert@linux-m68k.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.177.96.13]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Geert Uytterhoeven [mailto:geert@linux-m68k.org]
> Sent: Friday, July 05, 2013 7:25 AM
> To: Deucher, Alexander; David Airlie
> Cc: dri-devel@lists.freedesktop.org; linux-kernel@vger.kernel.org; linux-
> next@vger.kernel.org; Geert Uytterhoeven
> Subject: [PATCH -next] drm/radeon/dpm: Add missing #include
> <linux/seq_file.h>
> 
> ia64_defconfig:
> 
> drivers/gpu/drm/radeon/rv6xx_dpm.c: In function
> 'rv6xx_dpm_debugfs_print_current_performance_level':
> drivers/gpu/drm/radeon/rv6xx_dpm.c:2041:3: error: implicit declaration of
> function 'seq_printf' [-Werror=implicit-function-declaration]
> 

Already fixed in:
http://cgit.freedesktop.org/~airlied/linux/commit/?h=drm-next&id=bf0936e196ec21b604106578043d4c14831f99e7

Alex

> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> ---
> http://kisskb.ellerman.id.au/kisskb/buildresult/9068726/
> 
>  drivers/gpu/drm/radeon/rv6xx_dpm.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/gpu/drm/radeon/rv6xx_dpm.c
> b/drivers/gpu/drm/radeon/rv6xx_dpm.c
> index 33705c5..0d09677 100644
> --- a/drivers/gpu/drm/radeon/rv6xx_dpm.c
> +++ b/drivers/gpu/drm/radeon/rv6xx_dpm.c
> @@ -22,6 +22,7 @@
>   * Authors: Alex Deucher
>   */
> 
> +#include <linux/seq_file.h>
>  #include "drmP.h"
>  #include "radeon.h"
>  #include "rv6xxd.h"
> --
> 1.7.9.5
> 



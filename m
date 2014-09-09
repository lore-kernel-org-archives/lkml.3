Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752438AbaIIUhJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 16:37:09 -0400
Received: from mout.gmx.net ([212.227.17.21]:60886 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752083AbaIIUhH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 16:37:07 -0400
Date: Tue, 9 Sep 2014 22:36:19 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCHv3 1/3] [media] disable OMAP1 COMPILE_TEST
In-Reply-To: <5f850d5d45a27c50dabf3da08689cbedf986841b.1410288748.git.m.chehab@samsung.com>
Message-ID: <Pine.LNX.4.64.1409092235160.9452@axis700.grange>
References: <6cbd00c5f2d342b573aaf9c0e533778374dd2e1e.1410273306.git.m.chehab@samsung.com>
 <5f850d5d45a27c50dabf3da08689cbedf986841b.1410288748.git.m.chehab@samsung.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V03:K0:eadUGOLytiJYIiM5lP+uxsXnM+w8lDJ5V0do8dsqSXENd/9WS4Y
 3Y4shXHPJJjc5KvUJ+XJP1J/u64+RTnJyWB6NY/PsOTs4PvJ//YTouJvsU+BtpvLY39lfez
 XKcb4LJ/ZfI6YQb7rJIzjoirvgTE6EulkF3rAHIGn3eVYp1cLyBGKKvMI4xXEPMhpAZGPHd
 gxtLJSC5PXpoXyfjPQc3A==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks, Mauro,

On Tue, 9 Sep 2014, Mauro Carvalho Chehab wrote:

> This driver depends on a legacy OMAP DMA API. So, it won't
> compile-test on other archs.
> 
> While we might add stubs to the functions, this is not a
> good idea, as the hole API should be replaced.
> 
> So, for now, let's just remove COMPILE_TEST and wait for
> some time for people to fix. If not fixed, then we'll end
> by removing this driver as a hole.
> 
> Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>

Acked-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

Regards
Guennadi

> 
> diff --git a/drivers/media/platform/soc_camera/Kconfig b/drivers/media/platform/soc_camera/Kconfig
> index 6af6c6dccda8..f2776cd415ca 100644
> --- a/drivers/media/platform/soc_camera/Kconfig
> +++ b/drivers/media/platform/soc_camera/Kconfig
> @@ -63,7 +63,7 @@ config VIDEO_SH_MOBILE_CEU
>  config VIDEO_OMAP1
>  	tristate "OMAP1 Camera Interface driver"
>  	depends on VIDEO_DEV && SOC_CAMERA
> -	depends on ARCH_OMAP1 || COMPILE_TEST
> +	depends on ARCH_OMAP1
>  	depends on HAS_DMA
>  	select VIDEOBUF_DMA_CONTIG
>  	select VIDEOBUF_DMA_SG
> -- 
> 1.9.3
> 

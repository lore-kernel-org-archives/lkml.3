Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751862Ab3BFI6i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 03:58:38 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:57117 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268Ab3BFI6h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 03:58:37 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Shawn Guo <shawn.guo@linaro.org>
Subject: Re: [PATCH] ASoC: fsl: fix allyesconfig build for imx-pcm
Date: Wed, 6 Feb 2013 08:58:31 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-4-generic; KDE/4.3.2; x86_64; ; )
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arm@kernel.org, Liam Girdwood <lrg@ti.com>,
        alsa-devel@alsa-project.org
References: <1358788568-11137-1-git-send-email-arnd@arndb.de> <201302051642.25361.arnd@arndb.de> <20130206040212.GA18613@S2101-09.ap.freescale.net>
In-Reply-To: <20130206040212.GA18613@S2101-09.ap.freescale.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201302060858.31510.arnd@arndb.de>
X-Provags-ID: V02:K0:hofN0Mf7Y3apyqaT7Y3Pylkm8GgzYVobsaaMO+3d4v5
 w7WZQHWLfaNVhIOu3ASAJ4QBqkx8adetv8Lu/6GRYBAo5Yk2KJ
 cFDLuJuksi+l8J81R85ETXzOruUWsHq8J9THGSaPg2uvLNZ+LI
 MiOSeQO0c8sxCAeYXx1tZTl5HKvP7wEEJ3KyTyslFE4CJq/F0N
 TOTGBOywiK88TrGNH5jd/OyQ/92FKq7rPWmJNqS8y2eAlDZWpD
 LvPVKOBKiMWlR+gemgHoH6FYLQ1MJauBJubQTXySiUmuZQPJQl
 gRTdQJ6coYa+jSn4jRu0urEg3paTunbghRUoAg5DcfCGSwFU9F
 ZcxQRaSZ01Ix//lLs1zw=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 06 February 2013, Shawn Guo wrote:
> On Tue, Feb 05, 2013 at 04:42:25PM +0000, Arnd Bergmann wrote:
> > Patch 25b8d314 "ASoC: fsl: fix multiple definition of init_module changed
> > the Makefile for imx-pcm.ko to build two modules that both contain the
> > imx-pcm.c file, which nicely solves the problem of building both versions
> > of the driver as modules, but it causes two new problems:
> > 
> It's my fault, Arnd.  The patch 25b8d314 is a crap.  Instead of making
> the Kconfig even complexer, I chose to revert the patch and do a little
> surgery on the code to make it match the Kconfig rational.  The fix[1]
> should be on the way to mainline now.
> 
> I'm sorry for messing thing up during -rc time.
> 
> Shawn
> 
> [1] http://thread.gmane.org/gmane.linux.alsa.devel/105018
> 

Ok, again you were faster than I was at finding a solution, and the
new one looks good to me.

Thanks for taking care of this already,

	Arnd

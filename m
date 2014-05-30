Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755212AbaE3IPp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 04:15:45 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:56892 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751968AbaE3IPm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 04:15:42 -0400
Date: Fri, 30 May 2014 09:15:36 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'Inki Dae'" <inki.dae@samsung.com>, dri-devel@lists.freedesktop.org,
        "'Seung-Woo Kim'" <sw0312.kim@samsung.com>,
        "'Dave Airlie'" <airlied@redhat.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, kernel@stlinux.com,
        "'Tomasz Figa'" <tomasz.figa@gmail.com>
Subject: Re: [PATCH] drm/exynos: remove unnecessary exynos_hdmi.h file
Message-ID: <20140530081536.GE2619@lee--X1>
References: <000a01cf7bac$8f805f60$ae811e20$%han@samsung.com>
 <20140530081403.GD2619@lee--X1>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140530081403.GD2619@lee--X1>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > The exynos_hdmi.h has been used for the dedicated i2c drivers
> > that were already removed. Thus, the unnecessary exynos_hdmi.h
> > should be removed.
> > 
> > Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> > ---
> >  drivers/gpu/drm/exynos/exynos_hdmi.h |   23 -----------------------
> >  1 file changed, 23 deletions(-)
> >  delete mode 100644 drivers/gpu/drm/exynos/exynos_hdmi.h
> 
> https://lkml.org/lkml/2014/5/29/810

Oh, I see.

Acked-by: Lee Jones <lee.jones@linaro.org>

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog

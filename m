Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758684Ab3EGIVK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 04:21:10 -0400
Received: from mail-ee0-f45.google.com ([74.125.83.45]:64877 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757441Ab3EGIVH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 04:21:07 -0400
Date: Tue, 7 May 2013 09:15:29 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'Anton Vorontsov'" <anton@enomsg.org>,
        "'David Woodhouse'" <dwmw2@infradead.org>,
        linux-kernel@vger.kernel.org,
        "'Hongbo Zhang'" <hongbo.zhang@linaro.org>,
        "'Marcus Cooper'" <marcus.xm.cooper@stericsson.com>
Subject: Re: [PATCH 3/8] ab8500_bm: remove unnecessary platform_set_drvdata()
Message-ID: <20130507081529.GB3102@gmail.com>
References: <003801ce4a11$0259c4a0$070d4de0$@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <003801ce4a11$0259c4a0$070d4de0$@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 06 May 2013, Jingoo Han wrote:

> The driver core clears the driver data to NULL after device_release
> or on probe failure, since commit 0998d0631001288a5974afc0b2a5f568bcdecb4d
> (device-core: Ensure drvdata = NULL when no driver is bound).
> Thus, it is not needed to manually clear the device driver data to NULL.
> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> ---
>  drivers/power/ab8500_btemp.c    |    1 -
>  drivers/power/ab8500_charger.c  |    2 --
>  drivers/power/ab8500_fg.c       |    1 -
>  drivers/power/abx500_chargalg.c |    1 -
>  4 files changed, 0 insertions(+), 5 deletions(-)

Acked-by: Lee Jones <lee.jones@linaro.org>

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753052Ab3LPJHy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 04:07:54 -0500
Received: from mail-wg0-f43.google.com ([74.125.82.43]:65089 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751885Ab3LPJHw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 04:07:52 -0500
Date: Mon, 16 Dec 2013 09:07:46 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Alexander Shiyan <shc_work@mail.ru>
Cc: linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH 1/3] mfd: mc13xxx: Remove useless symbol MFD_MC13783
Message-ID: <20131216090746.GG18769@lee--X1>
References: <1387026192-21234-1-git-send-email-shc_work@mail.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1387026192-21234-1-git-send-email-shc_work@mail.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Symbol MFD_MC13783 always selected by MFD_MC13XXX, so no need
> to keep additional symbol.
> 
> Signed-off-by: Alexander Shiyan <shc_work@mail.ru>
> ---
>  drivers/input/misc/Kconfig        | 2 +-
>  drivers/input/touchscreen/Kconfig | 2 +-
>  drivers/mfd/Kconfig               | 4 ----
>  drivers/regulator/Kconfig         | 2 +-
>  sound/soc/fsl/Kconfig             | 2 +-
>  5 files changed, 4 insertions(+), 8 deletions(-)

Applied, thanks.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog

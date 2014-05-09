Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756564AbaEILai (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 07:30:38 -0400
Received: from mail-ie0-f176.google.com ([209.85.223.176]:50514 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754569AbaEILag (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 07:30:36 -0400
Date: Fri, 9 May 2014 12:30:30 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Alexander Shiyan <shc_work@mail.ru>
Cc: linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        Samuel Ortiz <sameo@linux.intel.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>
Subject: Re: [PATCH 1/2] mfd: mc13xxx: Do not use platform data with
 devicetree
Message-ID: <20140509113030.GV5767@lee--X1>
References: <1398926883-21778-1-git-send-email-shc_work@mail.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1398926883-21778-1-git-send-email-shc_work@mail.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This patch removes platform data usage for codec and touchscreen
> when driver is used with devicetree.
> This fixes possible "null pointer dereference" error if DTS uses
> "fsl,mc13xxx-uses-codec" or "fsl,mc13xxx-uses-touch" options.
> 
> Signed-off-by: Alexander Shiyan <shc_work@mail.ru>
> ---
>  drivers/mfd/mc13xxx-core.c | 18 ++++++++++--------
>  1 file changed, 10 insertions(+), 8 deletions(-)

Applied, thanks.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog

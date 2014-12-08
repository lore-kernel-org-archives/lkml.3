Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754497AbaLHIOr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 03:14:47 -0500
Received: from mail-qa0-f50.google.com ([209.85.216.50]:45638 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754467AbaLHIOp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 03:14:45 -0500
Date: Mon, 8 Dec 2014 08:14:39 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Athira Lekshmi <andnlnbn18@gmail.com>
Cc: rogerable@realtek.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] Drivers: memstick: host: Fixed missing a blank line
 warning
Message-ID: <20141208081439.GA3951@x1>
References: <1417943669-4057-1-git-send-email-andnlnbn18@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1417943669-4057-1-git-send-email-andnlnbn18@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not a bad attempt.

The subject line should match the subsystem.  You can see what that is
by issuing `git log --oneline -- drivers/memstick/` (supplement
drivers/memstick for the subsystem that you're submitting to).

> Added a new line after declaration to fix the warning message
> 'Missing a blank line after declarations'
> 
> Signed-off-by: Athira Lekshmi <andnlnbn18@gmail.com>
> ---
>  drivers/memstick/host/rtsx_usb_ms.c |    1 +
>  1 file changed, 1 insertion(+)

Apart from my comment at the top (which a kind maintainer can fix for
you on this occasion I'm sure ;) ), the patch looks good:

Acked-by: Lee Jones <lee.jones@linaro.org>

Now make 3 such changes (you can use checkpatch on some other files)
and send them as a patch-set.

> diff --git a/drivers/memstick/host/rtsx_usb_ms.c b/drivers/memstick/host/rtsx_usb_ms.c
> index a7282b7..cefd745 100644
> --- a/drivers/memstick/host/rtsx_usb_ms.c
> +++ b/drivers/memstick/host/rtsx_usb_ms.c
> @@ -59,6 +59,7 @@ static inline struct device *ms_dev(struct rtsx_usb_ms *host)
>  static inline void ms_clear_error(struct rtsx_usb_ms *host)
>  {
>  	struct rtsx_ucr *ucr = host->ucr;
> +
>  	rtsx_usb_ep0_write_register(ucr, CARD_STOP,
>  				  MS_STOP | MS_CLR_ERR,
>  				  MS_STOP | MS_CLR_ERR);

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog

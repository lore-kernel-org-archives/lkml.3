Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753579Ab3F3AcO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Jun 2013 20:32:14 -0400
Received: from mail-we0-f175.google.com ([74.125.82.175]:45643 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751735Ab3F3AcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Jun 2013 20:32:12 -0400
MIME-Version: 1.0
X-Originating-IP: [95.23.49.74]
In-Reply-To: <20130629165304.GA26993@raspi>
References: <20130629165304.GA26993@raspi>
Date: Sun, 30 Jun 2013 02:32:10 +0200
Message-ID: <CABxcv=kFK--BMVqn4W=AKDxKw=nvGzqH3VVBSC5qyu5=wjvSmg@mail.gmail.com>
Subject: Re: [RESEND][PATCH] cyttsp: Fix swap of mfg_stat and mfg_cmd registers
From: Javier Martinez Canillas <javier@dowhile0.org>
To: Matthias Kaehlcke <matthias.list@kaehlcke.net>,
        Javier Martinez Canillas <javier@dowhile0.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Kevin McNeely <kev@cypress.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 29, 2013 at 6:53 PM, Matthias Kaehlcke
<matthias.list@kaehlcke.net> wrote:
> The command and status register in the driver were swapped with
> respect to the order specified in the datasheet (CY8CTMA140).
> Confirmed with Cypress that the order in the datasheet is correct.
>
> Signed-off-by: Matthias Kaehlcke <matthias@kaehlcke.net>
> Acked-by: Javier Martinez Canillas <javier@dowhile0.org>
> Acked-by: Ferruh Yigit <fery@cypress.com>
>
> ---
>  drivers/input/touchscreen/cyttsp_core.h |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/input/touchscreen/cyttsp_core.h b/drivers/input/touchscreen/cyttsp_core.h
> index 1aa3c69..f1ebde3 100644
> --- a/drivers/input/touchscreen/cyttsp_core.h
> +++ b/drivers/input/touchscreen/cyttsp_core.h
> @@ -67,8 +67,8 @@ struct cyttsp_xydata {
>  /* TTSP System Information interface definition */
>  struct cyttsp_sysinfo_data {
>         u8 hst_mode;
> -       u8 mfg_cmd;
>         u8 mfg_stat;
> +       u8 mfg_cmd;
>         u8 cid[3];
>         u8 tt_undef1;
>         u8 uid[8];
> --
> 1.7.10.4
>
> --

Hi Matthias,

This patch has already been merged in Linus tree a few days ago with
commit ID d3bf073aa.

Thanks a lot and best regards,
Javier

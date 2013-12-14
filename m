Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754317Ab3LNU6A (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 15:58:00 -0500
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:42226 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754185Ab3LNU56 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 15:57:58 -0500
X-Originating-IP: 50.43.14.201
Date: Sat, 14 Dec 2013 12:57:52 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: Rashika Kheria <rashika.kheria@gmail.com>
Cc: linux-kernel@vger.kernel.org, Ferruh Yigit <fery@cypress.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org
Subject: Re: [PATCH] drivers: input: Include appropriate header file in
 cyttsp_i2c_common.c
Message-ID: <20131214205752.GS17601@leaf>
References: <20131214133822.GA13124@rashika>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20131214133822.GA13124@rashika>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 14, 2013 at 07:08:22PM +0530, Rashika Kheria wrote:
> This patch includes appropriate header file cyttsp4_core.h in
> touchscreen/cyttsp_i2c_common.c because functions
> cyttsp_i2c_read_block_data() and cyttsp_i2c_write_block_data()
> have their prototype declaration in cyttsp4_core.h.
> 
> Thus, it also eliminates the following warning in cyttsp_i2c_common.c:
> drivers/input/touchscreen/cyttsp_i2c_common.c:34:5: warning: no previous prototype for ‘cyttsp_i2c_read_block_data’ [-Wmissing-prototypes]
> drivers/input/touchscreen/cyttsp_i2c_common.c:64:5: warning: no previous prototype for ‘cyttsp_i2c_write_block_data’ [-Wmissing-prototypes]
> 
> 
> Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>

Reviewed-by: Josh Triplett <josh@joshtriplett.org>

>  drivers/input/touchscreen/cyttsp_i2c_common.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/input/touchscreen/cyttsp_i2c_common.c b/drivers/input/touchscreen/cyttsp_i2c_common.c
> index 1d7b6f1..ccefa56 100644
> --- a/drivers/input/touchscreen/cyttsp_i2c_common.c
> +++ b/drivers/input/touchscreen/cyttsp_i2c_common.c
> @@ -31,6 +31,8 @@
>  #include <linux/module.h>
>  #include <linux/types.h>
>  
> +#include "cyttsp4_core.h"
> +
>  int cyttsp_i2c_read_block_data(struct device *dev, u8 *xfer_buf,
>  				      u16 addr, u8 length, void *values)
>  {
> -- 
> 1.7.9.5
> 

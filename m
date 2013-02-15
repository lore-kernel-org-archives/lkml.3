Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757881Ab3BOOcd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 09:32:33 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:36147 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755349Ab3BOOcc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 09:32:32 -0500
Subject: Re: [PATCH] regulator: twl: Remove VDD1_VSEL_table and
 VDD2_VSEL_table
From: Tero Kristo <t-kristo@ti.com>
Reply-To: <t-kristo@ti.com>
To: Axel Lin <axel.lin@ingics.com>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Liam Girdwood <lgirdwood@gmail.com>, <linux-kernel@vger.kernel.org>
In-Reply-To: <1360938181.7815.1.camel@phoenix>
References: <1360938181.7815.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
Organization: Texas Instruments
Date: Fri, 15 Feb 2013 16:32:18 +0200
Message-ID: <1360938738.2495.146.camel@sokoban>
MIME-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks good to me. Ack.

On Fri, 2013-02-15 at 22:23 +0800, Axel Lin wrote:
> Since commit ba305e31 "regulator: twl: fix twl4030 support for smps regulators",
> VDD1_VSEL_table and VDD2_VSEL_table are not used any more. Remove them.
> 
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
> ---
>  drivers/regulator/twl-regulator.c |    6 ------
>  1 file changed, 6 deletions(-)
> 
> diff --git a/drivers/regulator/twl-regulator.c b/drivers/regulator/twl-regulator.c
> index 74508cc..683d314 100644
> --- a/drivers/regulator/twl-regulator.c
> +++ b/drivers/regulator/twl-regulator.c
> @@ -441,12 +441,6 @@ static const u16 VSIM_VSEL_table[] = {
>  static const u16 VDAC_VSEL_table[] = {
>  	1200, 1300, 1800, 1800,
>  };
> -static const u16 VDD1_VSEL_table[] = {
> -	800, 1450,
> -};
> -static const u16 VDD2_VSEL_table[] = {
> -	800, 1450, 1500,
> -};
>  static const u16 VIO_VSEL_table[] = {
>  	1800, 1850,
>  };



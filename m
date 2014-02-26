Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751720AbaBZCKG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 21:10:06 -0500
Received: from mail-ie0-f170.google.com ([209.85.223.170]:46880 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751010AbaBZCKF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 21:10:05 -0500
MIME-Version: 1.0
In-Reply-To: <003001cf3291$293db3b0$7bb91b10$%han@samsung.com>
References: <002e01cf3290$ccda9430$668fbc90$%han@samsung.com>
	<003001cf3291$293db3b0$7bb91b10$%han@samsung.com>
Date: Wed, 26 Feb 2014 10:10:03 +0800
Message-ID: <CAN1soZyc-YGB5qFL3tgHVY1ANMg8-jF=2n8dOy-MJe2awR1yMw@mail.gmail.com>
Subject: Re: [PATCH 3/3] regulator: 88pm8607: fix indent code style
From: Haojian Zhuang <haojian.zhuang@gmail.com>
To: Jingoo Han <jg1.han@samsung.com>
Cc: Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 26, 2014 at 9:22 AM, Jingoo Han <jg1.han@samsung.com> wrote:
> Fix indent code style in order to fix the following checkpatch
> issues.
>
>   ERROR: code indent should use tabs where possible
>   WARNING: please, no space before tabs
>   WARNING: please, no spaces at the start of a line
>
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> ---
>  drivers/regulator/88pm8607.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/regulator/88pm8607.c b/drivers/regulator/88pm8607.c
> index fa99bfc..337634a 100644
> --- a/drivers/regulator/88pm8607.c
> +++ b/drivers/regulator/88pm8607.c
> @@ -2,7 +2,7 @@
>   * Regulators driver for Marvell 88PM8607
>   *
>   * Copyright (C) 2009 Marvell International Ltd.
> - *     Haojian Zhuang <haojian.zhuang@marvell.com>
> + *     Haojian Zhuang <haojian.zhuang@marvell.com>
>   *
>   * This program is free software; you can redistribute it and/or modify
>   * it under the terms of the GNU General Public License version 2 as
> @@ -78,7 +78,7 @@ static const unsigned int BUCK2_suspend_table[] = {
>  };
>
>  static const unsigned int BUCK3_table[] = {
> -              0,   25000,   50000,   75000,  100000,  125000,  150000,  175000,
> +             0,   25000,   50000,   75000,  100000,  125000,  150000,  175000,
>          200000,  225000,  250000,  275000,  300000,  325000,  350000,  375000,
>          400000,  425000,  450000,  475000,  500000,  525000,  550000,  575000,
>          600000,  625000,  650000,  675000,  700000,  725000,  750000,  775000,
> @@ -89,7 +89,7 @@ static const unsigned int BUCK3_table[] = {
>  };
>
>  static const unsigned int BUCK3_suspend_table[] = {
> -              0,   25000,   50000,   75000,  100000,  125000,  150000,  175000,
> +             0,   25000,   50000,   75000,  100000,  125000,  150000,  175000,
>          200000,  225000,  250000,  275000,  300000,  325000,  350000,  375000,
>          400000,  425000,  450000,  475000,  500000,  525000,  550000,  575000,
>          600000,  625000,  650000,  675000,  700000,  725000,  750000,  775000,
> --
> 1.7.10.4
>
>

Acked-by: Haojian Zhuang <haojian.zhuang@gmail.com>

Regards
Haojian

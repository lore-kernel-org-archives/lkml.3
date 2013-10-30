Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752731Ab3J3QV4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 12:21:56 -0400
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:31426 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751305Ab3J3QVy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 12:21:54 -0400
Date: Wed, 30 Oct 2013 17:21:42 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Wei Ni <wni@nvidia.com>
Cc: <linux@roeck-us.net>, <lm-sensors@lm-sensors.org>,
        <linux-kernel@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH v4 3/3] hwmon: (lm90) use enums for the indexes of temp8
 and temp11
Message-ID: <20131030172142.49234b28@endymion.delvare>
In-Reply-To: <1375856306-14415-4-git-send-email-wni@nvidia.com>
References: <1375856306-14415-1-git-send-email-wni@nvidia.com>
	<1375856306-14415-4-git-send-email-wni@nvidia.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wei,

On Wed, 7 Aug 2013 14:18:26 +0800, Wei Ni wrote:
> Using enums for the indexes and nrs of temp8 and temp11.
> This make the code much more readable.
> 
> Signed-off-by: Wei Ni <wni@nvidia.com>
> ---
>  drivers/hwmon/lm90.c |  154 +++++++++++++++++++++++++++++---------------------
>  1 file changed, 90 insertions(+), 64 deletions(-)
> (...)

Looks much better except for one minor detail:

> +/*
> + * TEMP11 register index
> + */
> +enum lm90_temp11_reg_index {
> +	REMOTE_TEMP = 0,
> +	REMOTE_LOW,
> +	REMOTE_HIGH,
> +	REMOTE_OFFSET,	/* except max6646, max6657/58/59,
> +			 *  and max6695/96
> +			 */

This comment fits on a single line now.

> +	LOCAL_TEMP,
> +	REMOTE2_TEMP,	/* max6695/96 only */
> +	REMOTE2_LOW,	/* max6695/96 only */
> +	REMOTE2_HIGH,	/* max6695/96 only */
> +	TEMP11_REG_NUM
> +};

Other than that, it's OK, and I think I'll apply it after all.

-- 
Jean Delvare

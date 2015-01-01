Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752024AbbAANvt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2015 08:51:49 -0500
Received: from mout.gmx.net ([212.227.15.15]:56975 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751518AbbAANvq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2015 08:51:46 -0500
Message-ID: <54A550E7.7040808@gmx.de>
Date: Thu, 01 Jan 2015 14:51:35 +0100
From: Hartmut Knaack <knaack.h@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:34.0) Gecko/20100101 Firefox/34.0 SeaMonkey/2.31
MIME-Version: 1.0
To: Daniel Baluta <daniel.baluta@intel.com>, jic23@kernel.org
CC: lars@metafoo.de, pmeerw@pmeerw.net, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org, srinivas.pandruvada@linux.intel.com
Subject: Re: [PATCH 08/10] iio: imu: kmx61: Remove unnecessary REG_INS1 read
References: <1419340953-23161-1-git-send-email-daniel.baluta@intel.com> <1419340953-23161-9-git-send-email-daniel.baluta@intel.com>
In-Reply-To: <1419340953-23161-9-git-send-email-daniel.baluta@intel.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:0ble6xqoL4X4LgRsL7xMf/Il2PnGe+gOOKRbjF+ZmyvMdBKCXhO
 ibEKS/ut2JScBxrQqefmggfum9EhiaPQTGqOjjS8VcnJi/HcHPEv55ULw6kbzTJG3T7rf9W
 9LkVxxQ6Kewjxr18+7bc/Bl5o1eoc5fAu/YBOyn72ZfjmePbVKmoCRHx0xzzLnHx9dkSA30
 Ejre3LMU/sr7te5XkX0Ew==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Baluta schrieb am 23.12.2014 um 14:22:
> Useful in the debugging phase, not needed now.
> 
> Signed-off-by: Daniel Baluta <daniel.baluta@intel.com>
Acked-by: Hartmut Knaack <knaack.h@gmx.de>
> ---
>  drivers/iio/imu/kmx61.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/drivers/iio/imu/kmx61.c b/drivers/iio/imu/kmx61.c
> index 5b5be2b..eb3900e 100644
> --- a/drivers/iio/imu/kmx61.c
> +++ b/drivers/iio/imu/kmx61.c
> @@ -1196,8 +1196,6 @@ ack_intr:
>  	if (ret < 0)
>  		dev_err(&data->client->dev, "Error reading reg_inl\n");
>  
> -	ret = i2c_smbus_read_byte_data(data->client, KMX61_REG_INS1);
> -
>  	return IRQ_HANDLED;
>  }
>  
> 


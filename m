Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751762AbaLQWSe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 17:18:34 -0500
Received: from mout.gmx.net ([212.227.17.22]:57091 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751735AbaLQWSc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 17:18:32 -0500
Message-ID: <5492012C.3070206@gmx.de>
Date: Wed, 17 Dec 2014 23:18:20 +0100
From: Hartmut Knaack <knaack.h@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:34.0) Gecko/20100101 Firefox/34.0 SeaMonkey/2.31
MIME-Version: 1.0
To: Karol Wrona <k.wrona@samsung.com>, Jonathan Cameron <jic23@kernel.org>,
        linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org
CC: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Karol Wrona <wrona.vy@gmail.com>
Subject: Re: [PATCH v3 4/5] iio: common: ssp_sensors: Add sensorhub
 accelerometer sensor
References: <1417809290-9662-1-git-send-email-k.wrona@samsung.com> <1417809290-9662-5-git-send-email-k.wrona@samsung.com>
In-Reply-To: <1417809290-9662-5-git-send-email-k.wrona@samsung.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:TcJ6mjYhY4vMKLeqo/Hzgwha+P2RrdwV1wlmsu5viaBOggpqD+z
 H+zUt9ePqUhNIetV03x8RRCbHkwwslgUSZY/KzXMAj3mDlRLy1FWFT8lqTyZ0YJdL+Kb7ne
 zt193MGENV6RzFk0/mC2Xi/fZexuBzgEIl0+YTPyLwN2t0d5dCefI60HdpbIdCFlyblr+EE
 YLB32eXyzQi2h1UgrmyoQ==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Karol Wrona schrieb am 05.12.2014 um 20:54:
> This patch adds accelerometer iio driver which uses sensorhub as data
> provider.
> 
Also looking very good now. One more whitespace issue remaining.
> Change-Id: I4686741b7401ec5cbf4b5d0f2a5cc146fbe24d53
> Signed-off-by: Karol Wrona <k.wrona@samsung.com>
> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  drivers/iio/accel/Makefile           |    1 +
>  drivers/iio/accel/ssp_accel_sensor.c |  203 ++++++++++++++++++++++++++++++++++
>  2 files changed, 204 insertions(+)
>  create mode 100644 drivers/iio/accel/ssp_accel_sensor.c
> 

> +static struct platform_driver ssp_accel_driver = {
> +	.driver = {
> +		.owner = THIS_MODULE,
> +		.name = SSP_ACCEL_NAME,
> +		.of_match_table = ssp_accel_id_table,
> +	},
> +	.probe = ssp_accel_probe,
> +	.remove =  ssp_accel_remove,
Double whitespace.
> +};
> +
> +module_platform_driver(ssp_accel_driver);
> +
> +MODULE_AUTHOR("Karol Wrona <k.wrona@samsung.com>");
> +MODULE_DESCRIPTION("Samsung sensorhub accelerometers driver");
> +MODULE_LICENSE("GPL");
> 


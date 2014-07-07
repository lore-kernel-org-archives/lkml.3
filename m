Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753115AbaGGM2I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 08:28:08 -0400
Received: from mail.kernel.org ([198.145.19.201]:57185 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752652AbaGGM2H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 08:28:07 -0400
Message-ID: <53BA92DA.7070304@kernel.org>
Date: Mon, 07 Jul 2014 13:30:18 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Daniel Baluta <daniel.baluta@intel.com>
CC: srinivas.pandruvada@linux.intel.com, archana.patni@linux.intel.com,
        subramony.sesha@intel.com, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] iio: hid-sensors: make hid_sensor_get_reporting_interval
 static
References: <1404120584-11795-1-git-send-email-daniel.baluta@intel.com>
In-Reply-To: <1404120584-11795-1-git-send-email-daniel.baluta@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30/06/14 10:29, Daniel Baluta wrote:
> This fixes the following sparse warning:
>
>    CHECK   drivers/iio/common/hid-sensors/hid-sensor-attributes.c
> drivers/iio/common/hid-sensors/hid-sensor-attributes.c:346:5: warning:
> symbol 'hid_sensor_get_reporting_interval' was not declared. Should it be static?
>
> Signed-off-by: Daniel Baluta <daniel.baluta@intel.com>
Applied to the togreg branch of iio.git, initially pushed out as testing
for the autobuilders to play.  Thanks,

Jonathan
> ---
>   drivers/iio/common/hid-sensors/hid-sensor-attributes.c | 1 +
>   1 file changed, 1 insertion(+)
>
> diff --git a/drivers/iio/common/hid-sensors/hid-sensor-attributes.c b/drivers/iio/common/hid-sensors/hid-sensor-attributes.c
> index 403dd3d..8220df1 100644
> --- a/drivers/iio/common/hid-sensors/hid-sensor-attributes.c
> +++ b/drivers/iio/common/hid-sensors/hid-sensor-attributes.c
> @@ -343,6 +343,7 @@ int hid_sensor_format_scale(u32 usage_id,
>   }
>   EXPORT_SYMBOL(hid_sensor_format_scale);
>
> +static
>   int hid_sensor_get_reporting_interval(struct hid_sensor_hub_device *hsdev,
>   					u32 usage_id,
>   					struct hid_sensor_common *st)
>


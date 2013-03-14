Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756678Ab3CNKYJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 06:24:09 -0400
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:22817 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755973Ab3CNKYH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 06:24:07 -0400
Date: Thu, 14 Mar 2013 11:23:54 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Guenter Roeck <linux@roeck-us.net>, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hwmon: lineage-pem: Add missing terminating entry for 
 pem_[input|fan]_attributes
Message-ID: <20130314112354.31396c51@endymion.delvare>
In-Reply-To: <1363249638.15861.1.camel@phoenix>
References: <1363249638.15861.1.camel@phoenix>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Axel,

On Thu, 14 Mar 2013 16:27:18 +0800, Axel Lin wrote:
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
> ---
>  drivers/hwmon/lineage-pem.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/hwmon/lineage-pem.c b/drivers/hwmon/lineage-pem.c
> index 41df29f..ebbb9f4 100644
> --- a/drivers/hwmon/lineage-pem.c
> +++ b/drivers/hwmon/lineage-pem.c
> @@ -422,6 +422,7 @@ static struct attribute *pem_input_attributes[] = {
>  	&sensor_dev_attr_in2_input.dev_attr.attr,
>  	&sensor_dev_attr_curr1_input.dev_attr.attr,
>  	&sensor_dev_attr_power1_input.dev_attr.attr,
> +	NULL
>  };
>  
>  static const struct attribute_group pem_input_group = {
> @@ -432,6 +433,7 @@ static struct attribute *pem_fan_attributes[] = {
>  	&sensor_dev_attr_fan1_input.dev_attr.attr,
>  	&sensor_dev_attr_fan2_input.dev_attr.attr,
>  	&sensor_dev_attr_fan3_input.dev_attr.attr,
> +	NULL
>  };
>  
>  static const struct attribute_group pem_fan_group = {

Good catch.

Acked-by: Jean Delvare <khali@linux-fr.org>

I'll let Guenter pick the fix as this is his driver. This should go to
stable too.

-- 
Jean Delvare

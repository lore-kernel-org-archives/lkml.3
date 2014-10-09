Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752108AbaJJXqz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 19:46:55 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:50151 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751795AbaJJXqu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 19:46:50 -0400
Message-ID: <5436E567.6070403@kernel.org>
Date: Thu, 09 Oct 2014 20:43:35 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Darshana Padmadas <darshanapadmadas@gmail.com>,
        opw-kernel@googlegroups.com
CC: grant.likely@linaro.org, robh+dt@kernel.org, pawel.moll@arm.com,
        linux-arm-kernel@lists.infradead.org, linux-iio@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 3/4] Staging: iio: light: Added correct vendor-prefix
 for device isl29028
References: <1412695169-22815-1-git-send-email-darshanapadmadas@gmail.com> <1412695169-22815-4-git-send-email-darshanapadmadas@gmail.com>
In-Reply-To: <1412695169-22815-4-git-send-email-darshanapadmadas@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/10/14 16:19, Darshana Padmadas wrote:
> This patch adds the correct vendor-prefix for device isl29028 and
> maintains deprecated vendor-prefix found by checkpatch warning
> for older kernel releases.
> 
> Signed-off-by: Darshana Padmadas <darshanapadmadas@gmail.com>
Acked-by: Jonathan Cameron <jic23@kernel.org>

Which tree does this series want to go through?
(I'm happy to take it via IIO once the outstanding issues are cleaned up
if no one else wants it).

> ---
>  drivers/staging/iio/light/isl29028.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/iio/light/isl29028.c b/drivers/staging/iio/light/isl29028.c
> index 6014625..e969107 100644
> --- a/drivers/staging/iio/light/isl29028.c
> +++ b/drivers/staging/iio/light/isl29028.c
> @@ -537,7 +537,8 @@ static const struct i2c_device_id isl29028_id[] = {
>  MODULE_DEVICE_TABLE(i2c, isl29028_id);
>  
>  static const struct of_device_id isl29028_of_match[] = {
> -	{ .compatible = "isil,isl29028", },
> +	{ .compatible = "isl,isl29028", },
> +	{ .compatible = "isil,isl29028", },/* deprecated, don't use */
>  	{ },
>  };
>  MODULE_DEVICE_TABLE(of, isl29028_of_match);
> 

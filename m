Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754188AbaA0Smr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 13:42:47 -0500
Received: from gloria.sntech.de ([95.129.55.99]:37918 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754017AbaA0Smq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 13:42:46 -0500
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Luis Ortega <luiorpe1@upv.es>
Cc: dmitry.torokhov@gmail.com, yongjun_wei@trendmicro.com.cn,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] Input: zforce - fix spelling errors
Date: Mon, 27 Jan 2014 19:41:52 +0100
Message-ID: <1778950.Yzcf1IeZVD@phil>
User-Agent: KMail/4.11.3 (Linux/3.11-2-amd64; KDE/4.11.3; x86_64; ; )
In-Reply-To: <1390848373-7723-2-git-send-email-luiorpe1@upv.es>
References: <1390848373-7723-1-git-send-email-luiorpe1@upv.es> <1390848373-7723-2-git-send-email-luiorpe1@upv.es>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 27. January 2014 19:46:10 Luis Ortega wrote:
> Fixed a few spelling errors.
> 
> Signed-off-by: Luis Ortega <luiorpe1@upv.es>

Acked-by: Heiko Stuebner <heiko@sntech.de>

> ---
>  drivers/input/touchscreen/zforce_ts.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/input/touchscreen/zforce_ts.c
> b/drivers/input/touchscreen/zforce_ts.c index 2175f34..c145c1d 100644
> --- a/drivers/input/touchscreen/zforce_ts.c
> +++ b/drivers/input/touchscreen/zforce_ts.c
> @@ -64,7 +64,7 @@
>  #define RESPONSE_STATUS		0X1e
> 
>  /*
> - * Notifications are send by the touch controller without
> + * Notifications are sent by the touch controller without
>   * being requested by the driver and include for example
>   * touch indications
>   */
> @@ -103,8 +103,8 @@ struct zforce_point {
>   * @suspended		device suspended
>   * @access_mutex	serialize i2c-access, to keep multipart reads together
>   * @command_done	completion to wait for the command result
> - * @command_mutex	serialize commands send to the ic
> - * @command_waiting	the id of the command that that is currently waiting
> + * @command_mutex	serialize commands sent to the ic
> + * @command_waiting	the id of the command that is currently waiting
>   *			for a result
>   * @command_result	returned result of the command
>   */
> @@ -332,7 +332,7 @@ static int zforce_touch_event(struct zforce_ts *ts, u8
> *payload)
> 
>  	count = payload[0];
>  	if (count > ZFORCE_REPORT_POINTS) {
> -		dev_warn(&client->dev, "to many coordinates %d, expected max %d\n",
> +		dev_warn(&client->dev, "too many coordinates %d, expected max %d\n",
>  			 count, ZFORCE_REPORT_POINTS);
>  		count = ZFORCE_REPORT_POINTS;
>  	}
> @@ -798,7 +798,7 @@ static int zforce_probe(struct i2c_client *client,
>  		return ret;
>  	}
> 
> -	/* this gets the firmware version among other informations */
> +	/* this gets the firmware version among other information */
>  	ret = zforce_command_wait(ts, COMMAND_STATUS);
>  	if (ret < 0) {
>  		dev_err(&client->dev, "couldn't get status, %d\n", ret);


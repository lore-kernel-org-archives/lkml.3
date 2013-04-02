Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760915Ab3DBHPA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 03:15:00 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:56109 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759909Ab3DBHO7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 03:14:59 -0400
Message-ID: <515A856E.1000402@ti.com>
Date: Tue, 2 Apr 2013 09:14:54 +0200
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130328 Thunderbird/17.0.4
MIME-Version: 1.0
To: Axel Lin <axel.lin@ingics.com>
CC: Thierry Reding <thierry.reding@avionic-design.de>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] pwm: twl: Return proper error if twl6030_pwm_enable()
 fails
References: <1364742450.3834.8.camel@phoenix>
In-Reply-To: <1364742450.3834.8.camel@phoenix>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/31/2013 05:07 PM, Axel Lin wrote:
> Return proper error instead of 0 if twl6030_pwm_enable() fails.
> 
> Signed-off-by: Axel Lin <axel.lin@ingics.com>

Acked-by: Peter Ujfalusi <peter.ujfalusi@ti.com>

> ---
>  drivers/pwm/pwm-twl.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/pwm/pwm-twl.c b/drivers/pwm/pwm-twl.c
> index ee7fa5d..2782001 100644
> --- a/drivers/pwm/pwm-twl.c
> +++ b/drivers/pwm/pwm-twl.c
> @@ -248,7 +248,7 @@ static int twl6030_pwm_enable(struct pwm_chip *chip, struct pwm_device *pwm)
>  	twl->twl6030_toggle3 = val;
>  out:
>  	mutex_unlock(&twl->mutex);
> -	return 0;
> +	return ret;
>  }
>  
>  static void twl6030_pwm_disable(struct pwm_chip *chip, struct pwm_device *pwm)
> 


-- 
Péter

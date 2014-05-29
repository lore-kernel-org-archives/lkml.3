Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755340AbaE2Bo4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 21:44:56 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:17930 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755295AbaE2Boy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 21:44:54 -0400
X-AuditID: cbfee691-b7f2f6d0000040c4-05-538691148f88
From: Jingoo Han <jg1.han@samsung.com>
To: "'Emil Goode'" <emilgoode@gmail.com>, "'Lee Jones'" <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        "'Samuel Ortiz'" <sameo@linux.intel.com>,
        "'Trilok Soni'" <tsoni@codeaurora.org>,
        "'Tony Lindgren'" <tony@atomide.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <1401295431-23833-1-git-send-email-emilgoode@gmail.com>
In-reply-to: <1401295431-23833-1-git-send-email-emilgoode@gmail.com>
Subject: Re: [PATCH v2] mfd: fix unintentional NULL check in
 menelaus_set_voltage()
Date: Thu, 29 May 2014 10:44:51 +0900
Message-id: <000d01cf7adf$9528f9e0$bf7aeda0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac96k/cDrVJYdeJ6TP6vs/63/GYxegASKqog
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrDIsWRmVeSWpSXmKPExsVy+t8zI12RiW3BBtcfM1m0PFnEbnF54SVW
	i623pC3ufz3KaHF51xw2i9PdrBb7r3hZ7Ps8h9GBw+Pb10ksHpf7epk8ds66y+5x59oeNo95
	JwM9+rasYvT4vEkugD2KyyYlNSezLLVI3y6BK2PHsd/MBee4K5oX/2FuYJzC2cXIySEhYCLx
	9PdCJghbTOLCvfVsXYxcHEICyxglvtx6xQJT9KDzFSNEYhGjROPBTmYI5zejxMKti9hAqtgE
	1CS+fDnMDmKLCHhJ7Np5H2wUs8BtRok7P26AFQkJOEu0TlgIZnMKuEhM/vOeFcQWFgiVePO1
	E6yZRUBVYs7EtWA2r4CtxJant9ggbEGJH5PvgZ3ELKAlsX7ncSYIW15i85q3QBdxAJ2qLvHo
	ry6IKSJgJLH0eShEhYjEvhfvGCGe+csuMe1RDsQmAYlvkw+xQHTKSmw6wAxRIilxcMUNlgmM
	ErOQ7J2FZO8sJHtnIdmwgJFlFaNoakFyQXFSepGpXnFibnFpXrpecn7uJkZITE/cwXj/gPUh
	xmSg9ROZpUST84EpIa8k3tDYzMjC1MTU2Mjc0ow0YSVx3vRHSUFCAumJJanZqakFqUXxRaU5
	qcWHGJk4OKUaGG14HRRmnMmrP+SxOeSDKeNZRf+Pk7788Z5c6Xwn+Hvwg/XbNNiCba+HXxbq
	m36bdbK6geLuqZen/H7bNP+N/XqrSS0ZF6xvfTjmuixbQMk0x/aYZQvDaxX1TUkrCxM/X5TZ
	ev2gdKqSB+NK9zfK8/YyKOvZNP8QyHy3ZP6mCim9TSk3nI7GtSqxFGckGmoxFxUnAgBALElW
	/wIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFKsWRmVeSWpSXmKPExsVy+t9jAV3hiW3BBp1brS1anixit7i88BKr
	xdZb0hb3vx5ltLi8aw6bxeluVov9V7ws9n2ew+jA4fHt6yQWj8t9vUweO2fdZfe4c20Pm8e8
	k4EefVtWMXp83iQXwB7VwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8cb2pmYKhraGlhrqSQl5ib
	aqvk4hOg65aZA3SSkkJZYk4pUCggsbhYSd8O04TQEDddC5jGCF3fkCC4HiMDNJCwjjFjx7Hf
	zAXnuCuaF/9hbmCcwtnFyMkhIWAi8aDzFSOELSZx4d56ti5GLg4hgUWMEo0HO5khnN+MEgu3
	LmIDqWITUJP48uUwO4gtIuAlsWvnfbAOZoHbjBJ3ftwAKxIScJZonbAQzOYUcJGY/Oc9K4gt
	LBAq8eZrJ1gzi4CqxJyJa8FsXgFbiS1Pb7FB2IISPybfYwGxmQW0JNbvPM4EYctLbF7zFugi
	DqBT1SUe/dUFMUUEjCSWPg+FqBCR2PfiHeMERqFZSAbNQjJoFpJBs5C0LGBkWcUomlqQXFCc
	lJ5rpFecmFtcmpeul5yfu4kRnDKeSe9gXNVgcYhRgINRiYdXQrYtWIg1say4MvcQowQHs5II
	r0Y4UIg3JbGyKrUoP76oNCe1+BBjMtCfE5mlRJPzgeksryTe0NjEzMjSyMzCyMTcnDRhJXHe
	g63WgUIC6YklqdmpqQWpRTBbmDg4pRoYJec6LLcPqwhnuO0+RXnWhIbUyjcfeyof/ldO/vZE
	N2G3Eee/2ovWF01Nj7om77tYco5VPFxkY3qoa/s90WA38Un6SnecvFYsdl3h/Mn/9Pk3IRGP
	uhfLRMld1361sLTwhj7z9HWfHK4n5TBP9w+VzGaVqTxyQPHF9CN2DtKSzjnXOmbw7GhRYinO
	SDTUYi4qTgQA6aepCF0DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, May 29, 2014 1:44 AM, Emil Goode wrote:
> 
> The struct menelaus_vtg pointer vtg cannot be NULL here
> so the condition is never true and if it ever was true
> it would lead to a NULL pointer dereference when we goto
> label set_voltage.
> 
> Before the below patch was applied the code was:
> 
> if (vtg == 0)
> 
> The intention was to check if vtg_val is 0.
> 
> commit 59a9f7a32adf6537b4e4db8ca204eeb77d7a634e
> ("mfd: menelaus: Use NULL instead of 0")
> 
> Signed-off-by: Emil Goode <emilgoode@gmail.com>
> ---
> v2: Changed (vtg_val == 0) to (!vtg_val)
> 
>  drivers/mfd/menelaus.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/mfd/menelaus.c b/drivers/mfd/menelaus.c
> index ad25bfa..40df76a 100644
> --- a/drivers/mfd/menelaus.c
> +++ b/drivers/mfd/menelaus.c
> @@ -466,7 +466,7 @@ static int menelaus_set_voltage(const struct menelaus_vtg *vtg, int mV,
>  	struct i2c_client *c = the_menelaus->client;
> 
>  	mutex_lock(&the_menelaus->lock);
> -	if (!vtg)
> +	if (!vtg_val)
>  		goto set_voltage;

(+cc Trilok Soni, Tony Lindgren)

In this case, if 'vtg_val' is 0, setting voltage as 0 for
registers such as MENELAUS_xxx_CTRLx will be skipped. So,
it is not possible to set the voltage value as 0.

Is it right? If not, how about just removing this check and
the label 'set_voltage'?

Best regards,
Jingoo Han

> 
>  	ret = menelaus_read_reg(vtg->vtg_reg);
> --
> 1.7.10.4


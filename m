Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761895Ab3DBREh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 13:04:37 -0400
Received: from 5.mo1.mail-out.ovh.net ([178.33.45.107]:40549 "EHLO
	mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761781Ab3DBREe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 13:04:34 -0400
X-Greylist: delayed 2339 seconds by postgrey-1.27 at vger.kernel.org; Tue, 02 Apr 2013 13:04:34 EDT
Message-ID: <515B067A.1060909@overkiz.com>
Date: Tue, 02 Apr 2013 18:25:30 +0200
From: Boris BREZILLON <linux-arm@overkiz.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Axel Lin <axel.lin@ingics.com>
CC: Thierry Reding <thierry.reding@avionic-design.de>,
        linux-kernel@vger.kernel.org
X-Ovh-Mailout: 178.32.228.1 (mo1.mail-out.ovh.net)
Subject: Re: [PATCH 2/4] pwm: atmel-tcb: Add .owner to struct pwm_ops
References: <1364699642.7876.1.camel@phoenix> <1364699715.7876.3.camel@phoenix>
In-Reply-To: <1364699715.7876.3.camel@phoenix>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 530017381518914566
X-Ovh-Remote: 80.245.18.66 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiuddrkeejucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiuddrkeejucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31/03/2013 05:15, Axel Lin wrote:
> Add missing .owner of struct pwm_ops. This prevents the module from being
> removed from underneath its users.
>
> Signed-off-by: Axel Lin <axel.lin@ingics.com>

Acked-by: Boris BREZILLON <linux-arm@overkiz.com>

> ---
>   drivers/pwm/pwm-atmel-tcb.c |    1 +
>   1 file changed, 1 insertion(+)
>
> diff --git a/drivers/pwm/pwm-atmel-tcb.c b/drivers/pwm/pwm-atmel-tcb.c
> index 16cb530..0a7b658 100644
> --- a/drivers/pwm/pwm-atmel-tcb.c
> +++ b/drivers/pwm/pwm-atmel-tcb.c
> @@ -358,6 +358,7 @@ static const struct pwm_ops atmel_tcb_pwm_ops = {
>   	.set_polarity = atmel_tcb_pwm_set_polarity,
>   	.enable = atmel_tcb_pwm_enable,
>   	.disable = atmel_tcb_pwm_disable,
> +	.owner = THIS_MODULE,
>   };
>
>   static int atmel_tcb_pwm_probe(struct platform_device *pdev)
>


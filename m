Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752058Ab3HEM3X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 08:29:23 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:40761 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751415Ab3HEM3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 08:29:22 -0400
Message-ID: <51FF9A95.2030307@ti.com>
Date: Mon, 5 Aug 2013 07:29:09 -0500
From: Nishanth Menon <nm@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: <rjw@sisk.pl>, <pavel@ucw.cz>, <linaro-kernel@lists.linaro.org>,
        <patches@linaro.org>, <linux-pm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] OPP: Export opp_add()
References: <58acb4a8a4e98089078de3ed71999730b6d97b4b.1375521724.git.viresh.kumar@linaro.org>
In-Reply-To: <58acb4a8a4e98089078de3ed71999730b6d97b4b.1375521724.git.viresh.kumar@linaro.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

minor nitpick.
$subject: PM / OPP:

On 08/03/2013 04:25 AM, Viresh Kumar wrote:
> Export opp_add() so that modules can use it.
>
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---
>   drivers/base/power/opp.c | 1 +
>   1 file changed, 1 insertion(+)
>
> diff --git a/drivers/base/power/opp.c b/drivers/base/power/opp.c
> index c8ec186..ef89897 100644
> --- a/drivers/base/power/opp.c
> +++ b/drivers/base/power/opp.c
> @@ -460,6 +460,7 @@ int opp_add(struct device *dev, unsigned long freq, unsigned long u_volt)
>   	srcu_notifier_call_chain(&dev_opp->head, OPP_EVENT_ADD, new_opp);
>   	return 0;
>   }
> +EXPORT_SYMBOL_GPL(opp_add);
>
>   /**
>    * opp_set_availability() - helper to set the availability of an opp
>
other than that,
Acked-by: Nishanth Menon <nm@ti.com>

-- 
Regards,
Nishanth Menon

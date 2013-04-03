Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761118Ab3DCC3S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 22:29:18 -0400
Received: from db3ehsobe004.messaging.microsoft.com ([213.199.154.142]:14483
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760755Ab3DCC3R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 22:29:17 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VS-3(zz98dI146fI1432Izz1f42h1fc6h1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275bhz2dh87h2a8h668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Wed, 3 Apr 2013 10:29:40 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Fabio Estevam <fabio.estevam@freescale.com>
CC: <tglx@linutronix.de>, <john.stultz@linaro.org>,
        <linux-kernel@vger.kernel.org>, <festevam@gmail.com>
Subject: Re: [PATCH] clocksource: mxs_timer: Add semicolon at end of line
Message-ID: <20130403022939.GL24039@S2101-09.ap.freescale.net>
References: <1364920232-9604-1-git-send-email-fabio.estevam@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1364920232-9604-1-git-send-email-fabio.estevam@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 02, 2013 at 01:30:32PM -0300, Fabio Estevam wrote:
> Fix the following build error:
> 
> drivers/clocksource/mxs_timer.c:304:1: error: expected ',' or ';' at end of input
> 
What's your gcc version?  I'm using gcc version 4.6.3 (Ubuntu/Linaro
4.6.3-1ubuntu5), and do not see the compile error.

Anyway, patch applied.

> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
> ---
>  drivers/clocksource/mxs_timer.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/clocksource/mxs_timer.c b/drivers/clocksource/mxs_timer.c
> index a4d469b..02af420 100644
> --- a/drivers/clocksource/mxs_timer.c
> +++ b/drivers/clocksource/mxs_timer.c
> @@ -301,4 +301,4 @@ static void __init mxs_timer_init(struct device_node *np)
>  	irq = irq_of_parse_and_map(np, 0);
>  	setup_irq(irq, &mxs_timer_irq);
>  }
> -CLOCKSOURCE_OF_DECLARE(mxs, "fsl,timrot", mxs_timer_init)
> +CLOCKSOURCE_OF_DECLARE(mxs, "fsl,timrot", mxs_timer_init);

I guess I took the bad example from drivers/clocksource/vt8500_timer.c.

Shawn


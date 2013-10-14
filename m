Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756914Ab3JNPz1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 11:55:27 -0400
Received: from p3plex2out02.prod.phx3.secureserver.net ([184.168.131.14]:35985
	"EHLO p3plex2out02.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756687Ab3JNPz0 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 11:55:26 -0400
X-Greylist: delayed 450 seconds by postgrey-1.27 at vger.kernel.org; Mon, 14 Oct 2013 11:55:26 EDT
From: Hartley Sweeten <HartleyS@visionengravers.com>
To: Michael Opdenacker <michael.opdenacker@free-electrons.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>
CC: "rmallon@gmail.com" <rmallon@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] ARM: ep93xx: remove deprecated IRQF_DISABLED
Thread-Topic: [PATCH] ARM: ep93xx: remove deprecated IRQF_DISABLED
Thread-Index: AQHOxvij1zvcao3KlkOYne/2NxfKFpn0Wxmg
Date: Mon, 14 Oct 2013 15:47:55 +0000
Message-ID: <DC148C5AA1CEBA4E87973D432B1C2D8817DAB036@P3PWEX4MB008.ex4.secureserver.net>
References: <1381547439-4888-1-git-send-email-michael.opdenacker@free-electrons.com>
In-Reply-To: <1381547439-4888-1-git-send-email-michael.opdenacker@free-electrons.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [184.183.19.121]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, October 11, 2013 8:11 PM, Michael Opdenacker wrote:
> This patch proposes to remove the use of the IRQF_DISABLED flag
>
> It's a NOOP since 2.6.35 and it will be removed one day.
>
> Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
> ---
>  arch/arm/mach-ep93xx/core.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/arm/mach-ep93xx/core.c b/arch/arm/mach-ep93xx/core.c
> index 3f12b88..fcc965f 100644
> --- a/arch/arm/mach-ep93xx/core.c
> +++ b/arch/arm/mach-ep93xx/core.c
> @@ -136,7 +136,7 @@ static irqreturn_t ep93xx_timer_interrupt(int irq, void *dev_id)
>  
>  static struct irqaction ep93xx_timer_irq = {
>  	.name		= "ep93xx timer",
> -	.flags		= IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
> +	.flags		= IRQF_TIMER | IRQF_IRQPOLL,
>  	.handler	= ep93xx_timer_interrupt,
>  };
>  

Acked-by: H Hartley Sweeten <hsweeten@visionengravers.com>

Thanks

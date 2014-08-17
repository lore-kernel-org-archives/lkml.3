Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751505AbaHQQ56 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2014 12:57:58 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:58516 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750962AbaHQQ55 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2014 12:57:57 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18M0Mj5tTAT+UJc1NdMVR0lQTZXT8Ui7AM=
X-DKIM: OpenDKIM Filter v2.0.1 titan CFA665C7C2F
Date: Sun, 17 Aug 2014 12:57:36 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Mark Brown <broonie@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Marc Zyngier <marc.zyngier@arm.com>,
        linux-arm-kernel@lists.infradead.org, linaro-kernel@lists.linaro.org,
        Mark Brown <broonie@linaro.org>
Subject: Re: [PATCH] irqchip: gic-v3: Only define gic_peek_irq() when
 building SMP
Message-ID: <20140817165736.GD12769@titan.lakedaemon.net>
References: <1406480224-24628-1-git-send-email-broonie@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406480224-24628-1-git-send-email-broonie@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark,

On Sun, Jul 27, 2014 at 05:57:04PM +0100, Mark Brown wrote:
> From: Mark Brown <broonie@linaro.org>
> 
> If building with CONFIG_SMP disbled (for example, with allnoconfig) then
> GCC complains that the static function gic_peek_irq() is defined but not
> used since the only reference is in the SMP initialisation code. Fix this
> by moving the function definition inside the ifdef.
> 
> Signed-off-by: Mark Brown <broonie@linaro.org>
> ---
>  drivers/irqchip/irq-gic-v3.c | 26 +++++++++++++-------------
>  1 file changed, 13 insertions(+), 13 deletions(-)

Applied to irqchip/urgent with Mark's Ack.

thx,

Jason.

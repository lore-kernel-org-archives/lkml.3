Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757879AbaFUCOV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 22:14:21 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:34742 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752229AbaFUCOT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 22:14:19 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19nFY06iWkY1+u4+c0TzXcFc+nf/3P7Kdk=
X-DKIM: OpenDKIM Filter v2.0.1 titan B11175950A1
Date: Fri, 20 Jun 2014 22:14:04 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Daniel Thompson <daniel.thompson@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, patches@linaro.org,
        linaro-kernel@lists.linaro.org
Subject: Re: [PATCH v2] irqchip: nvic: Use the generic noop function
Message-ID: <20140621021404.GD21711@titan.lakedaemon.net>
References: <1401885425-12378-1-git-send-email-daniel.thompson@linaro.org>
 <1401894112-13386-1-git-send-email-daniel.thompson@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401894112-13386-1-git-send-email-daniel.thompson@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 04, 2014 at 04:01:52PM +0100, Daniel Thompson wrote:
> Using the generic function saves looking up this custom one in a source
> navigator.
> 
> Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Jason Cooper <jason@lakedaemon.net>
> ---
>  drivers/irqchip/irq-nvic.c | 13 ++++---------
>  1 file changed, 4 insertions(+), 9 deletions(-)

Applied to irqchip/core with Uwe's Ack.

thx,

Jason.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752956AbbAGMvs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 07:51:48 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:15266 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752754AbbAGMvr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 07:51:47 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19/iT0+Mz8fxSmxjJZ9wjpIMsXkjMtVONk=
X-DKIM: OpenDKIM Filter v2.0.1 titan 99CDD63F98A
Date: Wed, 7 Jan 2015 07:51:34 -0500
From: Jason Cooper <jason@lakedaemon.net>
To: gavinli@thegavinli.com
Cc: tglx@linutronix.de, linux@maxim.org.za, nicolas.ferre@atmel.com,
        plagnioj@jcrosoft.com, Gavin Li <git@thegavinli.com>,
        Linux ARM Kernel <linux-arm-kernel@lists.infradead.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] irqchip: atmel-aic-common: prevent clobbering of
 priority when changing IRQ type
Message-ID: <20150107125134.GI24989@titan.lakedaemon.net>
References: <1420598843-8409-1-git-send-email-gavinli@thegavinli.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420598843-8409-1-git-send-email-gavinli@thegavinli.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gavin,

On Tue, Jan 06, 2015 at 06:47:23PM -0800, gavinli@thegavinli.com wrote:
> From: Gavin Li <git@thegavinli.com>
> 
> This patch makes the bitmask for AIC_SRCTYPE consistent
> with that of its valid values, and prevents the priority
> field at bits 2:0 from being clobbered by an incorrect
> AND with the AIC_SRCTYPE mask.
> 
> Signed-off-by: Gavin Li <gavinli@thegavinli.com>
> ---
>  drivers/irqchip/irq-atmel-aic-common.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Well done.  For a first patch this is really good.  The only thing you
missed was who/which MLs to Cc.  In the future, you can use
./scripts/get_maintainer.pl to find this info.

Applied to irqchip/urgent with Acks from the atmel maintainers and Cc'd
to stable for v3.17+

This will be in linux-next tonight if Stephen builds one.

thx,

Jason.

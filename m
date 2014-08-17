Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751593AbaHQRF2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2014 13:05:28 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:24972 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751398AbaHQRF1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2014 13:05:27 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18otNPfqygQFmcD4Vf9vq740EvqbcEO/qI=
X-DKIM: OpenDKIM Filter v2.0.1 titan D96845C7C91
Date: Sun, 17 Aug 2014 13:04:53 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Mark Brown <broonie@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Geoff Levand <geoff@infradead.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        linux-arm-kernel@lists.infradead.org, linaro-kernel@lists.linaro.org,
        linux-kernel@vger.kernel.org, Mark Brown <broonie@linaro.org>
Subject: Re: [PATCH] irq: gic-v3: Tag all low level accessors
 __maybey_unused
Message-ID: <20140817170453.GE12769@titan.lakedaemon.net>
References: <1406748194-21094-1-git-send-email-broonie@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406748194-21094-1-git-send-email-broonie@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark,

On Wed, Jul 30, 2014 at 08:23:14PM +0100, Mark Brown wrote:
> From: Mark Brown <broonie@linaro.org>
> 
> This is only really needed for gic_write_sgi1r in the !SMP case since it
> is only referenced in the SMP initialisation code but it seems better to
> have these functions all next to each other and declared consistently.
> 
> Signed-off-by: Mark Brown <broonie@linaro.org>
> ---
>  drivers/irqchip/irq-gic-v3.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)

Applied to irqchip/urgent

thx,

Jason.

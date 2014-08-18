Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751942AbaHRKwj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 06:52:39 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:14864 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751779AbaHRKwg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 06:52:36 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19Gxgcr7Q4raP2uUV8NImxvVQJWq/aH9u0=
X-DKIM: OpenDKIM Filter v2.0.1 titan 76D445C89D2
Date: Mon, 18 Aug 2014 06:51:59 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: Mark Brown <broonie@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        linaro-kernel@lists.linaro.org, Mark Brown <broonie@linaro.org>,
        Geoff Levand <geoff@infradead.org>, linux-kernel@vger.kernel.org,
        Marc Zyngier <marc.zyngier@arm.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] irq: gic-v3: Tag all low level accessors
 __maybey_unused
Message-ID: <20140818105159.GP12769@titan.lakedaemon.net>
References: <1406748194-21094-1-git-send-email-broonie@kernel.org>
 <20140818071104.GA2207@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20140818071104.GA2207@pengutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Uwe,

On Mon, Aug 18, 2014 at 09:11:04AM +0200, Uwe Kleine-König wrote:
> 
> typo in the Subject line. s/maybey/maybe/

Yep, I forgot to mention I fixed that when I applied it.

thx,

Jason.

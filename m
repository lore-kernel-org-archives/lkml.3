Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752125Ab3GBNg5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 09:36:57 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:40427 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750985Ab3GBNg4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 09:36:56 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 72.84.113.162
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19eWzU485PfPjkExjCd/Dh5VO1CzWFjmHY=
Date: Tue, 2 Jul 2013 09:36:46 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>, Andrew Lunn <andrew@lunn.ch>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 5/7] ARM: kirkwood: convert to DT irqchip and
 clocksource
Message-ID: <20130702133646.GB17110@titan.lakedaemon.net>
References: <1372763023-12374-6-git-send-email-sebastian.hesselbarth@gmail.com>
 <1372770907-32738-1-git-send-email-sebastian.hesselbarth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1372770907-32738-1-git-send-email-sebastian.hesselbarth@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 02, 2013 at 03:15:07PM +0200, Sebastian Hesselbarth wrote:
> With recent support for true irqchip and clocksource drivers for Orion
> SoCs, now make use of it on DT enabled Kirkwood boards.
> 
> This also introduces a new Kconfig option for legacy (non-DT) Kirkwood
> where old code is moved out to and polishes DT board file a little bit.
> 
> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> --- 
> Changelog:
> v4->v5:
> - do not re-introduce already removed init_dma_coherent_pool_size
>   (Reported by Jason Cooper)
> 
> @Jason: I did a 'git grep init_dma_coherent_pool_size' and now there
> are no users of that function - as it was before. Patch 6/7 only differs
> in the 'index' diff line because of the rebase here. I will not resend that,
> it should still apply.

ok, great, thanks for turning that around.

thx,

Jason.

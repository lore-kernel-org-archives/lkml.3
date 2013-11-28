Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759378Ab3K1TEk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 14:04:40 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:46461 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759334Ab3K1TEa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 14:04:30 -0500
X-Sasl-enc: +lVQ9aj1/7TNtmEVTyj4Tu20EyrE/guNoYrdS13+4vE/ 1385665468
Date: Thu, 28 Nov 2013 11:05:20 -0800
From: Greg KH <greg@kroah.com>
To: Michael Grzeschik <m.grzeschik@pengutronix.de>
Cc: linux-mtd@lists.infradead.org, dwmw2@infradead.org,
        artem.bityutskiy@linux.intel.com, computersforpeace@gmail.com,
        kernel@pengutronix.de, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] mxc_nand: remove redundant stat counting
Message-ID: <20131128190520.GA2194@kroah.com>
References: <1385651080-15562-1-git-send-email-m.grzeschik@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1385651080-15562-1-git-send-email-m.grzeschik@pengutronix.de>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 28, 2013 at 04:04:40PM +0100, Michael Grzeschik wrote:
> The stats count variable will already be incremented
> in the above framework-layer just after this callback.
> 
> Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
> ---
>  drivers/mtd/nand/mxc_nand.c | 1 -
>  1 file changed, 1 deletion(-)

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read Documentation/stable_kernel_rules.txt
for how to do this properly.

</formletter>

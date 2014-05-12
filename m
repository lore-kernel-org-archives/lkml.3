Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752487AbaELWRk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 18:17:40 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:49147 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095AbaELWRj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 18:17:39 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/8s9sAXYCpsxmhMJZWsmkC
Date: Mon, 12 May 2014 15:17:21 -0700
From: Tony Lindgren <tony@atomide.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Vinod Koul <vinod.koul@intel.com>, dmaengine@vger.kernel.org
Subject: Re: [PATCH 1/2] dmaengine: omap: hide filter_fn for built-in drivers
Message-ID: <20140512221720.GH5668@atomide.com>
References: <1399560433-1402630-1-git-send-email-arnd@arndb.de>
 <1399560990-1402858-1-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1399560990-1402858-1-git-send-email-arnd@arndb.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Arnd Bergmann <arnd@arndb.de> [140508 07:57]:
> It is not possible to reference the omap_dma_filter_fn filter
> function from a built-in driver if the dmaengine driver itself
> is a loadable module, which is a valid configuration otherwise.
> 
> This provides only the dummy alternative if the function
> is referenced by a built-in driver to allow a successful
> build. The filter function is only required by ATAGS based
> platforms, which will continue to be broken after this change
> for the bogus configuration. When booting from DT, with the
> dma channels correctly listed there, it will work fine.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Tony Lindgren <tony@atomide.com>
> Cc: Russell King <rmk+kernel@arm.linux.org.uk>
> Cc: Vinod Koul <vinod.koul@intel.com>
> Cc: dmaengine@vger.kernel.org

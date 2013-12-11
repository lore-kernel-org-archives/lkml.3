Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751483Ab3LKJRu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 04:17:50 -0500
Received: from mail-yh0-f47.google.com ([209.85.213.47]:61327 "EHLO
	mail-yh0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750819Ab3LKJRp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 04:17:45 -0500
Date: Wed, 11 Dec 2013 09:17:39 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Felipe Balbi <balbi@ti.com>
Cc: Tony Lindgren <tony@atomide.com>, Aaro Koskinen <aaro.koskinen@iki.fi>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 07/15] mfd: menelaus: Limit the usage of the_menelaus
Message-ID: <20131211091739.GB16780@lee--X1>
References: <20131209161422.GC24047@saruman.home>
 <1386606085-26838-1-git-send-email-balbi@ti.com>
 <1386606085-26838-7-git-send-email-balbi@ti.com>
 <20131210085701.GP12675@lee--X1>
 <20131210163220.GE22750@saruman.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20131210163220.GE22750@saruman.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Dec 2013, Felipe Balbi wrote:

> On Tue, Dec 10, 2013 at 08:57:01AM +0000, Lee Jones wrote:
> > > Pass a menelaus_chip pointer as argument to most functions so we can
> > > minimize the usage of the global the_menelaus pointer.
> > > 
> > > Tested-by: Aaro Koskinen <aaro.koskinen@iki.fi>
> > > Signed-off-by: Felipe Balbi <balbi@ti.com>
> > > ---
> > >  drivers/mfd/menelaus.c | 265 ++++++++++++++++++++++++++-----------------------
> > >  1 file changed, 142 insertions(+), 123 deletions(-)
> > 
> > How is this different from patch 6?
> 
> have you read the patch ? patch 6 converts *only* enable/disable irq
> functions.

Well it actually converts menelaus_ack_irq() too, but that's not the
point I was making.

I can see that the 'code' is different, but the functionality of the
patch is the same i.e. converting functions to pass around the
menelaus_chip pointer for eradication of the_menelaus global pointer.

I'm not concerned about the 'lines changed' count. The change your
making is trivial, thus there is no requirement to split unnecessarily
over 5 patches. Please squash them into a single functionality patch.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog

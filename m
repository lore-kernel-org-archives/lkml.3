Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965184Ab3GSHRi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 03:17:38 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:33782 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759727Ab3GSHRg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 03:17:36 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19SE0QWl/PNK4p0LAPNokO/
Date: Fri, 19 Jul 2013 00:17:29 -0700
From: Tony Lindgren <tony@atomide.com>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: Nishanth Menon <nm@ti.com>, balbi@ti.com, Sricharan R <r.sricharan@ti.com>,
        linux@arm.linux.org.uk, linux-doc@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, rnayak@ti.com,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 1/3] misc: Add crossbar driver
Message-ID: <20130719071728.GX7656@atomide.com>
References: <1374165830-6367-1-git-send-email-r.sricharan@ti.com>
 <1374165830-6367-2-git-send-email-r.sricharan@ti.com>
 <51E83A4F.5080904@ti.com>
 <51E87C98.5030001@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51E87C98.5030001@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thursday 18 July 2013 02:56 PM, Nishanth Menon wrote:
> 
> Since the cross-bar is not limited t0 IRQ lines and applicable for
> DMA request lines as well, making it IRQ chip doesn't make sense. Its
> not typical pin control functionality either but at least that framework
> is much closer to consider as an option.
> 
> Actually its more of setting up the IRQ and DMA pins maps once
> at boot for a given SOC based on chosen configuration by the
> board. So I am leaning towards pinctrl as well. Just haven't
> thought enough about whether thats the best approach.
> 
> CC'ing Linus W and Tony L whether we can use pinctrl framework
> for such an IP and if yes how ;-).

If it really muxes signals then using pinctrl seems logical.
Especially if the registers are in the SCM block.

It might be already possible to handle it already with
pinctrl-single,bits for the muxing part.

Regards,

Tony

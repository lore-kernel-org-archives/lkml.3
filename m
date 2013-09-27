Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754579Ab3I0VCH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 17:02:07 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:42795 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753639Ab3I0VCE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 17:02:04 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18iASkSn+Uu/qfXDDRhdrG8
Date: Fri, 27 Sep 2013 14:01:46 -0700
From: Tony Lindgren <tony@atomide.com>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Kevin Hilman <khilman@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Lars Poeschel <larsi@wh2.tu-dresden.de>,
        Grant Likely <grant.likely@linaro.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ian.campbell@citrix.com>,
        Kumar Gala <galak@codeaurora.org>, Pawel Moll <pawel.moll@arm.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Enric Balletbo i Serra <eballetbo@gmail.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Balaji T K <balajitk@ti.com>, Jon Hunter <jgchunter@gmail.com>,
        linux-gpio@vger.kernel.org, linux-omap@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        r.sricharan@ti.com, holler@ahsoftware.de
Subject: Re: [PATCH 1/2] gpio/omap: maintain GPIO and IRQ usage separately
Message-ID: <20130927210146.GF8949@atomide.com>
References: <1380069414-2922-1-git-send-email-javier.martinez@collabora.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1380069414-2922-1-git-send-email-javier.martinez@collabora.co.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Javier Martinez Canillas <javier.martinez@collabora.co.uk> [130924 17:45]:
> The GPIO OMAP controller pins can be used as IRQ and GPIO
> independently so is necessary to keep track GPIO pins and
> IRQ lines usage separately to make sure that the bank will
> always be enabled while being used.
> 
> Also move gpio_is_input() definition in preparation for the
> next patch that setups the controller's irq_chip driver when
> a caller requests an interrupt line.
> 
> Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>

Thanks both of these look good to me for fixing
the regression:

Acked-by: Tony Lindgren <tony@atomide.com>

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754345Ab3I0TcQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 15:32:16 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:34582 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753421Ab3I0TcK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 15:32:10 -0400
Message-ID: <5245DD23.6000508@ti.com>
Date: Fri, 27 Sep 2013 15:31:47 -0400
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
CC: Linus Walleij <linus.walleij@linaro.org>,
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
        Balaji T K <balajitk@ti.com>, Tony Lindgren <tony@atomide.com>,
        Jon Hunter <jgchunter@gmail.com>, <linux-gpio@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <r.sricharan@ti.com>,
        <holler@ahsoftware.de>
Subject: Re: [PATCH 1/2] gpio/omap: maintain GPIO and IRQ usage separately
References: <1380069414-2922-1-git-send-email-javier.martinez@collabora.co.uk>
In-Reply-To: <1380069414-2922-1-git-send-email-javier.martinez@collabora.co.uk>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 24 September 2013 08:36 PM, Javier Martinez Canillas wrote:
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
> ---
Considering GPIO core maintainer is fine with this approach,
am fine with both of your patches. Again thanks a lot for
fixing the long nagging issue.

FWIW,
Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>


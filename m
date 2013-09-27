Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753481Ab3I0ObI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 10:31:08 -0400
Received: from smtp1-1.goneo.de ([212.90.139.81]:40790 "EHLO smtp1-1.goneo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753166Ab3I0ObF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 10:31:05 -0400
X-Spam-Flag: NO
X-Spam-Score: -1.097
From: Lars Poeschel <poeschel@lemonage.de>
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
        Balaji T K <balajitk@ti.com>, Tony Lindgren <tony@atomide.com>,
        Jon Hunter <jgchunter@gmail.com>, linux-gpio@vger.kernel.org,
        linux-omap@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, r.sricharan@ti.com, holler@ahsoftware.de
Subject: Re: [PATCH 1/2] gpio/omap: maintain GPIO and IRQ usage separately
Date: Fri, 27 Sep 2013 16:31 +0200
Message-ID: <1651688.AIWaNrhZnY@lem-wkst-02>
User-Agent: KMail/4.10.5 (Linux/3.10-2-amd64; KDE/4.10.5; x86_64; ; )
In-Reply-To: <1380069414-2922-1-git-send-email-javier.martinez@collabora.co.uk>
References: <1380069414-2922-1-git-send-email-javier.martinez@collabora.co.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 27 September 2013 02:36:52, Javier Martinez Canillas wrote:
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

For both patches:

Tested-by: Lars Poeschel <poeschel@lemonage.de>

on an am3359 (which is DT booting).

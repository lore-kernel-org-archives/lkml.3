Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754757Ab3LPQYi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 11:24:38 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:60394 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754291Ab3LPQYg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 11:24:36 -0500
Message-ID: <52AF292A.4020106@ti.com>
Date: Mon, 16 Dec 2013 11:24:10 -0500
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Grygorii Strashko <grygorii.strashko@ti.com>
CC: Linus Walleij <linus.walleij@linaro.org>, Sekhar Nori <nsekhar@ti.com>,
        Rob Herring <rob.herring@calxeda.com>, <prabhakar.csengg@gmail.com>,
        <linux-gpio@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 1/2] gpio: davinci: don't create irq_domain in case of
 unbanked irqs
References: <1386871973-26762-1-git-send-email-grygorii.strashko@ti.com> <1386871973-26762-2-git-send-email-grygorii.strashko@ti.com>
In-Reply-To: <1386871973-26762-2-git-send-email-grygorii.strashko@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 12 December 2013 01:12 PM, Grygorii Strashko wrote:
> The system may crash if:
> - there are more then 1 bank
> - unbanked irqs are enabled
> - someone will call gpio_to_irq() for GPIO from bank2 or above
> 
> Hence, fix it by not creating irq_domain if unbanked irqs are enabled
> and correct gpio_to_irq_banked() to handle this properly.
> 
> CC: Linus Walleij <linus.walleij@linaro.org>
> CC: Sekhar Nori <nsekhar@ti.com>
> CC: Santosh Shilimkar <santosh.shilimkar@ti.com>
> 
> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
> ---
Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>



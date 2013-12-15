Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754253Ab3LOMlN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Dec 2013 07:41:13 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:36274 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752487Ab3LOMlL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Dec 2013 07:41:11 -0500
Message-ID: <52ADA301.2080209@ti.com>
Date: Sun, 15 Dec 2013 18:09:29 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Prabhakar Lad <prabhakar.csengg@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        <linux-gpio@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, Rob Herring <rob.herring@calxeda.com>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH v6 3/6] gpio: davinci: remove unused variable intc_irq_num
References: <1385057731-4348-1-git-send-email-prabhakar.csengg@gmail.com> <1385057731-4348-4-git-send-email-prabhakar.csengg@gmail.com>
In-Reply-To: <1385057731-4348-4-git-send-email-prabhakar.csengg@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 21 November 2013 11:45 PM, Prabhakar Lad wrote:
> From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
> 
> As the davinci-gpio driver is migrated to use irqdomain
> there is no need to pass the irq base for the gpio driver.
> This patch removes this variable from davinci_gpio_platform_data
> and also the refrences from the machine file.
> 
> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Queuing for v3.14 along with Linus's ack.

Thanks,
Sekhar

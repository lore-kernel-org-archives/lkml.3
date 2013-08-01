Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754904Ab3HALER (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 07:04:17 -0400
Received: from up.free-electrons.com ([94.23.35.102]:52913 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754381Ab3HALEP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 07:04:15 -0400
Message-ID: <51FA40AC.8060900@free-electrons.com>
Date: Thu, 01 Aug 2013 13:04:12 +0200
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Organization: Free Electrons
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Boris BREZILLON <b.brezillon@overkiz.com>
CC: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] pinctrl: at91: choose appropriate handler for level interrupts
References: <1374331893-16009-1-git-send-email-b.brezillon@overkiz.com>
In-Reply-To: <1374331893-16009-1-git-send-email-b.brezillon@overkiz.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 20/07/2013 16:51, Boris BREZILLON wrote:
> The current implementation handle both edge and level interrupts with the
> 'handle_simple_irq' handler.
>
> Level interrupts are active as long as the pin stays at the configured
> level (low or high). In this case we have to use 'handle_level_irq' which
> mask the interrupt until the handle has treated it.
>
> Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>

This solves the issue on my side.

Tested-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>


-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932781Ab3HGS7Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 14:59:25 -0400
Received: from mail-oa0-f41.google.com ([209.85.219.41]:44985 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932158Ab3HGS7Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 14:59:24 -0400
MIME-Version: 1.0
In-Reply-To: <1374331893-16009-1-git-send-email-b.brezillon@overkiz.com>
References: <1374331893-16009-1-git-send-email-b.brezillon@overkiz.com>
Date: Wed, 7 Aug 2013 20:59:23 +0200
Message-ID: <CACRpkdbte37s-nG-QqmbD=TrVEsSDBFTRX0fjbfUfHpwHSjLDw@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: at91: choose appropriate handler for level interrupts
From: Linus Walleij <linus.walleij@linaro.org>
To: Boris BREZILLON <b.brezillon@overkiz.com>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 20, 2013 at 4:51 PM, Boris BREZILLON
<b.brezillon@overkiz.com> wrote:

> The current implementation handle both edge and level interrupts with the
> 'handle_simple_irq' handler.
>
> Level interrupts are active as long as the pin stays at the configured
> level (low or high). In this case we have to use 'handle_level_irq' which
> mask the interrupt until the handle has treated it.
>
> Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>

Patch applied with Alexandre's Tested-by tag.

Worst thing that can happen is that I have to revert it.
Now it will atleast get some testing in linux-next.

Yours,
Linus Walleij

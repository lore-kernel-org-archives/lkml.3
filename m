Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758613Ab3DZJHf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 05:07:35 -0400
Received: from mail-ia0-f170.google.com ([209.85.210.170]:37316 "EHLO
	mail-ia0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753605Ab3DZJHd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 05:07:33 -0400
MIME-Version: 1.0
In-Reply-To: <20130426081646.GD24632@intel.com>
References: <1366280825-31136-1-git-send-email-lee.jones@linaro.org>
	<CACRpkdbFgW6bGYt59WtN4r2izuN09AJw4J1cqir82uzFsuMmWQ@mail.gmail.com>
	<20130425134402.GN4623@gmail.com>
	<201304251611.39667.arnd@arndb.de>
	<CACRpkdaBf++gy3sghC-t33uio2+eHp1MrQ2FM0XXBazZTtm3kA@mail.gmail.com>
	<20130426081646.GD24632@intel.com>
Date: Fri, 26 Apr 2013 11:07:33 +0200
Message-ID: <CACRpkdYR=eb_oU6+iq0vbkbd_H0O+cccdXDSCR2oev2NEdwMZg@mail.gmail.com>
Subject: Re: [PATCH 6/9] crypto: ux500/cryp - Set DMA configuration though dma_slave_config()
From: Linus Walleij <linus.walleij@linaro.org>
To: Vinod Koul <vinod.koul@intel.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Lee Jones <lee.jones@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Andreas Westin <andreas.westin@stericsson.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        magnus.p.persson@stericsson.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 26, 2013 at 10:16 AM, Vinod Koul <vinod.koul@intel.com> wrote:

>> OK I could cook a patch for that, but I think I need some input from
>> Vinod and/or Russell on this.

> the dma_slave_config is physical address that should be passed directly to the
> controller. Obviosuly it should phys_addr_t :)

OK! Sent a patch for this, check it out.

Yours,
Linus Walleij

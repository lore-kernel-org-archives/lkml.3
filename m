Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763464Ab3ECTfb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 15:35:31 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:45596 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760627Ab3ECTfa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 15:35:30 -0400
MIME-Version: 1.0
In-Reply-To: <1367591569-32197-6-git-send-email-lee.jones@linaro.org>
References: <1367591569-32197-1-git-send-email-lee.jones@linaro.org>
	<1367591569-32197-6-git-send-email-lee.jones@linaro.org>
Date: Fri, 3 May 2013 21:35:29 +0200
Message-ID: <CACRpkda_8KZeTfxwutyOD6S8nBe4BVUp+x-LhbMSohdOzyvDTg@mail.gmail.com>
Subject: Re: [PATCH 05/63] ARM: ux500: Populate the ux500-musb Device Tree entry
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 3, 2013 at 4:31 PM, Lee Jones <lee.jones@linaro.org> wrote:

> This patch provides all the information to successfully probe() and
> correctly configure the ux500-musb device driver for DMA.
>
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
> Acked-by: Fabio Baltieri <fabio.baltieri@linaro.org>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Applied to my ux500-devicetree branch.

Thanks!
Linus Walleij

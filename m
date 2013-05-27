Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757542Ab3E0KpI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 06:45:08 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:42842 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757341Ab3E0KpG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 06:45:06 -0400
MIME-Version: 1.0
In-Reply-To: <20130522144957.GA18714@gmail.com>
References: <1369233402-19225-1-git-send-email-lee.jones@linaro.org>
	<20130522144957.GA18714@gmail.com>
Date: Mon, 27 May 2013 12:45:04 +0200
Message-ID: <CACRpkda_mcNYB8iqE8Pvxp_pQZejGvdXQRxiL1QMO5vZcGgMhg@mail.gmail.com>
Subject: Re: [PATCH v2] ARM: ux500: Apply other compatible name to the u8540
 DTS file
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

On Wed, May 22, 2013 at 4:49 PM, Lee Jones <lee.jones@linaro.org> wrote:

> ARM: ux500: Apply other compatible name to the u8540 DTS file
>
> Devices in board DTS files are usually searchable by multiple
> compatible strings. In this case the 8540 based SoC should be
> obtainable via the chipset [DB8540 & AB8540] name 'u8540' or
> the board name 'ccu8540'. It's already possible to obtain the
> Device Tree via its chipset name, this patch makes it possible
> to get it by its board name too.
>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Applied to my ux500-devicetree branch.

Thanks!
Linus Walleij

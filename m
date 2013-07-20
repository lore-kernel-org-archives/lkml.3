Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754714Ab3GTRsD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jul 2013 13:48:03 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:47499 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754151Ab3GTRsA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jul 2013 13:48:00 -0400
MIME-Version: 1.0
In-Reply-To: <1373471889-18107-6-git-send-email-wsa@the-dreams.de>
References: <1373471889-18107-1-git-send-email-wsa@the-dreams.de>
	<1373471889-18107-6-git-send-email-wsa@the-dreams.de>
Date: Sat, 20 Jul 2013 19:48:00 +0200
Message-ID: <CACRpkdbBYuPE6ZaiuWgEze0JuuqvhDFS7VLhVTJBopiLMBNJpw@mail.gmail.com>
Subject: Re: [PATCH 06/12] drivers/mtd/nand/gpmi-nand: don't use
 devm_pinctrl_get_select_default() in probe
From: Linus Walleij <linus.walleij@linaro.org>
To: Wolfram Sang <wsa@the-dreams.de>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Huang Shijie <b32955@freescale.com>,
        Bill Pemberton <wfp5p@virginia.edu>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        David Woodhouse <dwmw2@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 10, 2013 at 5:57 PM, Wolfram Sang <wsa@the-dreams.de> wrote:

> Since commit ab78029 (drivers/pinctrl: grab default handles from device core),
> we can rely on device core for setting the default pins. Compile tested only.
>
> Acked-by: Linus Walleij <linus.walleij@linaro.org> (personally at LCE13)
> Signed-off-by: Wolfram Sang <wsa@the-dreams.de>

Artem  if you're OK with this please carry it in the MTD tree.

Yours,
Linus Walleij

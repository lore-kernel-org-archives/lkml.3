Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753912Ab3HPNJX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 09:09:23 -0400
Received: from mail-oa0-f53.google.com ([209.85.219.53]:57129 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753394Ab3HPNJR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 09:09:17 -0400
MIME-Version: 1.0
In-Reply-To: <20130719041952.GA29001@dev.danweeks.net>
References: <20130719041952.GA29001@dev.danweeks.net>
Date: Fri, 16 Aug 2013 15:09:16 +0200
Message-ID: <CACRpkdZeoYgrVwZ6jdChiB0ciJ76N5CFtEPUaLZE5VnpOmT79w@mail.gmail.com>
Subject: Re: [PATCH] gpio-mcp23s08: i2c: auto-select base if no DT match or
 platform data
From: Linus Walleij <linus.walleij@linaro.org>
To: "Daniel M. Weeks" <dan@danweeks.net>
Cc: Grant Likely <grant.likely@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 19, 2013 at 6:19 AM, Daniel M. Weeks <dan@danweeks.net> wrote:

> The call to gpiochip_add made by this driver is capable of auto-selecting a
> base if one is not provided. However, it was not called unless there was
> already a DT entry or platform data. This patch calls it even if the base is
> not already known so that gpiochip_add can attempt to find a usable base.
>
> Signed-off-by: Daniel M. Weeks <dan@danweeks.net>

Patch applied with Lars' ACK.

Yours,
Linus Walleij

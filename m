Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758119Ab3DYLnU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 07:43:20 -0400
Received: from mail-ia0-f181.google.com ([209.85.210.181]:56631 "EHLO
	mail-ia0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755594Ab3DYLnT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 07:43:19 -0400
MIME-Version: 1.0
In-Reply-To: <1366279934-30761-31-git-send-email-lee.jones@linaro.org>
References: <1366279934-30761-1-git-send-email-lee.jones@linaro.org>
	<1366279934-30761-31-git-send-email-lee.jones@linaro.org>
Date: Thu, 25 Apr 2013 13:43:18 +0200
Message-ID: <CACRpkdbYXxkC2y9zCNcMAAmmQ7+3V0Y=hq7zgtp5L=Ts9QzpQQ@mail.gmail.com>
Subject: Re: [PATCH 30/32] ARM: ux500: Supply MMC DMA configuration via Device Tree
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus WALLEIJ <linus.walleij@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 18, 2013 at 12:12 PM, Lee Jones <lee.jones@linaro.org> wrote:

> When requesting a channel, a DMA client needs to pass some pieces of
> information such as; request channel, device type, channel type and
> direction etc. Normally we do this in the form of platform data, but
> when DT is enabled we need to pass it using the driver's bindings
> instead.
>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

This requires that the pending MMCI patch get merged *first* right?

So you need to make sure Russell will merge that (or ACK it
and include it) before you send any pull requests to me.

Apart from that it looks allright:
Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij

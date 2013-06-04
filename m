Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752573Ab3FDK5J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 06:57:09 -0400
Received: from mail-oa0-f45.google.com ([209.85.219.45]:37820 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026Ab3FDK5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 06:57:07 -0400
MIME-Version: 1.0
In-Reply-To: <1370266965-7901-22-git-send-email-lee.jones@linaro.org>
References: <1370266965-7901-1-git-send-email-lee.jones@linaro.org>
	<1370266965-7901-22-git-send-email-lee.jones@linaro.org>
Date: Tue, 4 Jun 2013 12:57:06 +0200
Message-ID: <CACRpkdaNMR=6JT+pi+9aqOJXW3gK9Yb4hztx3rOiY3c+f3UTRA@mail.gmail.com>
Subject: Re: [PATCH 21/21] clk: ux500: Supply provider look-up functionality
 to support Device Tree
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Mike Turquette <mturquette@linaro.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 3, 2013 at 3:42 PM, Lee Jones <lee.jones@linaro.org> wrote:

> In this patch we're populating a clk_data array, one clock per element to
> act as a clk look-up using indexes supplied from Device Tree.
>
> Cc: Mike Turquette <mturquette@linaro.org>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

This needs to be patch 1/21 because otherwise the rest of the
stuff is non-bisectable right? It's being broken the first time
you remove auxdata and not fixed until this patch.

The whole thing is very different from other DT clock things
I've seen, usually you add a compatible node for each
clock type, and a node for each physical gate. But there
may be several ways to skin this cat...

Make sure to include devicetree-discuss in the series for
an OS-neutral review opportunity.

Yours,
Linus Walleij

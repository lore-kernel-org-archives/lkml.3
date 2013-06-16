Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755208Ab3FPKBP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jun 2013 06:01:15 -0400
Received: from mail-ob0-f177.google.com ([209.85.214.177]:49892 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755071Ab3FPKBO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jun 2013 06:01:14 -0400
MIME-Version: 1.0
In-Reply-To: <1370938616-5952-1-git-send-email-linus.walleij@stericsson.com>
References: <1370938616-5952-1-git-send-email-linus.walleij@stericsson.com>
Date: Sun, 16 Jun 2013 12:01:13 +0200
Message-ID: <CACRpkdbM2iPoHjJe8zJjqtXKKZpL3S7C1S6OsLDWawFDjtvwuw@mail.gmail.com>
Subject: Re: [PATCH] drivers: pinctrl: add active state to core
From: Linus Walleij <linus.walleij@linaro.org>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Stephen Warren <swarren@nvidia.com>, Kevin Hilman <khilman@linaro.org>,
        Tony Lindgren <tony@atomide.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Hebbar Gururaja <gururaja.hebbar@ti.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Wolfram Sang <wsa@the-dreams.de>, Mark Brown <broonie@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 11, 2013 at 10:16 AM, Linus Walleij
<linus.walleij@stericsson.com> wrote:

> From: Linus Walleij <linus.walleij@linaro.org>
>
> In addition to the recently introduced pinctrl core
> control, the PM runtime pin control for the OMAP platforms
> require a fourth state in addtition to the default, idle and
> sleep states already handled by the core: an explicit "active"
> state. Let's introduce this to the core in addition to the
> other states already defined.
>
> Cc: Hebbar Gururaja <gururaja.hebbar@ti.com>
> Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> Cc: Stephen Warren <swarren@wwwdotorg.org>
> Cc: Wolfram Sang <wsa@the-dreams.de>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Mark Brown <broonie@kernel.org>
> Cc: Kevin Hilman <khilman@linaro.org>
> Suggested-by: Tony Lindgren <tony@atomide.com>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>

It seems this thing needs another round of discussion so I've pulled
this patch out of the branch with stuff for -next and rebased dependencies.

Yours,
Linus Walleij

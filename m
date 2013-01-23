Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755434Ab3AWMTV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 07:19:21 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:53578 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754723Ab3AWMTU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 07:19:20 -0500
MIME-Version: 1.0
In-Reply-To: <1358936878-29806-1-git-send-email-fabio.baltieri@linaro.org>
References: <1358936878-29806-1-git-send-email-fabio.baltieri@linaro.org>
Date: Wed, 23 Jan 2013 13:19:19 +0100
Message-ID: <CACRpkdZrmq8=_=BwvB9wZYxHEQZRZ1pVqD3+7B=YORU=rpnOOw@mail.gmail.com>
Subject: Re: [PATCH] ARM: mach-ux500: enable 128KB way L2 cache on DB8540
From: Linus Walleij <linus.walleij@linaro.org>
To: Fabio Baltieri <fabio.baltieri@linaro.org>
Cc: Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Maxime Coquelin <maxime.coquelin@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 23, 2013 at 11:27 AM, Fabio Baltieri
<fabio.baltieri@linaro.org> wrote:

> From: Maxime Coquelin <maxime.coquelin@stericsson.com>
>
> DB8540 L2 was configured with 64KB way size, but it has 128KB as AP9540.
>
> Fix this by modifying ux500_l2x0_init() to use 128KB way size for all
> cpus in the x540 family.
>
> Signed-off-by: Maxime Coquelin <maxime.coquelin@stericsson.com>
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
> Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>

Applied to my ux500-core branch.

Yours,
Linus Walleij

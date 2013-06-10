Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752155Ab3FJHpg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 03:45:36 -0400
Received: from mail-oa0-f43.google.com ([209.85.219.43]:59406 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751528Ab3FJHpf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 03:45:35 -0400
MIME-Version: 1.0
In-Reply-To: <1370696686-1666-1-git-send-email-grant.likely@linaro.org>
References: <1370696686-1666-1-git-send-email-grant.likely@linaro.org>
Date: Mon, 10 Jun 2013 09:45:35 +0200
Message-ID: <CACRpkdbGmOTL_Ks=n01TsoFPYn-GgwmJA5Yuch1g0wkEV=_=uw@mail.gmail.com>
Subject: Re: [PATCH] irqchip: Return -EPERM for reserved IRQs
From: Linus Walleij <linus.walleij@linaro.org>
To: Grant Likely <grant.likely@linaro.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 8, 2013 at 3:04 PM, Grant Likely <grant.likely@linaro.org> wrote:

> The irqdomain core will report a log message for any attempted map call
> that fails unless the error code is -EPERM. This patch changes the
> Versatile irq controller drivers to use -EPERM because it is normal for
> a subset of the IRQ inputs to be marked as reserved on the various
> Versatile platforms.
>
> Signed-off-by: Grant Likely <grant.likely@linaro.org>
> Cc: Linus Walleij <linus.walleij@linaro.org>

Looks good:
Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751939Ab3C0NSE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 09:18:04 -0400
Received: from mail-ia0-f175.google.com ([209.85.210.175]:64699 "EHLO
	mail-ia0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750968Ab3C0NSC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 09:18:02 -0400
MIME-Version: 1.0
In-Reply-To: <1363966065-2478-3-git-send-email-lee.jones@linaro.org>
References: <1363966065-2478-1-git-send-email-lee.jones@linaro.org>
	<1363966065-2478-3-git-send-email-lee.jones@linaro.org>
Date: Wed, 27 Mar 2013 14:18:01 +0100
Message-ID: <CACRpkdY-NCVekZ+jr4ZwxHHXuSrYbn-8j7p0OSaPbydO5jBR7A@mail.gmail.com>
Subject: Re: [PATCH 3/5] ARM: ux500: Remove platform specific PRCMU and Clk initialisation
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@stericsson.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 22, 2013 at 4:27 PM, Lee Jones <lee.jones@linaro.org> wrote:

> For the moment at least, every platform which executes though
> ux500_init_irq requires the same clk and prcmu initialisation.
> So let's call those functions without clause.
>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

This is not true after the multiplatform series so won't work, sorry!

Yours,
Linus Walleij

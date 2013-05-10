Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757077Ab3EJO30 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 10:29:26 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:51160 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755979Ab3EJO3X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 10:29:23 -0400
Date: Fri, 10 May 2013 15:29:13 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Grant Likely <grant.likely@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Rabin Vincent <rabin.vincent@stericsson.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] gpio: stmpe: Staticize non-exported symbols
Message-ID: <20130510142913.GD12156@gmail.com>
References: <1368178348.8343.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1368178348.8343.1.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 May 2013, Axel Lin wrote:

> Both stmpe_gpio_irq_map() and stmpe_gpio_irq_unmap() are not referenced
> outside of this file, make them static.
> 
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
> ---
>  drivers/gpio/gpio-stmpe.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)

Acked-by: Lee Jones <lee.jones@linaro.org>

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog

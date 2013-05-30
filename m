Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965373Ab3E3Qtt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 12:49:49 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:50432 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965234Ab3E3Qtm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 12:49:42 -0400
MIME-Version: 1.0
In-Reply-To: <1368178348.8343.1.camel@phoenix>
References: <1368178348.8343.1.camel@phoenix>
Date: Thu, 30 May 2013 18:49:42 +0200
Message-ID: <CACRpkdZwCe6DJ=DZHwt6O6Ki2MvPxMr7Mjk6aWX0NoFGc64JGw@mail.gmail.com>
Subject: Re: [PATCH] gpio: stmpe: Staticize non-exported symbols
From: Linus Walleij <linus.walleij@linaro.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Grant Likely <grant.likely@linaro.org>, Lee Jones <lee.jones@linaro.org>,
        Rabin Vincent <rabin.vincent@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 10, 2013 at 11:32 AM, Axel Lin <axel.lin@ingics.com> wrote:

> Both stmpe_gpio_irq_map() and stmpe_gpio_irq_unmap() are not referenced
> outside of this file, make them static.
>
> Signed-off-by: Axel Lin <axel.lin@ingics.com>

Patch applied with Lee's ACK.

Yours,
Linus Walleij

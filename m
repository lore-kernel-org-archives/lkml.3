Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755196Ab3CDC4I (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 21:56:08 -0500
Received: from mail-ia0-f181.google.com ([209.85.210.181]:46466 "EHLO
	mail-ia0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755124Ab3CDC4G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 21:56:06 -0500
MIME-Version: 1.0
In-Reply-To: <5130FD73.9030601@infradead.org>
References: <5130FD73.9030601@infradead.org>
Date: Mon, 4 Mar 2013 03:56:04 +0100
Message-ID: <CACRpkdb83GYi7FNjz-ZgbatTQzgZsB=PdkiCuVFt4TK1s2kM+g@mail.gmail.com>
Subject: Re: [PATCH resend] hsi: fix kernel-doc warnings
From: Linus Walleij <linus.walleij@linaro.org>
To: Randy Dunlap <rdunlap@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Nishanth Menon <nm@ti.com>, Carlos Chinea <carlos.chinea@nokia.com>,
        linux-omap@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 1, 2013 at 8:11 PM, Randy Dunlap <rdunlap@infradead.org> wrote:

> From: Randy Dunlap <rdunlap@infradead.org>
>
> Fix kernel-doc warnings in hsi files:
>
> Warning(include/linux/hsi/hsi.h:136): Excess struct/union/enum/typedef member 'e_handler' description in 'hsi_client'
> Warning(include/linux/hsi/hsi.h:136): Excess struct/union/enum/typedef member 'pclaimed' description in 'hsi_client'
> Warning(include/linux/hsi/hsi.h:136): Excess struct/union/enum/typedef member 'nb' description in 'hsi_client'
> Warning(drivers/hsi/hsi.c:434): No description found for parameter 'handler'
> Warning(drivers/hsi/hsi.c:434): Excess function parameter 'cb' description in 'hsi_register_port_event'
>
> Don't document "private:" fields with kernel-doc notation.
> If you want to leave them fully documented, that's OK, but
> then don't mark them as "private:".
>
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Cc: Carlos Chinea <carlos.chinea@nokia.com>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: linux-kernel@vger.kernel.org
> Cc: linux-omap@vger.kernel.org
> Acked-by: Nishanth Menon <nm@ti.com>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

HSI is basically orphaned FTM.

Andrew can you pick this into your orphanage?

Yours,
Linus Walleij

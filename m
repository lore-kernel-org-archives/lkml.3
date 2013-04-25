Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756773Ab3DYIYw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 04:24:52 -0400
Received: from mail-ia0-f179.google.com ([209.85.210.179]:53396 "EHLO
	mail-ia0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755554Ab3DYIYu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 04:24:50 -0400
MIME-Version: 1.0
In-Reply-To: <1366279934-30761-7-git-send-email-lee.jones@linaro.org>
References: <1366279934-30761-1-git-send-email-lee.jones@linaro.org>
	<1366279934-30761-7-git-send-email-lee.jones@linaro.org>
Date: Thu, 25 Apr 2013 10:24:49 +0200
Message-ID: <CACRpkdZ0WTSx814t_N72Mmb=qG+AtW92m2gFvRjg0DTOiQyQLQ@mail.gmail.com>
Subject: Re: [PATCH 06/32] ARM: ux500: Strip out duplicate USB DMA configuration
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

On Thu, Apr 18, 2013 at 12:11 PM, Lee Jones <lee.jones@linaro.org> wrote:

> For the moment at least, the TX and RX channels for DB8500 USB are
> identical, so this patch generalises them into a single structure
> and passes it twice. Once as the TX and again for the RX configuration.
> We're keeping the infrastructure the same i.e. passing the TX and RX
> separately in case they start to differ on latter incarnations of the
> platform.
>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij

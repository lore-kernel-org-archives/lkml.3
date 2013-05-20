Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757643Ab3ETScz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 14:32:55 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:52634 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752796Ab3ETScx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 14:32:53 -0400
MIME-Version: 1.0
In-Reply-To: <1369064471-30613-1-git-send-email-lars@metafoo.de>
References: <1369064471-30613-1-git-send-email-lars@metafoo.de>
Date: Mon, 20 May 2013 20:32:53 +0200
Message-ID: <CACRpkdaFD5aQnXAiSXmwvYbKjiUrXdw680KJQaNNOODcvuJnAQ@mail.gmail.com>
Subject: Re: [PATCH] drivers/rtc/rtc-pl031.c: Pass correct pointer to free_irq()
From: Linus Walleij <linus.walleij@linaro.org>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        rtc-linux@googlegroups.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 20, 2013 at 5:41 PM, Lars-Peter Clausen <lars@metafoo.de> wrote:

> free_irq() expects the same pointer that was passed to request_irq(), otherwise
> the IRQ is not freed.
>
> The issue was found using the following coccinelle script:

Good job!
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij

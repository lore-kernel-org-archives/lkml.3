Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752927Ab3C0MyF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 08:54:05 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:52816 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752277Ab3C0MyD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 08:54:03 -0400
MIME-Version: 1.0
In-Reply-To: <1363873784-27378-1-git-send-email-fabio.baltieri@linaro.org>
References: <1363873784-27378-1-git-send-email-fabio.baltieri@linaro.org>
Date: Wed, 27 Mar 2013 13:54:03 +0100
Message-ID: <CACRpkdaAiWQ-j1jsPZzE+FxQU2fUhc1vqq+tp2fV8Tmf3sbR0A@mail.gmail.com>
Subject: Re: [PATCH] mfd: ab8500-core: Ignore masked out interrupts
From: Linus Walleij <linus.walleij@linaro.org>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Anton Vorontsov <cbouatmailru@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        Fabio Baltieri <fabio.baltieri@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 21, 2013 at 2:49 PM, Fabio Baltieri
<fabio.baltieri@linaro.org> wrote:

> AB8500 asserts LATCH bits for masked out interrupts.  This patch
> explicitly masks those out using the cached mask value to prevent
> handle_nested_irq() being called for masked IRQ on the same register as
> unmasked ones.
>
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
> Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>

Sam, ping on this.

Yours,
Linus Walleij

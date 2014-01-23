Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756088AbaAWHjy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 02:39:54 -0500
Received: from mail-ob0-f182.google.com ([209.85.214.182]:49290 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755293AbaAWHjv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 02:39:51 -0500
MIME-Version: 1.0
In-Reply-To: <1390319718-12285-1-git-send-email-nicolas.ferre@atmel.com>
References: <1390319718-12285-1-git-send-email-nicolas.ferre@atmel.com>
Date: Thu, 23 Jan 2014 08:39:50 +0100
Message-ID: <CACRpkdamYAUj3nVb08ABzEw4P5YvRpXhbQce96BShHX_R7PQ-w@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: at91: use locked variant of irq_set_handler
From: Linus Walleij <linus.walleij@linaro.org>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Boris BREZILLON <b.brezillon@overkiz.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 21, 2014 at 4:55 PM, Nicolas Ferre <nicolas.ferre@atmel.com> wrote:

> When setting the gpio irq type, use the __irq_set_handler_locked()
> variant instead of the irq_set_handler() to prevent false
> spinlock recursion warning.
>
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> Cc: stable <stable@vger.kernel.org> # v3.12

Patch applied for fixes.

Yours,
Linus Walleij

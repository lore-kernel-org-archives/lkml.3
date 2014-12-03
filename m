Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752105AbaLCLXo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 06:23:44 -0500
Received: from mail-ig0-f177.google.com ([209.85.213.177]:41199 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751261AbaLCLXm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 06:23:42 -0500
MIME-Version: 1.0
In-Reply-To: <1416321825-17776-1-git-send-email-nicolas.ferre@atmel.com>
References: <1416321825-17776-1-git-send-email-nicolas.ferre@atmel.com>
Date: Wed, 3 Dec 2014 12:23:41 +0100
Message-ID: <CACRpkdY3ZdifC78JkAoFS+1A=rt_0BtLDSf0dM7MnH3Y79nYsA@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: at91: enhance (debugfs) at91_gpio_dbg_show
From: Linus Walleij <linus.walleij@linaro.org>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Matthieu Crapet <mcrapet@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 18, 2014 at 3:43 PM, Nicolas Ferre <nicolas.ferre@atmel.com> wrote:

> From: Matthieu Crapet <mcrapet@gmail.com>
>
> When a pin is configured as GPIO, print also direction (input or output).
>
> Signed-off-by: Matthieu Crapet <mcrapet@gmail.com>
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>

Patch applied.

Yours,
Linus Walleij

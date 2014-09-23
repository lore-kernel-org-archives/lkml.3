Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755570AbaIWOpz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 10:45:55 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:59951 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751785AbaIWOpx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 10:45:53 -0400
MIME-Version: 1.0
In-Reply-To: <1410258037-32024-1-git-send-email-pramod.gurav@smartplayin.com>
References: <1410258037-32024-1-git-send-email-pramod.gurav@smartplayin.com>
Date: Tue, 23 Sep 2014 16:45:52 +0200
Message-ID: <CACRpkdZN3CzK2dTSijQtUgahHCfijBGbg6ziJYMJeh=4ngm8aQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] pinctrl: at91: Fix failure path in at91_gpio_probe path
From: Linus Walleij <linus.walleij@linaro.org>
To: Pramod Gurav <pramod.gurav@smartplayin.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 9, 2014 at 12:20 PM, Pramod Gurav
<pramod.gurav@smartplayin.com> wrote:

> This fixes the whole error handling in probe function by capturing and
> returning error values on kernel function like clk_prepare,
> clk_enable, gpiochip_add etc.
>
> CC: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
> CC: Linus Walleij <linus.walleij@linaro.org>
> Signed-off-by: Pramod Gurav <pramod.gurav@smartplayin.com>
> ---
>
> Changes since v1:
>   Used PTR_ERR instead of IS_ERR as per Linus's review.

Patch applied.

Yours,
Linus Walleij

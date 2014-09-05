Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756425AbaIEIEV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 04:04:21 -0400
Received: from mail-ob0-f178.google.com ([209.85.214.178]:54164 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756387AbaIEIEP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 04:04:15 -0400
MIME-Version: 1.0
In-Reply-To: <1409420113-13731-1-git-send-email-pramod.gurav@smartplayin.com>
References: <1409420113-13731-1-git-send-email-pramod.gurav@smartplayin.com>
Date: Fri, 5 Sep 2014 10:04:14 +0200
Message-ID: <CACRpkdYceGArp0Qhm23z6pSSfHGHRn6HawZZUzKz_2GhN+1MqA@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: adi2: Remove duplicate gpiochip_remove_pin_ranges
 from remove function
From: Linus Walleij <linus.walleij@linaro.org>
To: Pramod Gurav <pramod.gurav@smartplayin.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sonic Zhang <sonic.zhang@analog.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 30, 2014 at 7:35 PM, Pramod Gurav
<pramod.gurav@smartplayin.com> wrote:

> This patch removes call to gpiochip_remove_pin_ranges() from platform_driver remove
> function as it will anway be called by gpiochip_remove().
>
> CC: Sonic Zhang <sonic.zhang@analog.com>
> CC: Linus Walleij <linus.walleij@linaro.org>
> Signed-off-by: Pramod Gurav <pramod.gurav@smartplayin.com>

Patch applied.

Yours,
Linus Walleij

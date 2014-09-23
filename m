Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755339AbaIWKXf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 06:23:35 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:54242 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755244AbaIWKXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 06:23:34 -0400
MIME-Version: 1.0
In-Reply-To: <1410249952-12456-1-git-send-email-pramod.gurav@smartplayin.com>
References: <1410249952-12456-1-git-send-email-pramod.gurav@smartplayin.com>
Date: Tue, 23 Sep 2014 12:23:33 +0200
Message-ID: <CACRpkdZNvwjLpjSz6ZMg1TU-e3E0jS4KmpG31PCzXy9AOh7D5g@mail.gmail.com>
Subject: Re: [PATCH v2] pinctrl: lantiq: Release gpiochip resources in fail case
From: Linus Walleij <linus.walleij@linaro.org>
To: Pramod Gurav <pramod.gurav@smartplayin.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        John Crispin <blogic@openwrt.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 9, 2014 at 10:05 AM, Pramod Gurav
<pramod.gurav@smartplayin.com> wrote:

> This patch releases gpiochip resources with of_gpiochip_remove
> and gpiochip_remove in failure cases.
>
> CC: John Crispin <blogic@openwrt.org>
> CC: Linus Walleij <linus.walleij@linaro.org>
> Signed-off-by: Pramod Gurav <pramod.gurav@smartplayin.com>
> ---
>
> Changes since v1:
>  Dropped call to of_gpiochip_remove() when ltq_pinctrl_register fails as
>  gpiochip_remove() calls of_gpiochip_remove()

Patch applied.

Yours,
Linus Walleij

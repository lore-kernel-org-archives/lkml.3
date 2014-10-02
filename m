Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751513AbaJBIBJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 04:01:09 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:65168 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300AbaJBIBH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 04:01:07 -0400
MIME-Version: 1.0
In-Reply-To: <1412234421-11065-1-git-send-email-thierry.reding@gmail.com>
References: <1412234421-11065-1-git-send-email-thierry.reding@gmail.com>
Date: Thu, 2 Oct 2014 10:01:06 +0200
Message-ID: <CACRpkdYu3W9Y10UBtEKaOP+k3bzZQLD4tM9gXpLe9UAtjk7cdw@mail.gmail.com>
Subject: Re: [PATCH] gpio: pch: Build context save/restore only for PM
From: Linus Walleij <linus.walleij@linaro.org>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Alexandre Courbot <gnurou@gmail.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 2, 2014 at 9:20 AM, Thierry Reding <thierry.reding@gmail.com> wrote:

> From: Thierry Reding <treding@nvidia.com>
>
> The pch_gpio_save_reg_conf() and pch_gpio_restore_reg_conf() functions
> are only used in pch_gpio_suspend() and pch_gpio_resume(), respectively.
> Since the latter are only built if PM is enabled, make the former build
> under the same conditions.
>
> Signed-off-by: Thierry Reding <treding@nvidia.com>

Patch applied.

Yours,
Linus Walleij

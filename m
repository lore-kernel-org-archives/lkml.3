Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752793AbaEBWSj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 18:18:39 -0400
Received: from mail-ob0-f173.google.com ([209.85.214.173]:55681 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750807AbaEBWSh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 18:18:37 -0400
MIME-Version: 1.0
In-Reply-To: <1398437662-19936-1-git-send-email-thierry.reding@gmail.com>
References: <1398437662-19936-1-git-send-email-thierry.reding@gmail.com>
Date: Fri, 2 May 2014 15:18:36 -0700
Message-ID: <CACRpkdZ1m2AuuJt_AK1JimND0suisjYaPyiQJtqra3a3LkUKmA@mail.gmail.com>
Subject: Re: [PATCH] gpio: Fix gpio_get -> gpiod_get typo in kernel-doc
From: Linus Walleij <linus.walleij@linaro.org>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Alexandre Courbot <gnurou@gmail.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 25, 2014 at 7:54 AM, Thierry Reding
<thierry.reding@gmail.com> wrote:

> From: Thierry Reding <treding@nvidia.com>
>
> The function is called gpiod_get(), not gpio_get(). Fix the kernel-doc
> comment to match the name.
>
> Signed-off-by: Thierry Reding <treding@nvidia.com>

Patch applied.

Yours,
Linus Walleij

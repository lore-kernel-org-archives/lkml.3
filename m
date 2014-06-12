Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932719AbaFLISK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 04:18:10 -0400
Received: from mail-ob0-f179.google.com ([209.85.214.179]:42946 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932637AbaFLISG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 04:18:06 -0400
MIME-Version: 1.0
In-Reply-To: <20140602231423.GF11004@atomide.com>
References: <1398266889-17489-1-git-send-email-thierry.reding@gmail.com>
	<1398266889-17489-2-git-send-email-thierry.reding@gmail.com>
	<CACRpkdbF3N5bFY1sFkabDHO7J0F8sb1uU0xL+mjkuF-z7VocMQ@mail.gmail.com>
	<20140602230457.GE11004@atomide.com>
	<20140602231423.GF11004@atomide.com>
Date: Thu, 12 Jun 2014 10:18:05 +0200
Message-ID: <CACRpkdb2Yd4_+7d2PDdsKj5hYLNdtnyvO8B3yVVjR3_tWm8xHg@mail.gmail.com>
Subject: Re: [PATCH 2/2] gpio: of: Allow -gpio suffix for property names
From: Linus Walleij <linus.walleij@linaro.org>
To: Tony Lindgren <tony@atomide.com>
Cc: Thierry Reding <thierry.reding@gmail.com>,
        Alexandre Courbot <gnurou@gmail.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-OMAP <linux-omap@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 3, 2014 at 1:14 AM, Tony Lindgren <tony@atomide.com> wrote:

> Looks like something like below fixes the issue.
>
> Regards,
>
> Tony
>
> 8< -----------------------
> From: Tony Lindgren <tony@atomide.com>
> Date: Mon, 2 Jun 2014 16:13:46 -0700
> Subject: [PATCH] gpio: of: Fix handling for deferred probe for -gpio suffix
>
> Commit dd34c37aa3e (gpio: of: Allow -gpio suffix for property names)
> added parsing for both -gpio and -gpios suffix but also changed
> the handling for deferred probe unintentionally. Because of the
> looping the second name will now return -ENOENT instead of
> -EPROBE_DEFER. Fix the issue by breaking out of the loop if
> -EPROBE_DEFER is encountered.
>
> Signed-off-by: Tony Lindgren <tony@atomide.com>

Patch applied for fixes with Thierry's Reveiwed-by tag.

Yours,
Linus Walleij

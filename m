Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753066AbaKRDHQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 22:07:16 -0500
Received: from mail-ig0-f169.google.com ([209.85.213.169]:59911 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751213AbaKRDHO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 22:07:14 -0500
MIME-Version: 1.0
In-Reply-To: <1416234719-16310-1-git-send-email-geert+renesas@glider.be>
References: <1416234719-16310-1-git-send-email-geert+renesas@glider.be>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Tue, 18 Nov 2014 12:06:53 +0900
Message-ID: <CAAVeFuJ_QQLue7Xo8jyG+wyQJD5JCxzJBC39SiK+t0HJu5b13A@mail.gmail.com>
Subject: Re: [PATCH] gpio: Check if base is positive before calling gpio_is_valid()
To: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 17, 2014 at 11:31 PM, Geert Uytterhoeven
<geert+renesas@glider.be> wrote:
> It doesn't make much sense to make some (possible expensive) calls to
> gpio_is_valid() first, and to ignore the result if the base number is
> negative. Check for a positive base number first.

Sure.

Reviewed-by: Alexandre Courbot <acourbot@nvidia.com>

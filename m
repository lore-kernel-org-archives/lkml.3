Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756171AbaAWIW1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 03:22:27 -0500
Received: from mail-ob0-f171.google.com ([209.85.214.171]:42584 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753337AbaAWIW0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 03:22:26 -0500
MIME-Version: 1.0
In-Reply-To: <1390349441-23853-1-git-send-email-markus.mayer@linaro.org>
References: <1390349441-23853-1-git-send-email-markus.mayer@linaro.org>
Date: Thu, 23 Jan 2014 09:22:25 +0100
Message-ID: <CACRpkdYSh+h4za6tMR1WuPXRo6jPA7TM2XkCYPc-f6vwuaFwcg@mail.gmail.com>
Subject: Re: [PATCH] gpio: bcm281xx: Centralize register locking
From: Linus Walleij <linus.walleij@linaro.org>
To: Markus Mayer <markus.mayer@linaro.org>
Cc: Linaro Patches <patches@linaro.org>,
        Linux GPIO List <linux-gpio@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Tim Kryger <tim.kryger@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 22, 2014 at 1:10 AM, Markus Mayer <markus.mayer@linaro.org> wrote:

> Rather than unlock/re-lock for every write access, unlock a GPIO when
> it is requested and re-lock it when it is freed. As a result, the GPIO
> helper functions no longer have to deal with unlocking and re-locking
> the register.
>
> In addition, only unlock a specific GPIO rather than unlocking the
> entire GPIO bank as before.
>
> Signed-off-by: Markus Mayer <markus.mayer@linaro.org>
> Reviewed-by: Tim Kryger <tim.kryger@linaro.org>

Patch applied (for v3.15)

Yours,
Linus Walleij

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932275Ab3LDMqR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 07:46:17 -0500
Received: from mail-ob0-f169.google.com ([209.85.214.169]:57220 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932176Ab3LDMqQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 07:46:16 -0500
MIME-Version: 1.0
In-Reply-To: <1386041471-1826-1-git-send-email-acourbot@nvidia.com>
References: <1386041471-1826-1-git-send-email-acourbot@nvidia.com>
Date: Wed, 4 Dec 2013 13:46:15 +0100
Message-ID: <CACRpkdayNyV3znNVs3eagNxwtVJCiYS=aS0LM0P+pR2J4Fk-Bg@mail.gmail.com>
Subject: Re: [PATCH] gpio: rewrite gpiochip_offset_to_desc()
From: Linus Walleij <linus.walleij@linaro.org>
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 3, 2013 at 4:31 AM, Alexandre Courbot <acourbot@nvidia.com> wrote:

> gpiochip_offset_to_desc() was using gpio_to_desc(), which directly
> addresses the global GPIO array we are hoping to get rid of someday.
> Reimplement it using the descriptor array of the chip itself, after
> checking the requested offset is within the valid bounds of the chip.
>
> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>

Patch applied.

Yours,
Linus Walleij

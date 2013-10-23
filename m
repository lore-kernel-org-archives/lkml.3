Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752016Ab3JWINc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 04:13:32 -0400
Received: from mail-oa0-f45.google.com ([209.85.219.45]:56315 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751940Ab3JWINY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 04:13:24 -0400
MIME-Version: 1.0
In-Reply-To: <1382307299-22587-4-git-send-email-acourbot@nvidia.com>
References: <1382307299-22587-1-git-send-email-acourbot@nvidia.com>
	<1382307299-22587-4-git-send-email-acourbot@nvidia.com>
Date: Wed, 23 Oct 2013 10:13:23 +0200
Message-ID: <CACRpkdaXtE7TEGd0cV7Frw4MReppowRJPQTTXUM3K4B-62YCnw@mail.gmail.com>
Subject: Re: [PATCH 3/3] gpiolib: make GPIO_DEVRES depend on GPIOLIB
From: Linus Walleij <linus.walleij@linaro.org>
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alexandre Courbot <gnurou@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 21, 2013 at 12:14 AM, Alexandre Courbot <acourbot@nvidia.com> wrote:

> Current Kconfig allows GPIO_DEVRES to be selected and compiled without
> GPIOLIB. This does not make sense anymore since GPIOLIB has become the
> exclusive way to deal with GPIOs. This patch makes GPIO_DEVRES available
> only if GPIOLIB is selected.
>
> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>

Hm, I wonder about this. Are, or where there ever consumers of generic
GPIO using devres without gpiolib?

Yours,
Linus Walleij

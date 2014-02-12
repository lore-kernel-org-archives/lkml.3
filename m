Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752804AbaBLQQj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 11:16:39 -0500
Received: from mail-oa0-f43.google.com ([209.85.219.43]:63637 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751572AbaBLQQi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 11:16:38 -0500
MIME-Version: 1.0
In-Reply-To: <1391935435-29002-2-git-send-email-acourbot@nvidia.com>
References: <1391935435-29002-1-git-send-email-acourbot@nvidia.com>
	<1391935435-29002-2-git-send-email-acourbot@nvidia.com>
Date: Wed, 12 Feb 2014 17:16:37 +0100
Message-ID: <CACRpkdZm1pdJxfyDn3mYaYVNQT=TDGh1oyLBQjBfVziJ8drY3A@mail.gmail.com>
Subject: Re: [PATCH 2/2] gpiolib: ACPI: remove gpio_to_desc() usage
From: Linus Walleij <linus.walleij@linaro.org>
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        Jean-Jacques Hiblot <jjhiblot@traphandler.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 9, 2014 at 9:43 AM, Alexandre Courbot <acourbot@nvidia.com> wrote:

> gpio_to_desc() must die. Replace one of its usage by the
> newly-introduced gpiochip_get_desc() function.
>
> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>

Patch applied with Mika's review tag.

Yours,
Linus Walleij

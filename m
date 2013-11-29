Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753355Ab3K2J37 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 04:29:59 -0500
Received: from mail-oa0-f43.google.com ([209.85.219.43]:58770 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751892Ab3K2J3y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 04:29:54 -0500
MIME-Version: 1.0
In-Reply-To: <1385202890-9511-1-git-send-email-acourbot@nvidia.com>
References: <1385202890-9511-1-git-send-email-acourbot@nvidia.com>
Date: Fri, 29 Nov 2013 10:29:54 +0100
Message-ID: <CACRpkdbun289Y1fu-=sB77ESg6E15hRCcd+NYmwk57MoxkoTMQ@mail.gmail.com>
Subject: Re: [PATCH] gpiolib: use platform GPIO mappings as fallback
From: Linus Walleij <linus.walleij@linaro.org>
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 23, 2013 at 11:34 AM, Alexandre Courbot <acourbot@nvidia.com> wrote:

> For platforms that use device tree or ACPI as the standard way to look
> GPIOs up, allow the platform-defined GPIO mappings to be used as a
> fallback. This may be useful for platforms that need extra GPIOs mappings
> not defined by the firmware.
>
> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>

Applied for fixes. I was considering applying it for the next
kernel but it depends on the former patches and we should
expect a bit of extra fuzz now with the new API.

Yours,
Linus Walleij

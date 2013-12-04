Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755716Ab3LDM2o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 07:28:44 -0500
Received: from mail-oa0-f43.google.com ([209.85.219.43]:54646 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755037Ab3LDM2m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 07:28:42 -0500
MIME-Version: 1.0
In-Reply-To: <1385980079-20175-1-git-send-email-jonas.jensen@gmail.com>
References: <1385723494-8033-1-git-send-email-jonas.jensen@gmail.com>
	<1385980079-20175-1-git-send-email-jonas.jensen@gmail.com>
Date: Wed, 4 Dec 2013 13:28:41 +0100
Message-ID: <CACRpkdaT2fmfAwuyPTuF2Pim-_g5Avd_ViwQ069qRLFM9YBvWQ@mail.gmail.com>
Subject: Re: [PATCH] gpio: MOXA ART: rename moxart_gpio_base to base
From: Linus Walleij <linus.walleij@linaro.org>
To: Jonas Jensen <jonas.jensen@gmail.com>
Cc: "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 2, 2013 at 11:27 AM, Jonas Jensen <jonas.jensen@gmail.com> wrote:

> Renaming "moxart_gpio_base" to "base" allows better fit,
> remove line breaks in moxart_gpio_get().
>
> While doing trivial cleanup, also remove fields initialized
> with zero in moxart_template_chip.
>
> Signed-off-by: Jonas Jensen <jonas.jensen@gmail.com>

Patch applied!

Thanks!
Linus Walleij

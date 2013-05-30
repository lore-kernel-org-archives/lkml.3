Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757517Ab3E3SOQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 14:14:16 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:65161 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756627Ab3E3SOH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 14:14:07 -0400
MIME-Version: 1.0
In-Reply-To: <1369206634-6778-5-git-send-email-avinashphilip@ti.com>
References: <1369206634-6778-1-git-send-email-avinashphilip@ti.com>
	<1369206634-6778-5-git-send-email-avinashphilip@ti.com>
Date: Thu, 30 May 2013 20:14:06 +0200
Message-ID: <CACRpkdaKjfyJWbr3HjHWCeFPeg0mrwDZ+G7Fn_y8Z_PGg2JM2A@mail.gmail.com>
Subject: Re: [PATCH 04/11] ARM: davinci: da8xx: creation of gpio platform device
From: Linus Walleij <linus.walleij@linaro.org>
To: Philip Avinash <avinashphilip@ti.com>
Cc: "Nori, Sekhar" <nsekhar@ti.com>,
        ext Kevin Hilman <khilman@deeprootsystems.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@secretlab.ca>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        KV Sujith <sujithkv@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 22, 2013 at 9:10 AM, Philip Avinash <avinashphilip@ti.com> wrote:

> From: KV Sujith <sujithkv@ti.com>
>
> gpio controller resource information being associated with
> davinci_soc_info structure and not created any device. Hence davinci
> gpio didn't fall under proper device model. This patch creates gpio
> davinci as a platform device for da8xx platforms.
>
> - Add Memory and IRQ resources for DA8xx.
> - Register GPIO platform driver for DA8xx.
> - Add da8xx_register_gpio API to create platform device for da8xx
>   platforms.
>
> Signed-off-by: KV Sujith <sujithkv@ti.com>
> Signed-off-by: Philip Avinash <avinashphilip@ti.com>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij

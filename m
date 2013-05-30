Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757381Ab3E3SGK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 14:06:10 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:52303 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757315Ab3E3SGB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 14:06:01 -0400
MIME-Version: 1.0
In-Reply-To: <1369206634-6778-2-git-send-email-avinashphilip@ti.com>
References: <1369206634-6778-1-git-send-email-avinashphilip@ti.com>
	<1369206634-6778-2-git-send-email-avinashphilip@ti.com>
Date: Thu, 30 May 2013 20:06:00 +0200
Message-ID: <CACRpkdbVY+ogiLK-WtwmPJORcwheSTHwq86uPwUB0PYxQ+=oCA@mail.gmail.com>
Subject: Re: [PATCH 01/11] ARM: davinci: GPIO: Add platform data structure
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
> Add struct davinci_gpio_platform_data davinci gpio module.
>
> Signed-off-by: KV Sujith <sujithkv@ti.com>
> Signed-off-by: Philip Avinash <avinashphilip@ti.com>

Usually I squash such patches into the first patch making use of it,
but the spirit is good so:

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij

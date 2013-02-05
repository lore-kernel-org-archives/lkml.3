Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756443Ab3BERP7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 12:15:59 -0500
Received: from mail-ia0-f178.google.com ([209.85.210.178]:34987 "EHLO
	mail-ia0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756038Ab3BERPz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 12:15:55 -0500
MIME-Version: 1.0
In-Reply-To: <1359822572-26009-6-git-send-email-acourbot@nvidia.com>
References: <1359822572-26009-1-git-send-email-acourbot@nvidia.com>
	<1359822572-26009-6-git-send-email-acourbot@nvidia.com>
Date: Tue, 5 Feb 2013 18:15:54 +0100
Message-ID: <CACRpkdaC3pu3tBZrw0Az226XEt6+AzJ_NiiCaLwV9o6NUZ8MQw@mail.gmail.com>
Subject: Re: [PATCH 4/9] gpiolib: use gpio_chips list in sysfs ops
From: Linus Walleij <linus.walleij@linaro.org>
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: Grant Likely <grant.likely@secretlab.ca>, Arnd Bergmann <arnd@arndb.de>,
        linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, gnurou@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 2, 2013 at 5:29 PM, Alexandre Courbot <acourbot@nvidia.com> wrote:

> This makes the code both simpler and faster compared to parsing the GPIO
> number space.
>
> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij

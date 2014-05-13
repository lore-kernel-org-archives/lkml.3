Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759856AbaEMJZo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 05:25:44 -0400
Received: from mail-oa0-f53.google.com ([209.85.219.53]:50399 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759397AbaEMJZm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 05:25:42 -0400
MIME-Version: 1.0
In-Reply-To: <7225229.HqAtN0I8Si@wuerfel>
References: <7225229.HqAtN0I8Si@wuerfel>
Date: Tue, 13 May 2014 11:25:42 +0200
Message-ID: <CACRpkdZakDfcsCPAw0JbffyfSXVjHzyVoCTkVx_3hy19QXpXDQ@mail.gmail.com>
Subject: Re: [PATCH] gpio: include linux/bug.h in interface header
From: Linus Walleij <linus.walleij@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alexandre Courbot <acourbot@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 8, 2014 at 3:42 PM, Arnd Bergmann <arnd@arndb.de> wrote:

> Today's linux-next kernel started showing build errors for the
> use of WARN_ON in linux/gpio/consumer.h:
>
> In file included from drivers/video/backlight/pwm_bl.c:13:0:
> include/linux/gpio/consumer.h: In function 'gpiod_put':
> include/linux/gpio/consumer.h:81:2: error: implicit declaration of function 'WARN_ON' [-Werror=implicit-function-declaration]
>
> It's not clear why this never happened before, but this patch
> fixes it by including the header that contains the defintion
> of this macro.
>
> Signed-off-by: Arnd Bergmann <arnd@arnd.de>

Patch applied!

Yours,
Linus Walleij

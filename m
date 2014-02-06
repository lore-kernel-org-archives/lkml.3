Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753249AbaBFQf5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 11:35:57 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:57328 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370AbaBFQf4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 11:35:56 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Jingoo Han <jg1.han@samsung.com>, linux-pwm@vger.kernel.org,
        "'Eric Miao'" <eric.y.miao@gmail.com>,
        "'Linus Walleij'" <linus.walleij@linaro.org>,
        linux-kernel@vger.kernel.org,
        "'Thierry Reding'" <thierry.reding@gmail.com>,
        "'Russell King - ARM Linux'" <linux@arm.linux.org.uk>
Subject: Re: [PATCH] backlight: add PWM dependencies
Date: Thu, 06 Feb 2014 17:35:46 +0100
Message-ID: <2319331.qA0baufx1C@wuerfel>
User-Agent: KMail/4.11.3 (Linux/3.11.0-15-generic; KDE/4.11.3; x86_64; ; )
In-Reply-To: <201402061708.05845.arnd@arndb.de>
References: <1391518634-6472-1-git-send-email-linus.walleij@linaro.org> <000001cf230c$60ec1ca0$22c455e0$%han@samsung.com> <201402061708.05845.arnd@arndb.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:lfV73Yg7VcsdS55UtURvjFvEEz8xdnWiMH1HruFhPqO
 7/Xu7gX/hlh72CLGjNvjLykOL9k+Py+n2G1gII3t8s/Yw1BktM
 F5fI216D/i2rtVbK4Q2uBoYI/tqefh5x02vO5OrhL6lryZ4XP0
 CyTAo2g37vIz1QOEearVVRFD3ozygZHF6oFI3RQMJ6lDJJiYgv
 wdFAdaNjIMhZrCyeVApb+1MGFg4b7v9rxlVqJPUxju6h8+zdAm
 mRCoV0i8AJie2a2x6hN6eSo3DPsY86V23dSiLuGX2WQVAyDKFc
 IdKrt3P0JWXahCQk/FURJpZoUr1yB+ZQfWGOUoqkpU3B0rP/Q/
 Nsp7ukVQED+LaD9HRYyQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 06 February 2014 17:08:05 Arnd Bergmann wrote:
> 
> Finally, I have recently encountered a couple of drivers
> (BACKLIGHT_LM3630A, BACKLIGHT_LP855X, BACKLIGHT_LP8788) that use
> the PWM interfaces but are missing a 'depends on PWM'. This is
> strictly speaking a different problem, but we could try to solve
> it at the same time.
> 

D'oh. I just realized this is the bug that started the thread
with Linus' patch. Apparently I found one more instance that
he didn't find though.

	Arnd

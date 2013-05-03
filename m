Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762658Ab3ECIUt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 04:20:49 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:55497 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753136Ab3ECIUr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 04:20:47 -0400
MIME-Version: 1.0
In-Reply-To: <001901ce47c7$7285d300$57917900$@samsung.com>
References: <001901ce47c7$7285d300$57917900$@samsung.com>
Date: Fri, 3 May 2013 10:20:46 +0200
Message-ID: <CACRpkdaE4DEXRG-wRG5Mutnko3G18vPCbgDYLa4mrPLCLVyPZw@mail.gmail.com>
Subject: Re: [PATCH 11/42] rtc: rtc-coh901331: remove unnecessary platform_set_drvdata()
From: Linus Walleij <linus.walleij@linaro.org>
To: Jingoo Han <jg1.han@samsung.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 3, 2013 at 8:28 AM, Jingoo Han <jg1.han@samsung.com> wrote:

> The driver core clears the driver data to NULL after device_release
> or on probe failure, since commit 0998d0631001288a5974afc0b2a5f568bcdecb4d
> (device-core: Ensure drvdata = NULL when no driver is bound).
> Thus, it is not needed to manually clear the device driver data to NULL.
>
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij

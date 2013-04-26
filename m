Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758276Ab3DZIOE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 04:14:04 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:45429 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757944Ab3DZIN7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 04:13:59 -0400
MIME-Version: 1.0
In-Reply-To: <1366734653-488286-21-git-send-email-arnd@arndb.de>
References: <1366734653-488286-1-git-send-email-arnd@arndb.de>
	<1366734653-488286-21-git-send-email-arnd@arndb.de>
Date: Fri, 26 Apr 2013 10:13:59 +0200
Message-ID: <CACRpkda6GpxUf8oPw74A08D0RJKZWir4hqXLjz-fe8Kq02vmDg@mail.gmail.com>
Subject: Re: [PATCH 20/21] MFD: ab8500: export ab8500_gpadc_sw_hw_convert properly
From: Linus Walleij <linus.walleij@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "M'boumba Cedric Madianga" <cedric.madianga@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>,
        Mattias WALLIN <mattias.wallin@stericsson.com>,
        Michel JAOUEN <michel.jaouen@stericsson.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 23, 2013 at 6:30 PM, Arnd Bergmann <arnd@arndb.de> wrote:

> Apparently the ab8500_gpadc_sw_hw_convert function got renamed
> from ab8500_gpadc_convert to ab8500_gpadc_sw_hw_convert in
> commit 734823462 "mfd: ab8500-gpadc: Add gpadc hw conversion",
> but the export for this function did not get changed at the
> same time, causing this allyesconfig error:
>
> ERROR: "ab8500_gpadc_sw_hw_convert" [drivers/hwmon/ab8500.ko] undefined!
>
> This patch fixes the export.
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: M'boumba Cedric Madianga <cedric.madianga@stericsson.com>
> Cc: Lee Jones <lee.jones@linaro.org>
> Cc: Mattias WALLIN <mattias.wallin@stericsson.com>
> Cc: Michel JAOUEN <michel.jaouen@stericsson.com>
> Cc: Samuel Ortiz <sameo@linux.intel.com>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Sam -> please pick this...

Yours,
Linus Walleij

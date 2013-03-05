Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933234Ab3CEEEJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 23:04:09 -0500
Received: from mail-ie0-f176.google.com ([209.85.223.176]:58925 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932602Ab3CEEEI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 23:04:08 -0500
MIME-Version: 1.0
In-Reply-To: <004b01ce1945$79486af0$6bd940d0$%han@samsung.com>
References: <004b01ce1945$79486af0$6bd940d0$%han@samsung.com>
Date: Tue, 5 Mar 2013 05:04:05 +0100
Message-ID: <CACRpkdbb96AitnBxyRcx7XBLEqHx48MzhuV688cCfqepttuPrg@mail.gmail.com>
Subject: Re: [PATCH 1/3] misc: arm-charlcd: use module_platform_driver_probe()
From: Linus Walleij <linus.walleij@linaro.org>
To: Jingoo Han <jg1.han@samsung.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 5, 2013 at 3:02 AM, Jingoo Han <jg1.han@samsung.com> wrote:

> This patch uses module_platform_driver_probe() macro which makes
> the code smaller and simpler.
>
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij

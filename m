Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965147Ab3E3Qo6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 12:44:58 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:34058 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964828Ab3E3Qow (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 12:44:52 -0400
MIME-Version: 1.0
In-Reply-To: <001901ce4a09$e48fe640$adafb2c0$@samsung.com>
References: <001901ce4a09$e48fe640$adafb2c0$@samsung.com>
Date: Thu, 30 May 2013 18:44:52 +0200
Message-ID: <CACRpkdbbRor-y03rufr405VSXkba13vV9J13ajgwXgtkpD0sLw@mail.gmail.com>
Subject: Re: [PATCH 3/7] gpio: rdc321x: remove unnecessary platform_set_drvdata()
From: Linus Walleij <linus.walleij@linaro.org>
To: Jingoo Han <jg1.han@samsung.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 6, 2013 at 5:29 AM, Jingoo Han <jg1.han@samsung.com> wrote:

> The driver core clears the driver data to NULL after device_release
> or on probe failure, since commit 0998d0631001288a5974afc0b2a5f568bcdecb4d
> (device-core: Ensure drvdata = NULL when no driver is bound).
> Thus, it is not needed to manually clear the device driver data to NULL.
>
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>

Patch applied.

Yours,
Linus Walleij

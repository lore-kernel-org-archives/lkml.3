Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753994Ab3EGUCP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 16:02:15 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:33355 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752243Ab3EGUCN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 16:02:13 -0400
MIME-Version: 1.0
In-Reply-To: <003701ce4ae4$39926f20$acb74d60$@samsung.com>
References: <003701ce4ae4$39926f20$acb74d60$@samsung.com>
Date: Tue, 7 May 2013 22:02:13 +0200
Message-ID: <CACRpkda_ca3FyPORzH+HQUAPfghkM12YUomj01uep=d=vQhmHQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] misc: arm-charlcd: remove unnecessary platform_set_drvdata()
From: Linus Walleij <linus.walleij@linaro.org>
To: Jingoo Han <jg1.han@samsung.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 7, 2013 at 7:32 AM, Jingoo Han <jg1.han@samsung.com> wrote:

> The driver core clears the driver data to NULL after device_release
> or on probe failure, since commit 0998d0631001288a5974afc0b2a5f568bcdecb4d
> (device-core: Ensure drvdata = NULL when no driver is bound).
> Thus, it is not needed to manually clear the device driver data to NULL.
>
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij

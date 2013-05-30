Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965308Ab3E3Qrp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 12:47:45 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:33716 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965072Ab3E3Qri (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 12:47:38 -0400
MIME-Version: 1.0
In-Reply-To: <001c01ce4a0a$bb7c58a0$327509e0$@samsung.com>
References: <001c01ce4a0a$bb7c58a0$327509e0$@samsung.com>
Date: Thu, 30 May 2013 18:47:37 +0200
Message-ID: <CACRpkdZv-K=g3JBHtSMyf5wTifk+i-xTFAWsKVaStkCDgjEXOg@mail.gmail.com>
Subject: Re: [PATCH 6/7] gpio: timberdale: remove unnecessary platform_set_drvdata()
From: Linus Walleij <linus.walleij@linaro.org>
To: Jingoo Han <jg1.han@samsung.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 6, 2013 at 5:35 AM, Jingoo Han <jg1.han@samsung.com> wrote:

> The driver core clears the driver data to NULL after device_release
> or on probe failure, since commit 0998d0631001288a5974afc0b2a5f568bcdecb4d
> (device-core: Ensure drvdata = NULL when no driver is bound).
> Thus, it is not needed to manually clear the device driver data to NULL.
>
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>

Patch applied.

Yours,
Linus Walleij

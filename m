Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965391Ab3E3Qsl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 12:48:41 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:38931 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965319Ab3E3QsY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 12:48:24 -0400
MIME-Version: 1.0
In-Reply-To: <001d01ce4a0a$f2e02fb0$d8a08f10$@samsung.com>
References: <001d01ce4a0a$f2e02fb0$d8a08f10$@samsung.com>
Date: Thu, 30 May 2013 18:48:24 +0200
Message-ID: <CACRpkdY-=_yKvZdCvpMuei2koDfk_kj1J=cV=x9uxYEW7whqKQ@mail.gmail.com>
Subject: Re: [PATCH 7/7] gpio: vx855: remove unnecessary platform_set_drvdata()
From: Linus Walleij <linus.walleij@linaro.org>
To: Jingoo Han <jg1.han@samsung.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 6, 2013 at 5:36 AM, Jingoo Han <jg1.han@samsung.com> wrote:

> The driver core clears the driver data to NULL after device_release
> or on probe failure, since commit 0998d0631001288a5974afc0b2a5f568bcdecb4d
> (device-core: Ensure drvdata = NULL when no driver is bound).
> Thus, it is not needed to manually clear the device driver data to NULL.
>
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>

Patch applied.

Yours,
Linus Walleij

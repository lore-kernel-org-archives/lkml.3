Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965293Ab3E3Qq7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 12:46:59 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:45401 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965072Ab3E3Qqw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 12:46:52 -0400
MIME-Version: 1.0
In-Reply-To: <001b01ce4a0a$5076bb90$f16432b0$@samsung.com>
References: <001b01ce4a0a$5076bb90$f16432b0$@samsung.com>
Date: Thu, 30 May 2013 18:46:51 +0200
Message-ID: <CACRpkdYT04ODoYx_i=PET4skFxRDDNMqpUbYNs_W3f3pJg54sQ@mail.gmail.com>
Subject: Re: [PATCH 5/7] gpio: tc3589x: remove unnecessary platform_set_drvdata()
From: Linus Walleij <linus.walleij@linaro.org>
To: Jingoo Han <jg1.han@samsung.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Lee Jones <lee.jones@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 6, 2013 at 5:32 AM, Jingoo Han <jg1.han@samsung.com> wrote:

> The driver core clears the driver data to NULL after device_release
> or on probe failure, since commit 0998d0631001288a5974afc0b2a5f568bcdecb4d
> (device-core: Ensure drvdata = NULL when no driver is bound).
> Thus, it is not needed to manually clear the device driver data to NULL.
>
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>

Patch applied with Lee's ACK.

Yours,
Linus Walleij

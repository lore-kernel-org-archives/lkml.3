Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965182Ab3E3Qps (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 12:45:48 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:60167 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965068Ab3E3Qpm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 12:45:42 -0400
MIME-Version: 1.0
In-Reply-To: <001a01ce4a0a$1a72e9b0$4f58bd10$@samsung.com>
References: <001a01ce4a0a$1a72e9b0$4f58bd10$@samsung.com>
Date: Thu, 30 May 2013 18:45:41 +0200
Message-ID: <CACRpkdYH6+r93f1PLjE5SYQMApKiy24krMr==2u5b8=F=HJxkg@mail.gmail.com>
Subject: Re: [PATCH 4/7] gpio: stmpe: remove unnecessary platform_set_drvdata()
From: Linus Walleij <linus.walleij@linaro.org>
To: Jingoo Han <jg1.han@samsung.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Gabriel Fernandez <gabriel.fernandez@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 6, 2013 at 5:30 AM, Jingoo Han <jg1.han@samsung.com> wrote:

> The driver core clears the driver data to NULL after device_release
> or on probe failure, since commit 0998d0631001288a5974afc0b2a5f568bcdecb4d
> (device-core: Ensure drvdata = NULL when no driver is bound).
> Thus, it is not needed to manually clear the device driver data to NULL.
>
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>

Patch applied.

Yours,
Linus Walleij

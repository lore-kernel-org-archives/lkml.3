Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758891Ab3CGDbb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 22:31:31 -0500
Received: from mail-ia0-f174.google.com ([209.85.210.174]:53145 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754389Ab3CGDb3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 22:31:29 -0500
MIME-Version: 1.0
In-Reply-To: <013a01ce18ad$e45caa10$ad15fe30$%han@samsung.com>
References: <013a01ce18ad$e45caa10$ad15fe30$%han@samsung.com>
Date: Thu, 7 Mar 2013 04:31:29 +0100
Message-ID: <CACRpkdYg1Fk77uJEDqXszKn6UZGNCWMnCqEiffkLVkxU6Y+mbg@mail.gmail.com>
Subject: Re: [rtc-linux] [PATCH 01/24] rtc: rtc-ab3100: use module_platform_driver_probe()
From: Linus Walleij <linus.walleij@linaro.org>
To: rtc-linux@googlegroups.com
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Alessandro Zummo <a.zummo@towertech.it>,
        Jingoo Han <jg1.han@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 4, 2013 at 8:57 AM, Jingoo Han <jg1.han@samsung.com> wrote:

> This patch uses module_platform_driver_probe() macro which makes
> the code smaller and simpler.
>
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij

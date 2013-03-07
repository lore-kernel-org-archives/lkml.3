Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759010Ab3CGDcG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 22:32:06 -0500
Received: from mail-ie0-f171.google.com ([209.85.223.171]:58255 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758924Ab3CGDcC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 22:32:02 -0500
MIME-Version: 1.0
In-Reply-To: <013e01ce18ae$2fd509b0$8f7f1d10$%han@samsung.com>
References: <013a01ce18ad$e45caa10$ad15fe30$%han@samsung.com>
	<013e01ce18ae$2fd509b0$8f7f1d10$%han@samsung.com>
Date: Thu, 7 Mar 2013 04:32:01 +0100
Message-ID: <CACRpkdYRLNKUQJgguJ=vLBHFMncUrkeitOfQS8bSiZow_o+mUQ@mail.gmail.com>
Subject: Re: [rtc-linux] [PATCH 05/24] rtc: rtc-coh901331: use module_platform_driver_probe()
From: Linus Walleij <linus.walleij@linaro.org>
To: rtc-linux@googlegroups.com
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Alessandro Zummo <a.zummo@towertech.it>,
        Jingoo Han <jg1.han@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 4, 2013 at 8:59 AM, Jingoo Han <jg1.han@samsung.com> wrote:

> This patch uses module_platform_driver_probe() macro which makes
> the code smaller and simpler.
>
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752544AbaBJJ0H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 04:26:07 -0500
Received: from mail-oa0-f46.google.com ([209.85.219.46]:63088 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751123AbaBJJ0D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 04:26:03 -0500
MIME-Version: 1.0
In-Reply-To: <000501cf23d9$f0057a80$d0106f80$%han@samsung.com>
References: <000401cf23d9$d1df6e30$759e4a90$%han@samsung.com>
	<000501cf23d9$f0057a80$d0106f80$%han@samsung.com>
Date: Mon, 10 Feb 2014 10:26:03 +0100
Message-ID: <CACRpkdYCgxGMeE2ggcs0=XSQ4ta01xGDFVAeBka0TT3q=6--CQ@mail.gmail.com>
Subject: Re: [rtc-linux] [PATCH 1/4] rtc: rtc-coh901331: Use devm_ioremap_resource()
From: Linus Walleij <linus.walleij@linaro.org>
To: "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Jingoo Han <jg1.han@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 7, 2014 at 8:55 AM, Jingoo Han <jg1.han@samsung.com> wrote:

> Use devm_ioremap_resource() in order to make the code simpler,
> and remove redundant return value check of platform_get_resource()
> because the value is checked by devm_ioremap_resource().
>
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932152Ab3CGIIe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 03:08:34 -0500
Received: from mail-ie0-f177.google.com ([209.85.223.177]:61567 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754451Ab3CGIIc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 03:08:32 -0500
MIME-Version: 1.0
In-Reply-To: <1362568712-13586-2-git-send-email-thomas.abraham@linaro.org>
References: <1362568712-13586-1-git-send-email-thomas.abraham@linaro.org>
	<1362568712-13586-2-git-send-email-thomas.abraham@linaro.org>
Date: Thu, 7 Mar 2013 09:08:31 +0100
Message-ID: <CACRpkdZ37FutKzwSSF7w425Nh=jPUU-FXf48HPs3oUXO9sJ0oA@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] pinctrl: exynos: add exynos5250 SoC specific data
From: Linus Walleij <linus.walleij@linaro.org>
To: Thomas Abraham <thomas.abraham@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, kgene.kim@samsung.com,
        t.figa@samsung.com, patches@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 6, 2013 at 12:18 PM, Thomas Abraham
<thomas.abraham@linaro.org> wrote:

> Add Samsung Exynos5250 SoC specific data to enable pinctrl support for
> all platforms based on Exynos5250.
>
> Signed-off-by: Thomas Abraham <thomas.abraham@linaro.org>
> Reviewed-by: Tomasz Figa <t.figa@samsung.com>
> Acked-by: Linus Walleij <linus.walleij@linaro.org>

So shall I merge these three patches to the pinctrl tree or not?

Yours,
Linus Walleij

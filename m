Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761886AbbA2Jsj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 04:48:39 -0500
Received: from mail-ie0-f170.google.com ([209.85.223.170]:59281 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761740AbbA2Jsf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 04:48:35 -0500
MIME-Version: 1.0
In-Reply-To: <1421822591-10536-1-git-send-email-cw00.choi@samsung.com>
References: <1421822591-10536-1-git-send-email-cw00.choi@samsung.com>
Date: Thu, 29 Jan 2015 10:48:34 +0100
Message-ID: <CACRpkdYq-1ztF5baHjB9aBUNspD5vRXrpnEd1zdWsADmwrhuWw@mail.gmail.com>
Subject: Re: [PATCH v3] pinctrl: exynos: Add support for Exynos5433
From: Linus Walleij <linus.walleij@linaro.org>
To: Chanwoo Choi <cw00.choi@samsung.com>, Tomasz Figa <tomasz.figa@gmail.com>
Cc: Thomas Abraham <thomas.abraham@linaro.org>, Kukjin Kim <kgene@kernel.org>,
        Inki Dae <inki.dae@samsung.com>,
        Chanho Park <chanho61.park@samsung.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 21, 2015 at 7:43 AM, Chanwoo Choi <cw00.choi@samsung.com> wrote:

> This patch adds driver data for Exynos5433 SoC. Exynos5433 includes 228 multi-
> functional input/output port pins and 135 memory port pins. There are 41 general
> port groups and 2 memory port groups.
>
> Cc: Tomasz Figa <tomasz.figa@gmail.com>
> Cc: Thomas Abraham <thomas.abraham@linaro.org>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> Acked-by: Inki Dae <inki.dae@samsung.com>
> ---
> Changes from v2:
> - Rebase it on v3.19-rc5

Waiting for Tomasz to review this.

Yours,
Linus Walleij

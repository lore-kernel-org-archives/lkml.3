Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756789AbaDWHBN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 03:01:13 -0400
Received: from mail-oa0-f43.google.com ([209.85.219.43]:41881 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756643AbaDWHBL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 03:01:11 -0400
MIME-Version: 1.0
In-Reply-To: <1397439947-31592-1-git-send-email-cw00.choi@samsung.com>
References: <1397439947-31592-1-git-send-email-cw00.choi@samsung.com>
Date: Wed, 23 Apr 2014 09:01:09 +0200
Message-ID: <CACRpkdaycY=Mba1pYQMv-Yq87JGfyJEnwmrT+qwDhrZ_4Rqs+g@mail.gmail.com>
Subject: Re: [PATCHv2] pinctrl: exynos: Add driver data for Exynos3250
From: Linus Walleij <linus.walleij@linaro.org>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 14, 2014 at 3:45 AM, Chanwoo Choi <cw00.choi@samsung.com> wrote:

> From: Tomasz Figa <t.figa@samsung.com>
>
> This patch adds driver data (bank list and EINT layout) for Exynos3250
> to pinctrl-exynos driver. Exynos3250 includes 158 multi-functional input/output
> ports. There are 23 general port groups.
>
> Changes from v1:
> - Add signed-off of sender
> - Post only separated patch for pinctrl from following patchset(v1)
>   : https://lkml.org/lkml/2014/4/10/286
>
> Cc: Thomas Abraham <thomas.abraham@linaro.org>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Cc: Kukjin Kim <kgene.kim@samsung.com>
> Signed-off-by: Tomasz Figa <t.figa@samsung.com>
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>

This v2 patch applied.

Yours,
Linus Walleij

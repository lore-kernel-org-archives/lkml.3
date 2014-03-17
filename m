Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756191AbaCQEPz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 00:15:55 -0400
Received: from mail-ob0-f181.google.com ([209.85.214.181]:50482 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751234AbaCQEPw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 00:15:52 -0400
MIME-Version: 1.0
In-Reply-To: <1395026919-14467-1-git-send-email-djkurtz@chromium.org>
References: <1395026919-14467-1-git-send-email-djkurtz@chromium.org>
Date: Mon, 17 Mar 2014 09:45:51 +0530
Message-ID: <CAK9yfHx5XFA1GyoHsRMgh2FpQ-4+pe=5302ZBJYUK6hLwdVLSQ@mail.gmail.com>
Subject: Re: [PATCH] drm/exynos: Fix (more) freeing issues in exynos_drm_drv.c
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Daniel Kurtz <djkurtz@chromium.org>
Cc: Inki Dae <inki.dae@samsung.com>, Joonyoung Shim <jy0922.shim@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        David Airlie <airlied@linux.ie>, Kukjin Kim <kgene.kim@samsung.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel,

Thanks for the patch.

On 17 March 2014 08:58, Daniel Kurtz <djkurtz@chromium.org> wrote:
> The following commit [0] fixed a use-after-free, but left the subdrv open
> in the error path.
>
> [0] commit 6ca605f7c70895a35737435f17ae9cc5e36f1466
> drm/exynos: Fix freeing issues in exynos_drm_drv.c
>
> Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>

Acked-by: Sachin Kamat <sachin.kamat@linaro.org>

-- 
With warm regards,
Sachin

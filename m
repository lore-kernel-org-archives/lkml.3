Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756689Ab3FMM3r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 08:29:47 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:41686 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752864Ab3FMM3q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 08:29:46 -0400
MIME-Version: 1.0
In-Reply-To: <1371058399-31933-1-git-send-email-dianders@chromium.org>
References: <1371058399-31933-1-git-send-email-dianders@chromium.org>
Date: Thu, 13 Jun 2013 14:29:45 +0200
Message-ID: <CACRpkdbLH2nFBgBDu0NkzbJmr8mFSsR_WuvRvO6G1YfZ=DqPEA@mail.gmail.com>
Subject: Re: [PATCH 1/3] pinctrl: exynos: Add spinlocks to irq_mask and irq_unmask
From: Linus Walleij <linus.walleij@linaro.org>
To: Doug Anderson <dianders@chromium.org>
Cc: Kukjin Kim <kgene.kim@samsung.com>, Tomasz Figa <tomasz.figa@gmail.com>,
        Olof Johansson <olof@lixom.net>, Simon Glass <sjg@chromium.org>,
        Luigi Semenzato <semenzato@chromium.org>, ilho215.lee@samsung.com,
        Eunki Kim <eunki_kim@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 12, 2013 at 7:33 PM, Doug Anderson <dianders@chromium.org> wrote:

> The patch:
>   1984695 pinctrl: samsung: Protect bank registers with a spinlock
>
> ...added spinlocks to protect many accesses.  However, the irq_mask
> and irq_unmask functions still do an unprotected read/modify/write.
> Add the spinlock there.
>
> Signed-off-by: Doug Anderson <dianders@chromium.org>

Patch applied with Tomasz and Kukjin's ACKs.

Thanks!
Linus Walleij

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756644Ab3FMMcn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 08:32:43 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:36590 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754209Ab3FMMcl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 08:32:41 -0400
MIME-Version: 1.0
In-Reply-To: <1371058399-31933-2-git-send-email-dianders@chromium.org>
References: <1371058399-31933-1-git-send-email-dianders@chromium.org>
	<1371058399-31933-2-git-send-email-dianders@chromium.org>
Date: Thu, 13 Jun 2013 14:32:41 +0200
Message-ID: <CACRpkdbGEA-GY8aU6Wh9stE00s7_+pzf2rnz3053hZEd8xm9Vg@mail.gmail.com>
Subject: Re: [PATCH 2/3] pinctrl: exynos: reorder xyz_irq_unmask() so future
 patch can ack
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

> This patch does nothing but reorder the functions to improve the
> readability of a future patch.
>
> Signed-off-by: Doug Anderson <dianders@chromium.org>

Patch applied with Tomasz and Kukjin's ACKs,
I had to rebase it though, so please check the result
on my "devel" branch when I push it out shortly
(will be sent to linux-next as well).

Yours,
Linus Walleij

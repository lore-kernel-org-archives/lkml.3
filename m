Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756557Ab3FMMer (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 08:34:47 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:60415 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754183Ab3FMMeq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 08:34:46 -0400
MIME-Version: 1.0
In-Reply-To: <1371058399-31933-3-git-send-email-dianders@chromium.org>
References: <1371058399-31933-1-git-send-email-dianders@chromium.org>
	<1371058399-31933-3-git-send-email-dianders@chromium.org>
Date: Thu, 13 Jun 2013 14:34:45 +0200
Message-ID: <CACRpkdYyReM7fLjYM4wnuCN5xZt_2hPDXaM9A0yuRhOoEBZm5g@mail.gmail.com>
Subject: Re: [PATCH 3/3] pinctrl: exynos: ack level-triggered interrupts
 before unmasking
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

> A level-triggered interrupt should be acked after the interrupt line
> becomes inactive and before it is unmasked, or else another interrupt
> will be immediately triggered.  Acking before or after calling the
> handler is not enough.
>
> Signed-off-by: Luigi Semenzato <semenzato@chromium.org>
> Signed-off-by: Doug Anderson <dianders@chromium.org>

I'm holding this off until Tomasz' comments are addressed.

Yours,
Linus Walleij

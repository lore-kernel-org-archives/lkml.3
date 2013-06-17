Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753293Ab3FQQ6t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 12:58:49 -0400
Received: from mail-ob0-f171.google.com ([209.85.214.171]:62941 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751220Ab3FQQ6s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 12:58:48 -0400
MIME-Version: 1.0
In-Reply-To: <1371487843-2066-1-git-send-email-dianders@chromium.org>
References: <1371487843-2066-1-git-send-email-dianders@chromium.org>
Date: Mon, 17 Jun 2013 18:58:47 +0200
Message-ID: <CACRpkdaO=nJGhrWxc6Kyub=XsgZhEQB+Apqzy=hHv4G+y9bS8Q@mail.gmail.com>
Subject: Re: [PATCH v3] pinctrl: exynos: ack level-triggered interrupts before unmasking
From: Linus Walleij <linus.walleij@linaro.org>
To: Doug Anderson <dianders@chromium.org>
Cc: Kukjin Kim <kgene.kim@samsung.com>, Tomasz Figa <tomasz.figa@gmail.com>,
        Olof Johansson <olof@lixom.net>, Simon Glass <sjg@chromium.org>,
        Luigi Semenzato <semenzato@chromium.org>,
        Ilho Lee <ilho215.lee@samsung.com>, Eunki Kim <eunki_kim@samsung.com>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 17, 2013 at 6:50 PM, Doug Anderson <dianders@chromium.org> wrote:

> A level-triggered interrupt should be acked after the interrupt line
> becomes inactive and before it is unmasked, or else another interrupt
> will be immediately triggered.  Acking before or after calling the
> handler is not enough.
>
> Signed-off-by: Luigi Semenzato <semenzato@chromium.org>
> Signed-off-by: Doug Anderson <dianders@chromium.org>
> Acked-by: Tomasz Figa <t.figa@samsung.com>
> ---
> Changes in v3:
> - Rebased atop (44b6d93 pinctrl: rockchip: correctly handle arguments
>   of pinconf options)

OK patch applied (cleanly this time).

Yours,
Linus Walleij

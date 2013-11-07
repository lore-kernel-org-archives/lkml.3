Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754593Ab3KGQkU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 11:40:20 -0500
Received: from mail-vb0-f41.google.com ([209.85.212.41]:59212 "EHLO
	mail-vb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754404Ab3KGQkS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 11:40:18 -0500
MIME-Version: 1.0
In-Reply-To: <1773667.KXPxL5WsyI@amdc1227>
References: <1381869563-16083-1-git-send-email-grant.likely@linaro.org>
	<2177804.l4VGDTRFDu@amdc1227>
	<2713030.RoDxNQo0oz@amdc1227>
	<1773667.KXPxL5WsyI@amdc1227>
Date: Thu, 7 Nov 2013 10:40:16 -0600
Message-ID: <CAL_JsqKUaioiz2dw3Sr8f7UfqzjagWH_je2-u_QGYXRK5g1=yg@mail.gmail.com>
Subject: Re: [PATCH 1/2] of: irq: Fix interrupt-map entry matching
From: Rob Herring <robherring2@gmail.com>
To: Tomasz Figa <t.figa@samsung.com>
Cc: Grant Likely <grant.likely@linaro.org>, Olof Johansson <olof@lixom.net>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kevin Hilman <khilman@linaro.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 7, 2013 at 5:32 AM, Tomasz Figa <t.figa@samsung.com> wrote:
> Hi Grant,
>
> Could you pick this patch up? It fixes boot-up at least on several Exynos
> based platforms, which use interrupt-map nodes with #interrupt-cells
> higher than 1.
>
> Also please disregard patch 2/2, as your fix that has been merged seems
> to be fine.

I've applied the 1st patch.

Rob

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755079Ab3DPOzw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 10:55:52 -0400
Received: from mail-la0-f50.google.com ([209.85.215.50]:50358 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754056Ab3DPOzu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 10:55:50 -0400
MIME-Version: 1.0
In-Reply-To: <001601ce3a85$16087f00$42197d00$%jun@samsung.com>
References: <1365698338-27503-1-git-send-email-dianders@chromium.org>
	<001701ce39d2$c0dbf8c0$4293ea40$%jun@samsung.com>
	<CAD=FV=XqmLRjQPwWCZfw0Nfu_uK16SOP=OgJcrbziWs4e__h7A@mail.gmail.com>
	<001601ce3a85$16087f00$42197d00$%jun@samsung.com>
Date: Tue, 16 Apr 2013 07:55:48 -0700
X-Google-Sender-Auth: yhZ3ZibLwxnDJIsbVL77Sas4Xco
Message-ID: <CAD=FV=U_n7sma6NMbQ=FySEV7nocubCmBSYEJ_R-q=dtuFLaFA@mail.gmail.com>
Subject: Re: [PATCH] mmc: dw_mmc: exynos: Turn SDIO interrupts on
From: Doug Anderson <dianders@chromium.org>
To: Seungwon Jeon <tgih.jun@samsung.com>
Cc: Chris Ball <cjb@laptop.org>, Thomas Abraham <thomas.abraham@linaro.org>,
        Bing Zhao <bzhao@marvell.com>, Jaehoon Chung <jh80.chung@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Olof Johansson <olof@lixom.net>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Seungwon,

On Tue, Apr 16, 2013 at 2:30 AM, Seungwon Jeon <tgih.jun@samsung.com> wrote:
> If needed for specific channel, it can be got from dts as property.
> if (of_find_property(np, "cap-sdio-irq", NULL))
>         pdata->caps |= MMC_CAP_SDIO_IRQ;

Oh!  I missed that these new properties had gone in.  That is a much
better way to do it.  Let's abandon this patch and I'll post up a
device tree change that turns interrupts for the right ports on the
exynos5250-snow and we can call it done.

Thanks for the review and for pointing me to the new properties!

-Doug

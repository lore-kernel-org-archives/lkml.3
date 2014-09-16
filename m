Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754056AbaIPPQH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 11:16:07 -0400
Received: from mail-ig0-f175.google.com ([209.85.213.175]:40725 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751540AbaIPPQF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 11:16:05 -0400
MIME-Version: 1.0
In-Reply-To: <1410808436-21460-2-git-send-email-alexandre.belloni@free-electrons.com>
References: <1410808436-21460-1-git-send-email-alexandre.belloni@free-electrons.com>
 <1410808436-21460-2-git-send-email-alexandre.belloni@free-electrons.com>
From: Chen-Yu Tsai <wens@csie.org>
Date: Tue, 16 Sep 2014 23:15:43 +0800
X-Google-Sender-Auth: 76nhwz9isVd37pLao0znHJYqGx0
Message-ID: <CAGb2v65QpcukxAyQuxbhgqCk4RNj8PgMF1dic1=9FexTa2zcvw@mail.gmail.com>
Subject: Re: [PATCHv6 1/2] pwm: Add Allwinner SoC support
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Thierry Reding <thierry.reding@gmail.com>, linux-pwm@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Jon Smirl <jonsmirl@gmail.com>, Simon <longsleep@gmail.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Sep 16, 2014 at 3:13 AM, Alexandre Belloni
<alexandre.belloni@free-electrons.com> wrote:
> This adds a generic PWM framework driver for the PWM controller
> found on Allwinner SoCs.
>
> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
> Acked-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> ---
>  drivers/pwm/Kconfig     |   9 ++
>  drivers/pwm/Makefile    |   1 +

This patch doesn't apply on either linux-pwm/for-next or sunxi-next.
The above files conflict with "pwm: sti: Add new driver for ST's PWM IP".
Respinning on either tree should work, as both trees have that commit.

>  drivers/pwm/pwm-sunxi.c | 371 ++++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 381 insertions(+)
>  create mode 100644 drivers/pwm/pwm-sunxi.c

[...]

Thanks

ChenYu

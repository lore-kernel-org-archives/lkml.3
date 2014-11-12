Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753383AbaKLTXB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 14:23:01 -0500
Received: from mail-vc0-f175.google.com ([209.85.220.175]:35949 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753295AbaKLTW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 14:22:58 -0500
MIME-Version: 1.0
In-Reply-To: <1415690392-9278-3-git-send-email-caesar.wang@rock-chips.com>
References: <1415690392-9278-1-git-send-email-caesar.wang@rock-chips.com>
	<1415690392-9278-3-git-send-email-caesar.wang@rock-chips.com>
Date: Wed, 12 Nov 2014 11:22:57 -0800
X-Google-Sender-Auth: mkU2WtUE32aQul1n39bmgKx53EA
Message-ID: <CAD=FV=V-qhi5rPxe_WGcS1JAZba_euFY3YuUyO_4mbqvJPUtzQ@mail.gmail.com>
Subject: Re: [PATCH v10 2/3] power-domain: rockchip: add power doamin driver
From: Doug Anderson <dianders@chromium.org>
To: Caesar Wang <caesar.wang@rock-chips.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Russell King <linux@arm.linux.org.uk>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        ZhenFu Fang <fzf@rock-chips.com>, Eddie Cai <cf@rock-chips.com>,
        Jack Dai <jack.dai@rock-chips.com>,
        "jinkun.hong" <jinkun.hong@rock-chips.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Caesar,

On Mon, Nov 10, 2014 at 11:19 PM, Caesar Wang
<caesar.wang@rock-chips.com> wrote:
> +       pm_genpd_init(&pd->genpd, NULL, false);

As Dmitry pointed out in another context, maybe this should be
"pm_genpd_init(&pd->genpd, NULL, !is_on);"

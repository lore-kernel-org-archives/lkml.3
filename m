Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935005AbaKNC5Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 21:57:24 -0500
Received: from mail-yh0-f53.google.com ([209.85.213.53]:39562 "EHLO
	mail-yh0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933665AbaKNC5W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 21:57:22 -0500
MIME-Version: 1.0
In-Reply-To: <1415829690-20236-3-git-send-email-caesar.wang@rock-chips.com>
References: <1415829690-20236-1-git-send-email-caesar.wang@rock-chips.com> <1415829690-20236-3-git-send-email-caesar.wang@rock-chips.com>
From: Daniel Kurtz <djkurtz@chromium.org>
Date: Fri, 14 Nov 2014 10:57:00 +0800
X-Google-Sender-Auth: uR_Pa0rdojt-URN6vCJK38elWFY
Message-ID: <CAGS+omBYBJwNu-dbkzEbPZvF3qmf52bLETNm4fTnR02H=k31Mg@mail.gmail.com>
Subject: Re: [PATCH v11 2/3] power-domain: rockchip: add power doamin driver
To: Caesar Wang <caesar.wang@rock-chips.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Russell King <linux@arm.linux.org.uk>,
        Mark Rutland <mark.rutland@arm.com>,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        "jinkun.hong" <jinkun.hong@rock-chips.com>,
        Randy Dunlap <rdunlap@infradead.org>, linux-doc@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Douglas Anderson <dianders@chromium.org>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        Rob Herring <robh+dt@kernel.org>, ZhenFu Fang <fzf@rock-chips.com>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>, Eddie Cai <cf@rock-chips.com>,
        Jack Dai <jack.dai@rock-chips.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Caesar,

One more little nit:

The title of this patch has a typo:
  doamin -> domain

Thanks,
-Dan

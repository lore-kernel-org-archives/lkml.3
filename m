Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759832AbaJaUy5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 16:54:57 -0400
Received: from mail-ig0-f173.google.com ([209.85.213.173]:40105 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756548AbaJaUyz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 16:54:55 -0400
MIME-Version: 1.0
In-Reply-To: <1414583525-17395-2-git-send-email-zyw@rock-chips.com>
References: <1414583525-17395-1-git-send-email-zyw@rock-chips.com>
	<1414583525-17395-2-git-send-email-zyw@rock-chips.com>
Date: Fri, 31 Oct 2014 21:54:54 +0100
Message-ID: <CACRpkdbm6q9Y0zqyQpCbVZzprEHcca75r1aC1OEq1HBmEXBj=g@mail.gmail.com>
Subject: Re: [PATCH v6 1/7] pinctrl: rockchip: add suspend/resume functions
From: Linus Walleij <linus.walleij@linaro.org>
To: Chris Zhong <zyw@rock-chips.com>
Cc: =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        Doug Anderson <dianders@chromium.org>,
        Mike Turquette <mturquette@linaro.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Russell King <linux@arm.linux.org.uk>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>, khilman@kernel.org,
        linux-rockchip@lists.infradead.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 29, 2014 at 12:51 PM, Chris Zhong <zyw@rock-chips.com> wrote:

> support suspend/resume of pinctrl, it allows handling sleep mode
> for hogged pins in pinctrl
>
> Signed-off-by: Chris Zhong <zyw@rock-chips.com>
> Tested-by: Doug Anderson <dianders@chromium.org>
> Reviewed-by: Doug Anderson <dianders@chromium.org>
> Tested-by: Heiko Stuebner <heiko@sntech.de>
> Reviewed-by: Heiko Stuebner <heiko@sntech.de>

As mentioned I expect Heiko to queue this patch with the
other stuff and send the result to me.

Yours,
Linus Walleij

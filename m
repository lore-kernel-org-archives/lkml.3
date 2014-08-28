Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751585AbaH1NTF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 09:19:05 -0400
Received: from mail-ob0-f171.google.com ([209.85.214.171]:44134 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750886AbaH1NTD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 09:19:03 -0400
MIME-Version: 1.0
In-Reply-To: <1407536949-31323-1-git-send-email-dianders@chromium.org>
References: <1407536949-31323-1-git-send-email-dianders@chromium.org>
Date: Thu, 28 Aug 2014 15:19:01 +0200
Message-ID: <CACRpkdbzNYEqYWrF+k0ueOhyhGcJ-nEEqGYOeuQ-ubvi2-SaNg@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: Add mux options 3 and 4 for rockchip pinctrl
From: Linus Walleij <linus.walleij@linaro.org>
To: Doug Anderson <dianders@chromium.org>
Cc: Heiko Stuebner <heiko@sntech.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Sonny Rao <sonnyrao@chromium.org>, eddie.cai@rock-chips.com,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 9, 2014 at 12:29 AM, Doug Anderson <dianders@chromium.org> wrote:

> Newer Rockchip SoCs have more muxing slots.  Add slots 3 and 4 since
> the rk3288 table goes all the way up to 4.
>
> Signed-off-by: Doug Anderson <dianders@chromium.org>

Patch applied with Heiko's review tag.

Yours,
Linus Walleij

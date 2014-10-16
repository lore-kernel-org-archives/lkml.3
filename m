Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751358AbaJPDna (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 23:43:30 -0400
Received: from mail-vc0-f172.google.com ([209.85.220.172]:58265 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751116AbaJPDn2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 23:43:28 -0400
MIME-Version: 1.0
In-Reply-To: <1413406144-16329-1-git-send-email-zyw@rock-chips.com>
References: <1413405987-16196-1-git-send-email-zyw@rock-chips.com>
	<1413406144-16329-1-git-send-email-zyw@rock-chips.com>
Date: Wed, 15 Oct 2014 20:43:27 -0700
X-Google-Sender-Auth: 5wlNG1M_cUaQRiIJHLjuxoXp5lg
Message-ID: <CAD=FV=W-A6Kb77et+eGrkHGizW2_2VcaGH8qQRG-7YOEKcZQ1g@mail.gmail.com>
Subject: Re: [PATCH 3/4] ARM: dts: add RK3288 suspend support
From: Doug Anderson <dianders@chromium.org>
To: Chris <zyw@rock-chips.com>
Cc: Heiko Stuebner <heiko@sntech.de>, Mike Turquette <mturquette@linaro.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        linux-rockchip@lists.infradead.org, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Tony Xie <xxx@rock-chips.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris,

On Wed, Oct 15, 2014 at 1:49 PM,  <zyw@rock-chips.com> wrote:
> From: Chris Zhong <zyw@rock-chips.com>
>
> add pmu_intmem subnode for suspend, add suspend pinctrl

Maybe mention that it's expected that board files will reference the
suspend pinctrl as part of the PMIC config?

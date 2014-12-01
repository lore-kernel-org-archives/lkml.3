Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932229AbaLATvJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 14:51:09 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:42340 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932156AbaLATvH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 14:51:07 -0500
From: Kevin Hilman <khilman@kernel.org>
To: Chris Zhong <zyw@rock-chips.com>
Cc: heiko@sntech.de, dianders@chromium.org, mturquette@linaro.org,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Russell King <linux@arm.linux.org.uk>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-rockchip@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kumar Gala <galak@codeaurora.org>,
        Tony Xie <xxx@rock-chips.com>, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v10 0/4] This suspend patch is only support cut off the power of cpu and some external
References: <1417423940-1669-1-git-send-email-zyw@rock-chips.com>
Date: Mon, 01 Dec 2014 11:51:03 -0800
In-Reply-To: <1417423940-1669-1-git-send-email-zyw@rock-chips.com> (Chris
	Zhong's message of "Mon, 1 Dec 2014 16:52:16 +0800")
Message-ID: <7htx1f409k.fsf@deeprootsystems.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Zhong <zyw@rock-chips.com> writes:

> devices, since we still lack power_domain driver, so the other power rail
> of rk3288 need keep power on.
> I have tested it on rk3288-evb board, atop next-20141112. goto suspend by type
> "echo mem > /sys/power/state", vdd_cpu is about 0mv by measuring, so it can be
> determined in sleep mode, then press power button to wakeup it.

I tested this on top of today's linux-next (next-20141201) and it
suspends, but doesn't wake up from any of the button presses.  What
wakeup sources are configured for the rk3288-evb-rk808?

Kevin

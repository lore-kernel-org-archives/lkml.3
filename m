Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753424AbaJTVcb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 17:32:31 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:64698 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752801AbaJTVc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 17:32:28 -0400
From: Kevin Hilman <khilman@kernel.org>
To: "jinkun.hong" <jinkun.hong@rock-chips.com>
Cc: linus.walleij@linaro.org, linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        linux-doc@vger.kernel.org, dianders@chromium.org,
        Heiko Stuebner <heiko@sntech.de>, linux-rockchip@lists.infradead.org,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: [PATCH v4 0/3] ARM: rk3288 : Add PM Domain support
References: <1413795824-3453-1-git-send-email-jinkun.hong@rock-chips.com>
Date: Mon, 20 Oct 2014 14:32:25 -0700
In-Reply-To: <1413795824-3453-1-git-send-email-jinkun.hong@rock-chips.com>
	(jinkun hong's message of "Mon, 20 Oct 2014 02:03:40 -0700")
Message-ID: <7hlhoae8ba.fsf@deeprootsystems.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"jinkun.hong" <jinkun.hong@rock-chips.com> writes:

> From: "jinkun.hong" <jinkun.hong@rock-chips.com>
>
> Add power domain drivers based on generic power domain for Rockchip platform,
> and support RK3288.
>
> Based on:
> - [PATCH v1 1/4] PM / clock_ops: Add pm_clk_add_clk()
>   http://www.mail-archive.com/linux-kernel@vger.kernel.org/msg735599.html

This series doesn't include any devices (or their clocks) being hooked
up to the power domains.  Is there another patch someplace that shows
how you add devices to the power domains (probably using DT?)

Kevin

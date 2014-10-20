Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753513AbaJTVgQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 17:36:16 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:54805 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752836AbaJTVgO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 17:36:14 -0400
From: Kevin Hilman <khilman@kernel.org>
To: Kever Yang <kever.yang@rock-chips.com>
Cc: heiko@sntech.de, dianders@chromium.org, sonnyrao@chromium.org,
        addy.ke@rock-chips.com, cf@rock-chips.com, xjq@rock-chips.com,
        hj@rock-chips.com, huangtao@rock-chips.com,
        linux-rockchip@lists.infradead.org,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Arnd Bergmann <arnd@arndb.de>, Rohit Vaswani <rvaswani@codeaurora.org>,
        devicetree@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
        linux-kernel@vger.kernel.org, Marc Carino <marc.ceeeee@gmail.com>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>, Olof Johansson <olof@lixom.net>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v5 0/6] add basic rk3288 smp support
References: <1413393785-26783-1-git-send-email-kever.yang@rock-chips.com>
Date: Mon, 20 Oct 2014 14:36:09 -0700
In-Reply-To: <1413393785-26783-1-git-send-email-kever.yang@rock-chips.com>
	(Kever Yang's message of "Wed, 15 Oct 2014 10:22:59 -0700")
Message-ID: <7hh9yye852.fsf@deeprootsystems.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kever Yang <kever.yang@rock-chips.com> writes:

> rk3288 is qual-core CPU Soc, we enable the smp in this patch.
>
> In version 3 we use regmap and pmu syscon for cpu power on/off.
> This should be work after Pankaj Dubey's patch applied:
> "syscon: Decouple syscon interface from platform devices"
> (https://lkml.org/lkml/2014/9/30/156)

Tested on top of linux-next (next-20141020) along with above syscon
dependency, and verifed that 4 CPUs boot up on my rk3288-evb-rk808.

Tested-by: Kevin Hilman <khilman@linaro.org>

Kevin

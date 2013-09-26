Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752393Ab3IZOj4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 10:39:56 -0400
Received: from top.free-electrons.com ([176.31.233.9]:44260 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750803Ab3IZOjz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 10:39:55 -0400
Date: Thu, 26 Sep 2013 16:39:42 +0200
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Olof Johansson <olof@lixom.net>, Kevin Hilman <khilman@linaro.org>,
        Emilio Lopez <emilio@elopez.com.ar>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kevin.z.m.zh@gmail.com, sunny@allwinnertech.com,
        shuge@allwinnertech.com, Thomas Gleixner <tglx@linutronix.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 0/5] Allwinner SoCs High Speed Timer support
Message-ID: <20130926163942.675266e5@skate>
In-Reply-To: <20130925195012.GI2954@lukather>
References: <1380117790-19390-1-git-send-email-maxime.ripard@free-electrons.com>
	<87zjr04vnh.fsf@linaro.org>
	<CAOesGMhTZS1MdHW9cL4s_X8jUXHS3VkNZupCfX4ZGroL6k4gEw@mail.gmail.com>
	<20130925195012.GI2954@lukather>
Organization: Free Electrons
X-Mailer: Claws Mail 3.9.1 (GTK+ 2.24.17; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Maxime Ripard,

On Wed, 25 Sep 2013 22:50:12 +0300, Maxime Ripard wrote:

> For all we know, so far, allwinner has released, by family:
>   - sun3i (ARM926)
>     * F20 (not supported)
>   - sun4i (Cortex A8)
>     * A10
>   - sun5i (Cortex A8)
>     * A10s
>     * A13
>   - sun6i (4 * Cortex A7)
>     * A31
>     * A31s (not supported)
>   - sun7i (2 * Cortex A7)
>     * A20
>     * A23? (that was just announced)

A small update to Documentation/arm/sunxi/README would be nice :)

Thomas
-- 
Thomas Petazzoni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

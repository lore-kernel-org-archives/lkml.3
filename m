Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754346Ab3I0RzX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 13:55:23 -0400
Received: from top.free-electrons.com ([176.31.233.9]:51313 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753558Ab3I0RzW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 13:55:22 -0400
Date: Fri, 27 Sep 2013 19:55:18 +0200
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
Message-ID: <20130927195518.4b0895b6@skate>
In-Reply-To: <20130927170505.GX2954@lukather>
References: <1380117790-19390-1-git-send-email-maxime.ripard@free-electrons.com>
	<87zjr04vnh.fsf@linaro.org>
	<CAOesGMhTZS1MdHW9cL4s_X8jUXHS3VkNZupCfX4ZGroL6k4gEw@mail.gmail.com>
	<20130925195012.GI2954@lukather>
	<20130926163942.675266e5@skate>
	<20130927170505.GX2954@lukather>
Organization: Free Electrons
X-Mailer: Claws Mail 3.9.1 (GTK+ 2.24.17; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Maxime Ripard,

On Fri, 27 Sep 2013 20:05:05 +0300, Maxime Ripard wrote:

> > A small update to Documentation/arm/sunxi/README would be nice :)
> 
> Yep, right. Even though, for most of these SoCs (F20, A10s, A31*,
> A2*), I don't think we have publicly available datasheet to point to
> there.

The Marvell file mentions Armada 370 and XP even though no public
datasheets are available. I think you should mention those SOCs, and
indicate that no datasheet is publicly available for the moment.

Best regards,

Thomas
-- 
Thomas Petazzoni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751969Ab3FDKwZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 06:52:25 -0400
Received: from gloria.sntech.de ([95.129.55.99]:58306 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751210Ab3FDKwY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 06:52:24 -0400
From: Heiko =?utf-8?q?St=C3=BCbner?= <heiko@sntech.de>
To: John Stultz <john.stultz@linaro.org>
Subject: Re: [PATCH v2 1/4] clocksource: dw_apb_timer_of: enable the use the clocksource as sched clock
Date: Tue, 4 Jun 2013 12:52:07 +0200
User-Agent: KMail/1.13.7 (Linux/3.2.0-3-686-pae; KDE/4.8.4; i686; ; )
Cc: Thomas Gleixner <tglx@linutronix.de>, Jamie Iles <jamie@jamieiles.com>,
        Dinh Nguyen <dinguyen@altera.com>,
        Grant Likely <grant.likely@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        Rob Herring <rob.herring@calxeda.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Baruch Siach <baruch@tkos.co.il>
References: <201306041136.09566.heiko@sntech.de> <201306041137.03319.heiko@sntech.de>
In-Reply-To: <201306041137.03319.heiko@sntech.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <201306041252.07877.heiko@sntech.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 4. Juni 2013, 11:37:02 schrieb Heiko Stübner:
> Currently the dw_apb_timer always expects a separate special timer to be
> availbable for the sched_clock. Some devices using dw_apb_timers do not
> have this sptimer but can use the clocksource as sched_clock instead.
> 
> Therefore enable the driver to distiguish between devices with and without
> sptimer based on the devicetree data and select the correct timer as
> sched_clock.
> 
> Signed-off-by: Heiko Stuebner <heiko@sntech.de>

in the original thread "arm: add basic support for Rockchip Cortex-A9 SoCs" 
this patch with the updated description now also got a


Acked-by: Linus Walleij <linus.walleij@linaro.org>

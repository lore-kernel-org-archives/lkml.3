Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751778AbaAMS1B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 13:27:01 -0500
Received: from ns1.pc-advies.be ([83.149.101.17]:52208 "EHLO
	spo001.leaseweb.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751316AbaAMS07 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 13:26:59 -0500
Date: Mon, 13 Jan 2014 19:26:45 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: Doug Anderson <dianders@chromium.org>
Cc: Guenter Roeck <linux@roeck-us.net>,
        Leela Krishna Amudala <l.krishna@samsung.com>,
        Olof Johansson <olof@lixom.net>, Tomasz Figa <tomasz.figa@gmail.com>,
        Kukjin Kim <kgene.kim@samsung.com>, Ben Dooks <ben-linux@fluff.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] watchdog: s3c2410_wdt: Report when the watchdog reset the system
Message-ID: <20140113182645.GA22249@spo001.leaseweb.com>
References: <1386267329-9941-2-git-send-email-dianders@chromium.org> <1386364088-6220-1-git-send-email-dianders@chromium.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386364088-6220-1-git-send-email-dianders@chromium.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Doug,

> A good watchdog driver is supposed to report when it was responsible
> for resetting the system.  Implement this for the s3c2410, at least on
> exynos5250 and exynos5420 where we already have a pointer to the PMU
> registers to read the information.
> 
> Note that exynos4 SoCs also provide the reset status, but providing
> that is left as an exercise for future changes and is not plumbed up
> in this patch series.  Also note the exynos4 SoCs don't appear to need
> any PMU config, which is why this patch separates the concepts of
> having PMU Registers vs. needing PMU Config.
> 
> Signed-off-by: Doug Anderson <dianders@chromium.org>

This patch has been added to linux-watchdog-next.

Kind regards,
Wim.


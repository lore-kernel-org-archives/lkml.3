Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758875Ab3LFV2z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 16:28:55 -0500
Received: from mail-pd0-f179.google.com ([209.85.192.179]:37098 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754075Ab3LFV2x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 16:28:53 -0500
Date: Fri, 6 Dec 2013 13:28:48 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Doug Anderson <dianders@chromium.org>
Cc: Wim Van Sebroeck <wim@iguana.be>,
        Leela Krishna Amudala <l.krishna@samsung.com>,
        Olof Johansson <olof@lixom.net>, Tomasz Figa <tomasz.figa@gmail.com>,
        Kukjin Kim <kgene.kim@samsung.com>, Ben Dooks <ben-linux@fluff.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] watchdog: s3c2410_wdt: Report when the watchdog reset
 the system
Message-ID: <20131206212848.GA12283@roeck-us.net>
References: <1386267329-9941-2-git-send-email-dianders@chromium.org>
 <1386364088-6220-1-git-send-email-dianders@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386364088-6220-1-git-send-email-dianders@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 06, 2013 at 01:08:07PM -0800, Doug Anderson wrote:
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

Reviewed-by: Guenter Roeck <linux@roeck-us.net>

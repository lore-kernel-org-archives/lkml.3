Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751192AbaKQGTM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 01:19:12 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:43728 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755AbaKQGTI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 01:19:08 -0500
X-AuditID: cbfee690-f79ab6d0000046f7-22-54699359f618
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: linux-pm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Cc: rjw@rjwysocki.net, pavel@ucw.cz, len.brown@intel.com,
        linux@arm.linux.org.uk, nico@linaro.org, ccross@android.com,
        Pankaj Dubey <pankaj.dubey@samsung.com>
Subject: [PATCH v2] cpu_pm: fix unmet dependency for CPU_PM
Date: Mon, 17 Nov 2014 11:42:44 +0530
Message-id: <1416204764-8912-1-git-send-email-pankaj.dubey@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCLMWRmVeSWpSXmKPExsWyRsSkVjdycmaIQcdubYvtG7+xWsyaspfJ
	YtPja6wWl3fNYbP43HuE0eL2ZV6L6cf+slks2vqF3eLuqaNsFmdOX2J14PLYtnsbq0dLcw+b
	x+I9L5k87lzbw+axeUm9x5ar7SwefVtWMXqsWP2d3ePzJrkAzigum5TUnMyy1CJ9uwSujGud
	t9gLmtgr7s6Ra2B8yNrFyMkhIWAicWflKihbTOLCvfVsXYxcHEICSxklVj/eywZTtHrnElaI
	xHRGidaZC5ghnAlMEt3/XzGBVLEJ6Eo8eT+XGcQWEUiSmLp6MlgHs8AiRolNi96DjRIWsJY4
	tvA4I4jNIqAq8XDGTBYQm1fAXeJe4xf2LkYOoHUKEnMm2YD0SghsYpfo7NjDAlEvIPFt8iEW
	iBpZiU0HmCGuk5Q4uOIGywRGwQWMDKsYRVMLkguKk9KLTPSKE3OLS/PS9ZLzczcxAgP/9L9n
	E3Yw3jtgfYhRgINRiYd3R3ZmiBBrYllxZe4hRlOgDROZpUST84HxlVcSb2hsZmRhamJqbGRu
	aaYkzvta6mewkEB6YklqdmpqQWpRfFFpTmrxIUYmDk6pBsbYt+eqgr/GFCryqjxYnlv1KP5F
	sJdMzJ4T5/dWyR2IbEu4tP/HoqvrpN5tCBXJmb+07Mbe4/9KY6+/Za3iZos/eX22o0F79LNl
	uWkVnv1ia8V/ask8VJ+zsDD0v6J3b5F0FNfG+UaHj0bO7OF1Y/A/uyhP+7WnU36Dc8xpT86m
	jRJdxo86NZVYijMSDbWYi4oTAZmz23R3AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHIsWRmVeSWpSXmKPExsVy+t9jQd3IyZkhBp++K1ls3/iN1WLWlL1M
	FpseX2O1uLxrDpvF594jjBa3L/NaTD/2l81i0dYv7BZ3Tx1lszhz+hKrA5fHtt3bWD1amnvY
	PBbvecnkcefaHjaPzUvqPbZcbWfx6NuyitFjxerv7B6fN8kFcEY1MNpkpCampBYppOYl56dk
	5qXbKnkHxzvHm5oZGOoaWlqYKynkJeam2iq5+AToumXmAB2qpFCWmFMKFApILC5W0rfDNCE0
	xE3XAqYxQtc3JAiux8gADSSsYcy41nmLvaCJveLuHLkGxoesXYycHBICJhKrdy6BssUkLtxb
	z9bFyMUhJDCdUaJ15gJmCGcCk0T3/1dMIFVsAroST97PZQaxRQSSJKaunswKUsQssIhRYtOi
	92wgCWEBa4ljC48zgtgsAqoSD2fMZAGxeQXcJe41fmHvYuQAWqcgMWeSzQRG7gWMDKsYRVML
	kguKk9JzDfWKE3OLS/PS9ZLzczcxguPqmdQOxpUNFocYBTgYlXh4d2RnhgixJpYVV+YeYpTg
	YFYS4V2iAxTiTUmsrEotyo8vKs1JLT7EaAq0fCKzlGhyPjDm80riDY1NzE2NTS1NLEzMLJXE
	eQ+0WgcKCaQnlqRmp6YWpBbB9DFxcEo1MJ5SV5j6KP9/UwXPUqPUZx61U4V73prdMat7si3+
	HMvckx1br+nKqObndtTNmt37atszfpfJdd9Pq3c8e5DI1sQZbqRw/8D9r94ZPgwmNun5BS+Y
	hJlKtqnV7vn4sDOo23XR/22xbRs3h33eKeBtfen6Svec/f6PDULP8jddVb4Wfv6vWt7XNCWW
	4oxEQy3mouJEAK4bU0DBAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If BL_SWITCHER is enabled but SUSPEND and CPU_IDLE is not enabled
we are getting following config warning.

warning: (BL_SWITCHER) selects CPU_PM which has unmet direct
dependencies (SUSPEND || CPU_IDLE)

It has been noticed that CPU_PM dependencies in this file are not really
required so let's remove these dependencies from CPU_PM.

Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
---
This patch is second attempt to fix this config issue. Patch v1 and related
discussion can be found here [1]
1: https://lkml.org/lkml/2014/11/14/673

 kernel/power/Kconfig |    1 -
 1 file changed, 1 deletion(-)

diff --git a/kernel/power/Kconfig b/kernel/power/Kconfig
index bbef57f..1eb7da7 100644
--- a/kernel/power/Kconfig
+++ b/kernel/power/Kconfig
@@ -308,4 +308,3 @@ config PM_GENERIC_DOMAINS_OF
 
 config CPU_PM
 	bool
-	depends on SUSPEND || CPU_IDLE
-- 
1.7.9.5


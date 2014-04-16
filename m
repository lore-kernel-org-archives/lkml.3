Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161301AbaDPVQK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 17:16:10 -0400
Received: from www.linutronix.de ([62.245.132.108]:43413 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756689AbaDPVQD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 17:16:03 -0400
Date: Wed, 16 Apr 2014 23:16:12 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
cc: LKML <linux-kernel@vger.kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org
Subject: Re: [patch 0/4] genirq/exynos timers: Fix the CPU hotplug wreckage
 sanely
In-Reply-To: <1397663995.19782.4.camel@AMDC1943>
Message-ID: <alpine.DEB.2.02.1404162315270.22697@ionos.tec.linutronix.de>
References: <20140416142106.537575971@linutronix.de> <1397663995.19782.4.camel@AMDC1943>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323329-224216975-1397682973=:22697"
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-224216975-1397682973=:22697
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Wed, 16 Apr 2014, Krzysztof Kozlowski wrote:
> On śro, 2014-04-16 at 14:36 +0000, Thomas Gleixner wrote:
> > @Krzysztof: Can you please retest the series? I've changed the core
> > implementation versus the first attempt to make it less intrusive.
> 
> Works fine. Tested whole patchset on board with Exynos 3250.

Great! Now I just need to sell it :)
--8323329-224216975-1397682973=:22697--

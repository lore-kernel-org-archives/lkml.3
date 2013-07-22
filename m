Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757465Ab3GVQzc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 12:55:32 -0400
Received: from utopia.booyaka.com ([74.50.51.50]:47266 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756056Ab3GVQzb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 12:55:31 -0400
Date: Mon, 22 Jul 2013 16:55:29 +0000 (UTC)
From: Paul Walmsley <paul@pwsan.com>
To: Roger Quadros <rogerq@ti.com>
cc: catalin.marinas@arm.com, Russell King <linux@arm.linux.org.uk>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        "tony@atomide.com" <tony@atomide.com>,
        "Mesfin, Yebio" <ymesfin@ti.com>
Subject: Re: linux-3.11-rc1: Internal error: Oops - undefined instruction:
 0 [#1] SMP ARM on OMAP3/AM335x
In-Reply-To: <51ECFBAC.7090900@ti.com>
Message-ID: <alpine.DEB.2.02.1307221652350.10891@utopia.booyaka.com>
References: <51ECFBAC.7090900@ti.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Jul 2013, Roger Quadros wrote:

> I observe the following problem on booting v3.11-rc1 on OMAP3 beagle board.
> 
> [    5.888946] Internal error: Oops - undefined instruction: 0 [#1] SMP ARM
> [    5.896057] Modules linked in:
> [    5.899322] CPU: 0 PID: 9 Comm: rcu_sched Not tainted 3.11.0-rc2-00001-g1ea701a #876
> [    5.907501] task: ce0720c0 ti: ce07a000 task.ti: ce07a000
> [    5.913208] PC is at check_and_switch_context+0x130/0x4dc
> [    5.918914] LR is at check_and_switch_context+0xd8/0x4dc

It affects 3730beaglexm and am335xbonelt here too.

http://www.pwsan.com/omap/testlogs/test_v3.11-rc2/20130721203314/boot/am335xbonelt/am335x-bone/am335xbonelt_log.txt
http://www.pwsan.com/omap/testlogs/test_v3.11-rc2/20130721203314/boot/3730beaglexm/3730beaglexm_log.txt


- Paul

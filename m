Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932606Ab3BMJpY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 04:45:24 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:53334 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757234Ab3BMJpV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 04:45:21 -0500
Date: Wed, 13 Feb 2013 10:45:13 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Magnus Damm <magnus.damm@gmail.com>
cc: linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org,
        johnstul@us.ibm.com, horms@verge.net.au,
        shinya.kuribayashi.px@renesas.com, tglx@linutronix.de
Subject: Re: [PATCH 00/08] clocksource: sh_cmt: CMT driver update
In-Reply-To: <20121214055323.10081.12056.sendpatchset@w520>
Message-ID: <Pine.LNX.4.64.1302130927280.18535@axis700.grange>
References: <20121214055323.10081.12056.sendpatchset@w520>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:CKxV3UEted1+wyByqZcqTX1THE3UkKvzc6rsNsRNu1b
 gPHtCFfAbh2Rlrur71bDYCalmgSfBWGkjIjuysvxcjda+/EWcs
 z6H/D1OEptXiHVL73/ShWjPDyeSkH8t4YHzIUtAdngbZ3uNPMy
 Xcddjg2WjuoqCZsE0Uk6y3XoCwJVj+nJ2mNAZC/m6I7upFMY7c
 N4tzdCJMKXxjxd7Si4TzbJfg4ChEGUXdm+r/0meiNFkicDe8Lx
 ol7LQjFpiY0df3CSFIcBqrxCKvhEAO/ZxyJhWJfwb0ofdubSZh
 028/AwrqWbFfzKHQd3/2AyrzGcEJRR3CNsSj7UreZTcDmXEDkP
 ff4qa/iw3wW0FFeGKoCDXthq/47LmvB58HHcBp1rysIcHWNnQv
 +dX8skiE+dE2g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Magnus

On Fri, 14 Dec 2012, Magnus Damm wrote:

> clocksource: sh_cmt: CMT driver update
> 
> [PATCH 01/08] clocksource: sh_cmt: Take care of clk_put() when setup_irq() fails
> [PATCH 02/08] clocksource: sh_cmt: Initialize 'max_match_value' and 'lock' in sh_cmt_setup()
> [PATCH 03/08] clocksource: sh_cmt: Consolidate platform_set_drvdata() call
> [PATCH 04/08] clocksource: sh_cmt: Introduce per-register functions
> [PATCH 05/08] clocksource: sh_cmt: CMSTR and CMCSR register access update
> [PATCH 06/08] clocksource: sh_cmt: CMCNT and CMCOR register access update
> [PATCH 07/08] clocksource: sh_cmt: Add control register callbacks
> [PATCH 08/08] clocksource: sh_cmt: Add CMT register layout comment

On a kzm9g board with -reference DT configuration and on armadillo800eva:

Tested-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

Thanks
Guennadi

> This patch series contains a couple of driver updates from Kuribayashi-san
> together with some register access changes from me. The register access
> changes work towards adding support for 32-bit only CMT hardware, but
> the final bits are not yet included in this series due to lack of hardware.
> 
> Patches 1-3:
> Signed-off-by: Shinya Kuribayashi <shinya.kuribayashi.px@renesas.com>
> Signed-off-by: Magnus Damm <damm@opensource.se>
> 
> Patches 4-8:
> Signed-off-by: Magnus Damm <damm@opensource.se>
> ---
> 
>  drivers/clocksource/sh_cmt.c |  257 ++++++++++++++++++++++++------------------
>  1 file changed, 152 insertions(+), 105 deletions(-)
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sh" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/

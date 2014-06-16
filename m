Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753811AbaFPOFr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 10:05:47 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:54167 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752054AbaFPOFq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 10:05:46 -0400
Message-ID: <539EF985.3080705@ti.com>
Date: Mon, 16 Jun 2014 10:04:53 -0400
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Sricharan R <r.sricharan@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC: <tony@atomide.com>, <nm@ti.com>, <rnayak@ti.com>, <linux@arm.linux.org.uk>,
        <tglx@linutronix.de>, <jason@lakedaemon.net>, <joe@perches.com>
Subject: Re: [PATCH V3 00/16] irqchip: crossbar: driver fixes
References: <1402917796-31574-1-git-send-email-r.sricharan@ti.com>
In-Reply-To: <1402917796-31574-1-git-send-email-r.sricharan@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sricharan,

On Monday 16 June 2014 07:23 AM, Sricharan R wrote:
> This series does some cleanups, fixes for handling two interrupts
> getting mapped twice to same crossbar and provides support for
> hardwired IRQ and crossbar definitions.
> 
> On certain platforms such as DRA7, SPIs 0, 1, 2, 3, 5, 6, 10,
> 131, 132, 133 are direct wired to hardware blocks bypassing
> crossbar. This quirky implementation is *NOT* supposed to be the
> expectation of crossbar hardware usage. This series adds support
> to represent such hard-wired irqs through DT and avoid generic
> allocation/programming of crossbar in the driver.
> 
> This way of supporting hard-wired irqs was a result of
> the below discussions.
> http://www.spinics.net/lists/arm-kernel/msg329946.html
> 
> Based on 3.15 mainline.
> 
> All the patches are available here
>  git@github.com:Sricharanti/sricharan.git crossbar_updates
> 
> The fixes series[1] earlier posted is merged in to this.
> [1] http://www.spinics.net/lists/arm-kernel/msg328273.html
> 
> [V2] Merged the above series and rebased on 3.15 mainline
> 
> [V3] Modified patch#3 to get irqs-skip properties from DT,
>      merged path#8 for checkpatch warning to other relevant
>      patches and fixed comments for other patches.
>
I scanned entire series again including your updates on Jason's
comments. All look good to my eyes.

Hopefully after this series now, we can actually enable the crossbar
support on those machines.

FWIW,
Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>

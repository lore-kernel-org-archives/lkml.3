Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756030AbaICJcE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 05:32:04 -0400
Received: from top.free-electrons.com ([176.31.233.9]:44365 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755882AbaICJcB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 05:32:01 -0400
Date: Wed, 3 Sep 2014 11:31:57 +0200
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
To: Boris BREZILLON <boris.brezillon@free-electrons.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Andrew Victor <linux@maxim.org.za>,
        Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Douglas Gilbert <dgilbert@interlog.com>,
        Johan Hovold <jhovold@gmail.com>
Subject: Re: [PATCH 0/5] rtc: at91sam9: add DT support
Message-ID: <20140903113157.45822fbb@bbrezillon>
In-Reply-To: <1409733934-14465-1-git-send-email-boris.brezillon@free-electrons.com>
References: <1409733934-14465-1-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  3 Sep 2014 10:45:29 +0200
Boris BREZILLON <boris.brezillon@free-electrons.com> wrote:

> Hello,
> 
> This patch series adds DT support to the atmel at91sam9 RTC driver.
> 
> It also removes any machine specific inclusions to prepare the migration
> to multi platform kernel support, and retain the slow clock to prevent
> the CCF from disabling it at the end of boot.

Oops, just noticed there already was a proposal adding DT support to
this driver [1].
Adding Johan and Douglas in Cc.

[1]http://lists.infradead.org/pipermail/linux-arm-kernel/2013-April/160453.html

> 
> Best Regards,
> 
> Boris
> 
> Boris BREZILLON (5):
>   rtc: at91sam9: remove references to mach specific headers
>   rtc: at91sam9: use standard readl/writel functions instead of raw
>     versions
>   rtc: at91sam9: add DT support
>   rtc: at91sam9: retain slow clock and check its rate
>   rtc: at91sam9: add DT bindings documentation
> 
>  .../devicetree/bindings/rtc/atmel,at91sam9-rtc.txt | 20 +++++++
>  drivers/rtc/rtc-at91sam9.c                         | 63 +++++++++++++++++++---
>  2 files changed, 75 insertions(+), 8 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/rtc/atmel,at91sam9-rtc.txt
> 



-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com

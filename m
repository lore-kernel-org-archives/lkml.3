Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757059Ab3K2QaQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 11:30:16 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:50301 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752749Ab3K2QaO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 11:30:14 -0500
Message-ID: <5298C0B0.4030404@ti.com>
Date: Fri, 29 Nov 2013 11:28:32 -0500
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
CC: Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>,
        <devicetree@vger.kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Kumar Gala <galak@kernel.crashing.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-mtd@lists.infradead.org>, <grygorii.strashko@ti.com>,
        <david.woodhouse@intel.com>
Subject: Re: [PATCH v2 00/10] Reuse davinci-nand driver for Keystone arch
References: <1385033305-13179-1-git-send-email-ivan.khoronzhuk@ti.com>
In-Reply-To: <1385033305-13179-1-git-send-email-ivan.khoronzhuk@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ivan,
On Thursday 21 November 2013 06:28 AM, Ivan Khoronzhuk wrote:
> This series contains fixes and updates of Davinci nand driver in
> order to reuse it for Keystone platform.
> 
> The series is combination of two following series:
> - Davinci nand driver fixes and updates:
>   https://lkml.org/lkml/2013/11/20/271
> - Reuse davinci-nand driver for Keystone arch
>   https://lkml.org/lkml/2013/11/20/315
> 
> Ivan Khoronzhuk (10):
>   mtd: nand: davinci: fix driver registration
>   mtd: nand: davinci: return ENOMEM if memory allocation is failed
>   mtd: nand: davinci: check required ti,davinci-chipselect property
>   mtd: nand: davinci: simplify error handling
>   mtd: nand: davinci: move bindings under mtd
>   mtd: nand: davinci: extend description of bindings
>   mtd: nand: davinci: adjust DT properties to MTD generic
>   mtd: nand: davinci: reuse driver for Keystone arch
>   mtd: nand: davinci: don't set timings if AEMIF is used
>   mtd: nand: davinci: don't request AEMIF address range
> 
>  .../devicetree/bindings/arm/davinci/nand.txt       |   46 --------
>  .../devicetree/bindings/mtd/davinci-nand.txt       |   94 ++++++++++++++++
>  drivers/mtd/nand/Kconfig                           |    6 +-
>  drivers/mtd/nand/davinci_nand.c                    |  117 +++++++++++---------
>  4 files changed, 164 insertions(+), 99 deletions(-)
>  delete mode 100644 Documentation/devicetree/bindings/arm/davinci/nand.txt
>  create mode 100644 Documentation/devicetree/bindings/mtd/davinci-nand.txt
> 
Please drop patch 9 from the series considering we are handling it
differently and repost the entire series with David in cc. David
has been lining up the patches.

Regards,
Santosh

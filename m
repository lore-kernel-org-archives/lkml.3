Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755133Ab3KTUTh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 15:19:37 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:58287 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754986Ab3KTUTe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 15:19:34 -0500
Message-ID: <528D17EE.50402@ti.com>
Date: Wed, 20 Nov 2013 22:13:34 +0200
From: Grygorii Strashko <grygorii.strashko@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>
CC: <devicetree@vger.kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Kumar Gala <galak@kernel.crashing.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-mtd@lists.infradead.org>
Subject: Re: [PATCH 0/7] Davinci nand driver fixes and updates
References: <1384960945-14528-1-git-send-email-ivan.khoronzhuk@ti.com>
In-Reply-To: <1384960945-14528-1-git-send-email-ivan.khoronzhuk@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.145.75]
X-EXCLAIMER-MD-CONFIG: f9c360f5-3d1e-4c3c-8703-f45bf52eff6b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/20/2013 05:22 PM, Ivan Khoronzhuk wrote:
> This series contains fixes and updates of Davinci nand driver, in
> order to prepare it to be reused for Keystone platform.
>
> V1:
> https://lkml.org/lkml/2013/11/11/352
>
> Ivan Khoronzhuk (7):
>    mtd: nand: davinci: fix driver registration
>    mtd: nand: davinci: return ENOMEM if memory allocation is failed
>    mtd: nand: davinci: check required ti,davinci-chipselect property
>    mtd: nand: davinci: simplify error handling
>    mtd: nand: davinci: move bindings under mtd
>    mtd: nand: davinci: extend description of bindings
>    mtd: nand: davinci: adjust DT properties to MTD generic

For overall series:
Reviewed-by: Grygorii Strashko <grygorii.strashko@ti.com>

>
>   .../devicetree/bindings/arm/davinci/nand.txt       |   46 ----------
>   .../devicetree/bindings/mtd/davinci-nand.txt       |   92 ++++++++++++++++++++
>   drivers/mtd/nand/davinci_nand.c                    |   68 +++++++--------
>   3 files changed, 126 insertions(+), 80 deletions(-)
>   delete mode 100644 Documentation/devicetree/bindings/arm/davinci/nand.txt
>   create mode 100644 Documentation/devicetree/bindings/mtd/davinci-nand.txt
>


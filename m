Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755186Ab3KTUWD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 15:22:03 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:46110 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754193Ab3KTUWA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 15:22:00 -0500
Message-ID: <528D18EC.6000501@ti.com>
Date: Wed, 20 Nov 2013 22:17:48 +0200
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
Subject: Re: [PATCH 0/3] Reuse davinci-nand driver for Keystone arch
References: <1384964699-15134-1-git-send-email-ivan.khoronzhuk@ti.com>
In-Reply-To: <1384964699-15134-1-git-send-email-ivan.khoronzhuk@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.145.75]
X-EXCLAIMER-MD-CONFIG: f9c360f5-3d1e-4c3c-8703-f45bf52eff6b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/20/2013 06:24 PM, Ivan Khoronzhuk wrote:
> This series contains updates of Davinci nand driver, in order to be
> reused for Keystone platform.
>
> Depends on:
> - Davinci nand driver fixes and updates:
>    https://lkml.org/lkml/2013/11/20/271

^^^^ I suggest to merge this series with above one as it
should not break anything.

>
> - Introduce AEMIF driver for Davinci/Keystone archs:
>    http://lkml.org/lkml/2013/11/11/352
>
> V1:
> https://lkml.org/lkml/2013/11/11/352
>
> Ivan Khoronzhuk (3):
>    mtd: nand: davinci: reuse driver for Keystone arch
>    mtd: nand: davinci: don't set timings if AEMIF is used
>    mtd: nand: davinci: don't request AEMIF address range

For patches:
Reviewed-by: Grygorii Strashko <grygorii.strashko@ti.com>

>
>   .../devicetree/bindings/mtd/davinci-nand.txt       |    8 +--
>   drivers/mtd/nand/Kconfig                           |    6 +--
>   drivers/mtd/nand/davinci_nand.c                    |   57 +++++++++++++-------
>   3 files changed, 45 insertions(+), 26 deletions(-)
>


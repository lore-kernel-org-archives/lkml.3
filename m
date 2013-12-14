Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753991Ab3LNTO5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 14:14:57 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:44169 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753751Ab3LNTOz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 14:14:55 -0500
Message-ID: <52ACADEB.30307@ti.com>
Date: Sat, 14 Dec 2013 14:13:47 -0500
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
        <gregkh@linuxfoundation.org>, <dwmw2@infradead.org>, <nsekhar@ti.com>,
        "[initial author] Murali Karicheri" <m-karicheri2@ti.com>
Subject: Re: [PATCH v3 1/2] memory: ti-aemif: introduce AEMIF driver
References: <1386759570-29671-1-git-send-email-ivan.khoronzhuk@ti.com> <1386759570-29671-2-git-send-email-ivan.khoronzhuk@ti.com>
In-Reply-To: <1386759570-29671-2-git-send-email-ivan.khoronzhuk@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 11 December 2013 05:59 AM, Ivan Khoronzhuk wrote:
> Add new AEMIF driver for EMIF16 Texas Instruments controller.
> The EMIF16 module is intended to provide a glue-less interface to
> a variety of asynchronous memory devices like ASRA M, NOR and NAND
> memory. A total of 256M bytes of any of these memories can be
> accessed at any given time via 4 chip selects with 64M byte access
> per chip select.
> 
> Synchronous memories such as DDR1 SD RAM, SDR SDRAM and Mobile SDR
> are not supported.
> 
> This controller is used on SoCs like Davinci, Keysone2
> 
> Signed-off-by: [initial author] Murali Karicheri <m-karicheri2@ti.com>
> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
> ---
Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>


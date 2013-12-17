Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753915Ab3LQUvU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 15:51:20 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:44851 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751706Ab3LQUvS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 15:51:18 -0500
Message-ID: <52B0B920.1000001@ti.com>
Date: Tue, 17 Dec 2013 15:50:40 -0500
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Grygorii Strashko <grygorii.strashko@ti.com>
CC: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Russell King <linux@arm.linux.org.uk>, Olof Johansson <olof@lixom.net>,
        <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/4] ARM: keystone: enable GPIO support
References: <1387211981-26045-1-git-send-email-grygorii.strashko@ti.com>
In-Reply-To: <1387211981-26045-1-git-send-email-grygorii.strashko@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 16 December 2013 11:39 AM, Grygorii Strashko wrote:
> This series adds Keystone GPIO IP definition in DT and enable GPIO support in
> Keystone configuration file.
> 
> Also, it enables LEDs support for Keystone 2 K2H EVM as specified in board 
> schematic. For more information see:
> - http://www.advantech.com/Support/TI-EVM/EVMK2HX.aspx 
> 
> Depends on:
> [PATCH 0/2] gpio: davinci: reuse for keystone arch
> - https://lkml.org/lkml/2013/12/12/366
> 
> Grygorii Strashko (4):
>   arm: dts: keystone: add GPIO device entry
>   ARM: keystone_defconfig: enable gpio support
>   arm: dts: keystone-evm: add LEDs supports
>   ARM: keystone_defconfig: enable LED support
> 
Patch subjects should be consistent. I will fix
them while applying it on my tree. Will wait
for the GPIO driver support patches state
before applying the subject series.

Thanks for the patches.

Regards,
Santosh


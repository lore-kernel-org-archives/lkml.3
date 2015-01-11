Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751925AbbAKM4V (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 07:56:21 -0500
Received: from down.free-electrons.com ([37.187.137.238]:48454 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751049AbbAKM4S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 07:56:18 -0500
Date: Sun, 11 Jan 2015 13:56:15 +0100
From: Boris Brezillon <boris.brezillon@free-electrons.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: Boris Brezillon <boris.brezillon@free-electrons.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Andrew Victor <linux@maxim.org.za>,
        Samuel Ortiz <sameo@linux.intel.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Jean-Jacques Hiblot <jjhiblot@traphandler.com>
Subject: Re: [PATCH v5 00/11] memory: add Atmel EBI (External Bus Interface)
 driver
Message-ID: <20150111135615.3326d803@bbrezillon>
In-Reply-To: <1417639455-17410-1-git-send-email-boris.brezillon@free-electrons.com>
References: <1417639455-17410-1-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lee,

On Wed,  3 Dec 2014 21:44:04 +0100
Boris Brezillon <boris.brezillon@free-electrons.com> wrote:

> The EBI (External Bus Interface) is used to access external peripherals
> (NOR, SRAM, NAND, and other specific devices like ethernet controllers).
> Each device is assigned a CS line and an address range and can have its
> own configuration (timings, access mode, bus width, ...).
> This driver provides a generic DT binding to configure a device according
> to its requirements.
> For specific device controllers (like the NAND one) the SMC timings
> should be configured by the controller driver through the matrix and
> smc syscon regmaps.
> 
> The first 4 patches introduce 2 syscon devices needed to configure the
> EBI bus, patch 5 and 6 adds support for the EBI bus, and the remaining
> patches declares the EBI related nodes in sama5d3 dts[i] files.

Can you take the first 4 patches of this series (adding 2 syscon
devices and their associated bindings doc) for 3.20 ?
Alexandre has worked on multi platform support for Atmel SoCs and his
work depends on these two syscon devices.

Let me know if you want me to send to send a new series containing only
those 4 commits.

Best Regards,

Boris

-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com

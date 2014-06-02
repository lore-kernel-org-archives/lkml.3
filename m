Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932124AbaFBPGl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 11:06:41 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:60774 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751848AbaFBPGk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 11:06:40 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Shawn Guo <shawn.guo@freescale.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "Strashko, Grygorii" <grygorii.strashko@ti.com>,
        Russell King <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Olof Johansson <olof@lixom.net>, Rob Herring <robh+dt@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH v3 0/7] of: setup dma parameters using dma-ranges and dma-coherent
Date: Mon, 02 Jun 2014 17:06:02 +0200
Message-ID: <4197388.OE67ahhtqp@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <538C7B22.2020107@ti.com>
References: <1398353407-2345-1-git-send-email-santosh.shilimkar@ti.com> <20140602063702.GB7834@dragon> <538C7B22.2020107@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:ZKzed6NM+wMXXyTf8LpkTgWyK11X/hi2qiEVtTxdebF
 rUyKi+qx0cclaQSRGZZoTXv3ufl7ZIZIQWV0LrSGUJsF+CKy5M
 w+qFzbT6SXYjMzZtkgIMEIB9Sm4rnBMcZMLGaO8xEmM0NLI3dK
 klQ8oFJ24cjq93G4mg4nqEIf/KROH20NL1Ii2pDifoRBlwCN+V
 GbkNfl5lL6O/l+TUwzUifSKTJwXXLr5AJ7I0qVvNLWnQI60Ptd
 Bvih9mKXOvnvBPzS5E9Ted7TVUzfeXVfvmak37ZkuSyuNJUrY6
 AdOKdOGSoUl076thKfDt3a9oiJFUHbrPykXA6SbQ9xP5uirAZT
 LzxreV7LMqRKqHqSL/GY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 02 June 2014 09:24:50 Santosh Shilimkar wrote:
> On Monday 02 June 2014 02:37 AM, Shawn Guo wrote:
> > On Thu, Apr 24, 2014 at 11:30:00AM -0400, Santosh Shilimkar wrote:
> >> Here is an updated v3 of the series. Series introduces support for setting up
> >> dma parameters based on device tree properties like 'dma-ranges' and
> >> 'dma-coherent' and also update to ARM 32 bit port. Earlier version of the
> >> series can be found here [3], [2] and [1].
> > 
> > Are these two generic device tree properties documented somewhere under
> > Documentation/devicetree/bindings?
> > 
> These bindings have been already in use before this series. But looks like
> they have not been documented. I will do a patch to add description for those
> couple of parameters.

dma-ranges is part of ePAPR, and was documented in some ieee-1275 addenda
before that, but I agree it would be nice to have something in kernel as
well, at the minimum something pointing to the relevant documents.

	Arnd

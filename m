Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751536AbaLBJQr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 04:16:47 -0500
Received: from webbox1416.server-home.net ([77.236.96.61]:57029 "EHLO
	webbox1416.server-home.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750840AbaLBJQo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 04:16:44 -0500
From: Alexander Stein <alexander.stein@systec-electronic.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Boris Brezillon <boris.brezillon@free-electrons.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Andrew Victor <linux@maxim.org.za>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Jean-Jacques Hiblot <jjhiblot@traphandler.com>
Subject: Re: [PATCH v3 05/11] memory: add Atmel EBI (External Bus Interface) driver
Date: Tue, 02 Dec 2014 10:18:45 +0100
Message-ID: <1724175.Jqk8gQW3pz@ws-stein>
User-Agent: KMail/4.12.5 (Linux/3.16.5-gentoo; KDE/4.12.5; x86_64; ; )
In-Reply-To: <2417519.MDE3mu6n7n@wuerfel>
References: <1417429647-3419-1-git-send-email-boris.brezillon@free-electrons.com> <20141201115006.08197c40@bbrezillon> <2417519.MDE3mu6n7n@wuerfel>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 01 December 2014 17:17:30, Arnd Bergmann wrote:
> On Monday 01 December 2014 11:50:06 Boris Brezillon wrote:
> > 
> > I don't have a strong opinion regarding where this driver should
> > live (I even considered putting it in drivers/bus) :-).
> > But note that there are other "external memory interface" drivers
> > in drivers/memory too: TI AEMIF and Marvell DEVBUS  ;-).
> > 
> > Does anyone else think this driver should go in drivers/bus ?
> > 
> 
> I think drivers/memory is better.

I don't mind if it's drivers/bus or drivers/memory. But I'm wondering: When is a driver a bus driver when it is a memory driver? See imx-weim and atmel-ebi. Apparently both add support for devices attached on a bus which can be accessed through memory addresses :)

Best regards,
Alexander
-- 
Dipl.-Inf. Alexander Stein

SYS TEC electronic GmbH
Am Windrad 2
08468 Heinsdorfergrund
Tel.: 03765 38600-1156
Fax: 03765 38600-4100
Email: alexander.stein@systec-electronic.com
Website: www.systec-electronic.com
 
Managing Director: Dipl.-Phys. Siegmar Schmidt
Commercial registry: Amtsgericht Chemnitz, HRB 28082


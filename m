Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752560AbbARNLp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 08:11:45 -0500
Received: from down.free-electrons.com ([37.187.137.238]:42143 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751926AbbARNLl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 08:11:41 -0500
Date: Sun, 18 Jan 2015 14:11:36 +0100
From: Boris Brezillon <boris.brezillon@free-electrons.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Felipe Balbi <balbi@ti.com>,
        Jean-Jacques Hiblot <jjhiblot@traphandler.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-usb@vger.kernel.org,
        Nicolas Ferre <nicolas.ferre@atmel.com>, linux-kernel@vger.kernel.org,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 01/12] mfd: syscon: Add atmel-matrix registers
 definition
Message-ID: <20150118141136.5f871014@bbrezillon>
In-Reply-To: <20150118125259.GW3574@x1>
References: <1421252524-24452-1-git-send-email-alexandre.belloni@free-electrons.com>
	<1421252524-24452-2-git-send-email-alexandre.belloni@free-electrons.com>
	<20150118125259.GW3574@x1>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lee,

On Sun, 18 Jan 2015 12:52:59 +0000
Lee Jones <lee.jones@linaro.org> wrote:

> On Wed, 14 Jan 2015, Alexandre Belloni wrote:
> 
> > From: Boris Brezillon <boris.brezillon@free-electrons.com>
> > 
> > AT91 SoCs have a memory range reserved for internal bus configuration.
> > Expose those registers so that drivers can make use of the matrix syscon
> > declared in at91 DTs.
> > 
> > Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
> > Acked-by: Lee Jones <lee.jones@linaro.org>
> > ---
> >  include/linux/mfd/syscon/atmel-matrix.h | 117 ++++++++++++++++++++++++++++++++
> >  1 file changed, 117 insertions(+)
> >  create mode 100644 include/linux/mfd/syscon/atmel-matrix.h
> 
> Applied, thanks.

Actually Nicolas took all the patches in his tree and already sent a PR
to the arm-soc maintainers [1].

Best Regards,

Boris

[1]https://lkml.org/lkml/2015/1/15/542

-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751791AbbASIQs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 03:16:48 -0500
Received: from mail-ie0-f182.google.com ([209.85.223.182]:48760 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751403AbbASIQq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 03:16:46 -0500
Date: Mon, 19 Jan 2015 08:16:40 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Boris Brezillon <boris.brezillon@free-electrons.com>
Cc: Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Felipe Balbi <balbi@ti.com>,
        Jean-Jacques Hiblot <jjhiblot@traphandler.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-usb@vger.kernel.org,
        Nicolas Ferre <nicolas.ferre@atmel.com>, linux-kernel@vger.kernel.org,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 01/12] mfd: syscon: Add atmel-matrix registers definition
Message-ID: <20150119081640.GE21886@x1>
References: <1421252524-24452-1-git-send-email-alexandre.belloni@free-electrons.com>
 <1421252524-24452-2-git-send-email-alexandre.belloni@free-electrons.com>
 <20150118125259.GW3574@x1>
 <20150118141136.5f871014@bbrezillon>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20150118141136.5f871014@bbrezillon>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 18 Jan 2015, Boris Brezillon wrote:

> Hi Lee,
> 
> On Sun, 18 Jan 2015 12:52:59 +0000
> Lee Jones <lee.jones@linaro.org> wrote:
> 
> > On Wed, 14 Jan 2015, Alexandre Belloni wrote:
> > 
> > > From: Boris Brezillon <boris.brezillon@free-electrons.com>
> > > 
> > > AT91 SoCs have a memory range reserved for internal bus configuration.
> > > Expose those registers so that drivers can make use of the matrix syscon
> > > declared in at91 DTs.
> > > 
> > > Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
> > > Acked-by: Lee Jones <lee.jones@linaro.org>
> > > ---
> > >  include/linux/mfd/syscon/atmel-matrix.h | 117 ++++++++++++++++++++++++++++++++
> > >  1 file changed, 117 insertions(+)
> > >  create mode 100644 include/linux/mfd/syscon/atmel-matrix.h
> > 
> > Applied, thanks.
> 
> Actually Nicolas took all the patches in his tree and already sent a PR
> to the arm-soc maintainers [1].
> 
> [1]https://lkml.org/lkml/2015/1/15/542

Very well.  All unapplied.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog

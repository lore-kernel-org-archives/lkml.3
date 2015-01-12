Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752164AbbALWxf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 17:53:35 -0500
Received: from down.free-electrons.com ([37.187.137.238]:58614 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751000AbbALWxd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 17:53:33 -0500
Date: Mon, 12 Jan 2015 23:53:30 +0100
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Boris Brezillon <boris.brezillon@free-electrons.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Andrew Victor <linux@maxim.org.za>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org
Subject: Re: [PATCH 05/11] usb: gadget: at91_udc: Remove non-DT handling code
Message-ID: <20150112225330.GQ2447@piout.net>
References: <1417606330-17753-1-git-send-email-boris.brezillon@free-electrons.com>
 <1417606330-17753-6-git-send-email-boris.brezillon@free-electrons.com>
 <20150112213905.GI2858@saruman>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150112213905.GI2858@saruman>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Felipe,

I've rebased that patch series but it depends on another one (the mfd:
syscon: part of "memory: add Atmel EBI (External Bus Interface) driver")
that is not taken yet so applying it now will break the build. I still
hope to get it merged for 3.20 and I'll resend it as soon as possible.


On 12/01/2015 at 15:39:05 -0600, Felipe Balbi wrote :
> On Wed, Dec 03, 2014 at 12:32:04PM +0100, Boris Brezillon wrote:
> > Since non-DT board support has been removed from the at91 architecture we
> > can safely remove non-DT handling code.
> > 
> > Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
> 
> doesn't apply cleanly:
> 
> checking file drivers/usb/gadget/udc/Kconfig
> checking file drivers/usb/gadget/udc/at91_udc.c
> Hunk #1 succeeded at 1710 (offset 13 lines).
> Hunk #2 succeeded at 1722 (offset 13 lines).
> Hunk #3 succeeded at 1958 (offset 13 lines).
> Hunk #4 FAILED at 1960.
> 1 out of 4 hunks FAILED
> 
> please rebase on testing/next which I just pushed.
> 
> -- 
> balbi



-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

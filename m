Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755014AbaCKMDJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 08:03:09 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:52725 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754937AbaCKMDF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 08:03:05 -0400
Date: Tue, 11 Mar 2014 12:02:59 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Roger Quadros <rogerq@ti.com>
Cc: tony@atomide.com, bcousson@baylibre.com, balbi@ti.com,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH v9 0/9] USB Host support for OMAP5 uEVM
Message-ID: <20140311120259.GI21216@lee--X1>
References: <1393510711-4697-1-git-send-email-rogerq@ti.com>
 <531ECDCB.4060700@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <531ECDCB.4060700@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Hi,
> > 
> > This patchset brings up USB Host ports and Ethernet port on
> > the OMAP5 uEVM board.
> > 
> > It also does some cleanup with respect to DT clock binding
> > for the mfd/omap-usb-host driver.
> > 
> > Please queue these for -next.
> > 
> > Lee,
> > 
> > I've folded some platform data dependent patches with mfd patches
> > so that they don't break functionality when applied individually.
> > You can safely pull in all MFD patches (1 to 6).
> > 
> > Tony & Benoit,
> > 
> > Can you please accept patches 7, 8 and 9?
> 
> Tony has already picked up 7,8 and 9 through omap-soc tree.
> 
> Since you acked most patches except 5 and 6, are you fine if Tony takes
> all the patches 1 to 4 in this series via omap-soc tree?
> 
> What about patches 5 and 6?

Any patches which are orthogonal can just be sucked into whichever tree
they belong in. If there are inter-subsystem dependencies I'd prefer
to take them and issue a immutable branch pull-request to the other
maintainers.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753249AbaKKMby (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 07:31:54 -0500
Received: from mail-ie0-f171.google.com ([209.85.223.171]:62640 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407AbaKKMbw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 07:31:52 -0500
Date: Tue, 11 Nov 2014 12:31:46 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Tony Lindgren <tony@atomide.com>, Samuel Ortiz <sameo@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
Subject: Re: [PATCH] mfd: twl4030-power: Fix poweroff with PM configuration
 enabled
Message-ID: <20141111123146.GB24004@x1>
References: <20141102180756.GH31454@atomide.com>
 <20141110124019.GZ21424@x1>
 <20141110175343.GB4047@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20141110175343.GB4047@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Nov 2014, Russell King - ARM Linux wrote:

> On Mon, Nov 10, 2014 at 12:40:19PM +0000, Lee Jones wrote:
> > On Sun, 02 Nov 2014, Tony Lindgren wrote:
> > 
> > > Commit e7cd1d1eb16f ("mfd: twl4030-power: Add generic reset
> > > configuration") enabled configuring the PM features for twl4030.
> > > 
> > > This caused poweroff command to fail on devices that have the
> > > BCI charger on twl4030 wired, or have power wired for VBUS.
> > > Instead of powering off, the device reboots. This is because
> > > voltage is detected on charger or VBUS with the default bits
> > > enabled for the power transition registers.
> > > 
> > > To fix the issue, let's just clear VBUS and CHG bits as we want
> > > poweroff command to keep the system powered off.
> > > 
> > > Fixes: e7cd1d1eb16f ("mfd: twl4030-power: Add generic reset configuration")
> > > Cc: stable@vger.kernel.org # v3.16+
> > > Reported-by: Russell King <rmk+kernel@arm.linux.org.uk>
> > > Signed-off-by: Tony Lindgren <tony@atomide.com>
> > 
> > Applied to -fixes.
> > 
> > Not sure whether that was an Ack from Russell or not?
> 
> A Tested-by would've been more appropriate than an ack.

Applied.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog

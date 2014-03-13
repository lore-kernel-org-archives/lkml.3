Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754773AbaCMRaQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 13:30:16 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:51373 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754166AbaCMRaN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 13:30:13 -0400
Date: Thu, 13 Mar 2014 13:27:27 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Sebastian Reichel <sre@ring0.de>
Cc: Tony Lindgren <tony@atomide.com>, Luciano Coelho <luca@coelho.fi>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RESEND] [PATCHv2 0/5] wl1251 device tree support
Message-ID: <20140313172726.GC30579@tuxdriver.com>
References: <20140125000929.GD25488@atomide.com>
 <1392419156-14394-1-git-send-email-sre@debian.org>
 <20140226194436.GA20992@earth.universe>
 <20140313170038.GA20372@earth.universe>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140313170038.GA20372@earth.universe>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 13, 2014 at 06:00:39PM +0100, Sebastian Reichel wrote:
> Hi,
> 
> On Wed, Feb 26, 2014 at 08:44:36PM +0100, Sebastian Reichel wrote:
> > On Sat, Feb 15, 2014 at 12:05:51AM +0100, Sebastian Reichel wrote:
> > > The following patchset adds device tree support to the spi variant of the
> > > wl1251 driver, which is used in the Nokia N900. Tony requested, that you
> > > take the whole series even if that may introduce merge conflicts:
> > > 
> > > > Sebastian, please resend the whole series to John and feel free to add my
> > > > acks.  It's best that John picks them all up, otherwise we'll have the same
> > > > issue for v3.15. It seems that we should have just taken the merge conflict
> > > > rather than going back and forth with this.
> > 
> > ping! Is there still anything wrong with this patchset?
> 
> ping! This patchset is quite old now. Please pull it into
> wireless-next, so that it can appear in 3.15.
> 
> -- Sebastian

These are already in wireless-next...

commit edb6e3ec374d5630dfc7a93ddd5c0f4864e98a9d
Author: Sebastian Reichel <sre@debian.org>
Date:   Sat Feb 15 00:05:56 2014 +0100

    Documentation: dt: wireless: Add wl1251
    
    Add device tree binding documentation for Texas Instrument's wl1251
    wireless lan chip. For now only the SPI binding is documented.
    
    Signed-off-by: Sebastian Reichel <sre@debian.org>
    Signed-off-by: John W. Linville <linville@tuxdriver.com>

commit 07bbca6f142d02b4b09d66ed3c2cde36c77057ad
Author: Sebastian Reichel <sre@debian.org>
Date:   Sat Feb 15 00:05:55 2014 +0100

    wl1251: spi: add device tree support
    
    Add device tree support for the spi variant of wl1251.
    
    Signed-off-by: Sebastian Reichel <sre@debian.org>
    Signed-off-by: John W. Linville <linville@tuxdriver.com>

commit e4c2e09e1534835c749de362b9b38e2d8b286236
Author: Sebastian Reichel <sre@debian.org>
Date:   Sat Feb 15 00:05:54 2014 +0100

    wl1251: spi: add vio regulator support
    
    This patch adds support for requesting the regulator powering
    the vio pin.
    
    Signed-off-by: Sebastian Reichel <sre@debian.org>
    Reviewed-by: Pavel Machek <pavel@ucw.cz>
    Signed-off-by: John W. Linville <linville@tuxdriver.com>

commit 1d207cd30b65fdd60d952cb9e100b6f776564f06
Author: Sebastian Reichel <sre@debian.org>
Date:   Sat Feb 15 00:05:53 2014 +0100

    wl1251: move power GPIO handling into the driver
    
    Move the power GPIO handling from the board code into
    the driver. This is a dependency for device tree support.
    
    Signed-off-by: Sebastian Reichel <sre@debian.org>
    Reviewed-by: Pavel Machek <pavel@ucw.cz>
    Acked-by: Tony Lindgren <tony@atomide.com>
    Signed-off-by: John W. Linville <linville@tuxdriver.com>

commit 946651cba26779864bcdbd7e12502f5a36c2de37
Author: Luciano Coelho <coelho@ti.com>
Date:   Sat Feb 15 00:05:52 2014 +0100

    wl1251: split wl251 platform data to a separate structure
    
    Move the wl1251 part of the wl12xx platform data structure into a new
    structure specifically for wl1251.  Change the platform data built-in
    block and board files accordingly.
    
    Signed-off-by: Luciano Coelho <coelho@ti.com>
    Acked-by: Tony Lindgren <tony@atomide.com>
    Reviewed-by: Felipe Balbi <balbi@ti.com>
    Reviewed-by: Sebastian Reichel <sre@debian.org>
    Reviewed-by: Pavel Machek <pavel@ucw.cz>
    Signed-off-by: John W. Linville <linville@tuxdriver.com>

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.

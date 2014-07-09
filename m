Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756672AbaGIVcA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 17:32:00 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:48286 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751861AbaGIVb7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 17:31:59 -0400
Date: Wed, 9 Jul 2014 14:36:24 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/8] phy: phy-samsung-usb2: Change phy power on/power off
 sequence
Message-ID: <20140709213624.GA14556@kroah.com>
References: <1404715705-5041-1-git-send-email-kishon@ti.com>
 <1404715705-5041-4-git-send-email-kishon@ti.com>
 <20140708014442.GB13844@kroah.com>
 <53BB8BDA.3020205@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53BB8BDA.3020205@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 08, 2014 at 11:42:42AM +0530, Kishon Vijay Abraham I wrote:
> Hi Greg,
> 
> On Tuesday 08 July 2014 07:14 AM, Greg KH wrote:
> > On Mon, Jul 07, 2014 at 12:18:20PM +0530, Kishon Vijay Abraham I wrote:
> >> From: Kamil Debski <k.debski@samsung.com>
> >>
> >> The Exynos4412 USB 2.0 PHY hardware differs from the description provided
> >> in the documentation. Some register bits have different function. This
> >> patch fixes the defines of register bits and changes the way how phys are
> >> powered on and off.
> >>
> >> Signed-off-by: Kamil Debski <k.debski@samsung.com>
> >> Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
> >> Tested-by: Daniel Drake <drake@endlessm.com>
> >> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> >> ---
> >>  drivers/phy/phy-exynos4x12-usb2.c |  112 +++++++++++++++++++++++++------------
> >>  drivers/phy/phy-exynos5250-usb2.c |    2 -
> >>  drivers/phy/phy-samsung-usb2.h    |    3 +-
> >>  3 files changed, 77 insertions(+), 40 deletions(-)
> >>
> > 
> > This doesn't look like a regression fix for 3.16-final, it looks like a
> > "new feature" to me :(
> 
> This patch was primarily due to the incorrectly documented register bits in the
> manual. So thought this would qualify as fix and should be in 3.16.

Sorry, that's really big for a patch so late in the -rc cycle.  There
should only be real regressions or reported bugfixes now.

Care to redo this whole series based on these responses?  I can't take
it as-is.

thanks,

greg k-h

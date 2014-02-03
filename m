Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753387AbaBCUHL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 15:07:11 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:45815 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752309AbaBCUHJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 15:07:09 -0500
Date: Mon, 3 Feb 2014 21:08:42 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Aaro Koskinen <aaro.koskinen@iki.fi>
Cc: devel@driverdev.osuosl.org, David Daney <ddaney.cavm@gmail.com>,
        linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
        ralf@linux-mips.org, David Daney <david.daney@cavium.com>
Subject: Re: [PATCH 0/2] MIPS/staging: Probe octeon-usb driver via device-tree
Message-ID: <20140203200842.GC7717@kroah.com>
References: <1386100012-6077-1-git-send-email-ddaney.cavm@gmail.com>
 <20131204232953.GA7698@kroah.com>
 <20140203183506.GE589@drone.musicnaut.iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140203183506.GE589@drone.musicnaut.iki.fi>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 03, 2014 at 08:35:06PM +0200, Aaro Koskinen wrote:
> Hi,
> 
> On Wed, Dec 04, 2013 at 03:29:53PM -0800, Greg Kroah-Hartman wrote:
> > On Tue, Dec 03, 2013 at 11:46:50AM -0800, David Daney wrote:
> > > From: David Daney <david.daney@cavium.com>
> > > 
> > > Tested against both EdgeRouter LITE (no bootloader supplied device
> > > tree), and ebb5610 (device tree supplied by bootloader).
> > > 
> > > The patch set is spread across both the MIPS and staging trees, so it
> > > would be great if Ralf could merge at least the MIPS parts, if not
> > > both parts.
> > 
> > That's fine with me:
> > 
> > Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> It seems only the MIPS part was merged, and as a result the OCTEON
> USB build is now broken in 3.14-rc1.
> 
> Would it be possible to merge the missing part through the staging
> tree? The original is here: http://patchwork.linux-mips.org/patch/6186/
> The below one is rebased for 3.14-rc1 and tested on EdgeRouter Lite.

Sure, I can queue it up for 3.14, and will do so in a few days.

thanks,

greg k-h

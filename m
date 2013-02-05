Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755737Ab3BERZS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 12:25:18 -0500
Received: from mail-da0-f47.google.com ([209.85.210.47]:37046 "EHLO
	mail-da0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755023Ab3BERZO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 12:25:14 -0500
Date: Tue, 5 Feb 2013 09:27:24 -0800
From: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To: kishon <kishon@ti.com>
Cc: Tony Lindgren <tony@atomide.com>, Felipe Balbi <balbi@ti.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>
Subject: Re: [GIT PULL] ARM part of USB patches
Message-ID: <20130205172724.GA1601@kroah.com>
References: <51112418.5020000@ti.com>
 <51112495.4060908@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51112495.4060908@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 05, 2013 at 08:56:13PM +0530, kishon wrote:
> Hi Tony, Greg,
> 
> On Tuesday 05 February 2013 08:54 PM, kishon wrote:
> >Hi Tony,
> >
> >As discussed, I'm sending a pull request for the arch/arm part of my USB
> >patches. These patches are necessary to get MUSB functional in both dt
> >and non-dt boot. Also added dt data for dwc3 present in OMAP. This patch
> >series *depends* on some of the patches which are merged in usb-next.
> 
> This patch series should go in only after USB. Or else it will break
> compilation.

Then it probably should go through the USB tree, right?  We don't want
to break bisectability.

thanks,

greg k-h

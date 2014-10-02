Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752045AbaJBQYA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 12:24:00 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52451 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751676AbaJBQX6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 12:23:58 -0400
Date: Thu, 2 Oct 2014 09:23:57 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Mathias Nyman <mathias.nyman@linux.intel.com>
Cc: Andrew Bresticker <abrestic@chromium.org>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Julius Werner <jwerner@chromium.org>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: Re: [PATCH v3 0/4] Allow xHCI drivers to be built as separate modules
Message-ID: <20141002162357.GA32555@kroah.com>
References: <1408467712-27497-1-git-send-email-abrestic@chromium.org>
 <CAL1qeaFwGYgzL=n0My4eBQMhvtNQfHpU5d1tif0twtYyjw5yqg@mail.gmail.com>
 <540F0E53.4050106@linux.intel.com>
 <542D7DC7.90300@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <542D7DC7.90300@linux.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 02, 2014 at 07:31:03PM +0300, Mathias Nyman wrote:
> On 09/09/2014 05:27 PM, Mathias Nyman wrote:
> > On 09/03/2014 10:51 PM, Andrew Bresticker wrote:
> >> Mathias,
> >>
> >> On Tue, Aug 19, 2014 at 10:01 AM, Andrew Bresticker
> >> <abrestic@chromium.org> wrote:
> >>> It was suggested in the review of the Tegra xHCI driver [1] that we
> >>> allow xHCI drivers to be built as individual modules (like EHCI) instead
> >>> of building them all into the single xhci-hcd module as they are today.
> >>>
> >>> Patches 1-3 prepare for making the xHCI PCI and platform drivers able
> >>> to be built as individual modules and patch 4 actually creates the 3
> >>> separate modules (core, platform, PCI).
> >>>
> >>> Based on 3.17-rc1.
> >>>
> >>> Changes from v2:
> >>>  - fixed typo in xhci_register_plat
> >>>  - exported another symbol needed by xhci-pci module
> >>> Changes from v1:
> >>>  - rebased on changes introduced by xhci-rcar driver
> >>>
> >>> [1] http://patchwork.ozlabs.org/patch/361265/
> >>>
> >>> Andrew Bresticker (4):
> >>>   xhci: Introduce xhci_init_driver()
> >>>   xhci: Check for XHCI_COMP_MODE_QUIRK when disabling D3cold
> >>>   xhci: Export symbols used by host-controller drivers
> >>>   xhci: Allow xHCI drivers to be built as separate modules
> >>
> >> Any thoughts/comments on this series?
> >>
> >>
> > 
> > Sorry about the delay.
> > When I start looking at this I always get interrupted by some fire that needs to be put out.
> > 
> > I still need some more time to go through it
> > 
> > -Mathias
> > 
> > --
> >
> 
> Ok, finally found the time to look through it. Sorry about the long wait
> 
> The whole series look good, and its now more in line with how ehci does things (like using *hci_init_driver())
> 
> Series still apply nicely on usb-next.
> 
> Greg, any chance this still can get to your usb-next and to the 3.18 merge window?
> Tegra developers seem eager to get it in, and I feel bad for not reviewing it earlier. 

They aren't in my patch queue anymore, so please send them, with your
signed-off-by, and I will try to get them in.

greg k-h

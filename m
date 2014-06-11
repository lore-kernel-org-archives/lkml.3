Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932926AbaFKPWQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 11:22:16 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47168 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932123AbaFKPWO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 11:22:14 -0400
Date: Wed, 11 Jun 2014 08:26:04 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Lu Baolu <baolu.lu@linux.intel.com>
Cc: Mathias Nyman <mathias.nyman@intel.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] xhci: clear root port wake on bits if controller
 isn't wake-up capable
Message-ID: <20140611152604.GA27630@kroah.com>
References: <1402439120-78151-1-git-send-email-baolu.lu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1402439120-78151-1-git-send-email-baolu.lu@linux.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 11, 2014 at 06:25:20AM +0800, Lu Baolu wrote:
> When the xHCI PCI host is suspended, if do_wakeup is false in xhci_pci_suspend,
> xhci_bus_suspend needs to clear all root port wake on bits. Otherwise some Intel
> platform may get a spurious wakeup, even if PCI PME# is disabled.
> 
> http://marc.info/?l=linux-usb&m=138194006009255&w=2
> 
> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
> ---
>  drivers/usb/host/xhci-hub.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)

Should this also be a stable kernel patch?  If so, how far back?

thanks,

greg k-h

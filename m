Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752642AbaDXTq5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 15:46:57 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38892 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752568AbaDXTqz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 15:46:55 -0400
Date: Thu, 24 Apr 2014 12:49:48 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Mathias Nyman <mathias.nyman@linux.intel.com>
Cc: linux-usb@vger.kernel.org, sarah.a.sharp@linux.intel.com,
        linux-kernel@vger.kernel.org,
        Denis Turischev <denis.turischev@compulab.co.il>,
        Denis Turischev <denis@compulab.co.il>
Subject: Re: [PATCH 3/5] xhci: Switch Intel Lynx Point ports to EHCI on
 shutdown.
Message-ID: <20140424194948.GC12809@kroah.com>
References: <1398169382-12097-1-git-send-email-mathias.nyman@linux.intel.com>
 <1398169382-12097-4-git-send-email-mathias.nyman@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398169382-12097-4-git-send-email-mathias.nyman@linux.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2014 at 03:23:00PM +0300, Mathias Nyman wrote:
> From: Denis Turischev <denis.turischev@compulab.co.il>
> 
> The same issue like with Panther Point chipsets. If the USB ports are
> switched to xHCI on shutdown, the xHCI host will send a spurious interrupt,
> which will wake the system. Some BIOS have work around for this, but not all.
> One example is Compulab's mini-desktop, the Intense-PC2.
> 
> The bug can be avoided if the USB ports are switched back to EHCI on
> shutdown.
> 
> Signed-off-by: Denis Turischev <denis@compulab.co.il>
> Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
> ---
>  drivers/usb/host/xhci-pci.c | 2 ++
>  1 file changed, 2 insertions(+)

No stable marking?  Why not?


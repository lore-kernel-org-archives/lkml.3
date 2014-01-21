Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753970AbaAUWS2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 17:18:28 -0500
Received: from mga09.intel.com ([134.134.136.24]:34943 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753665AbaAUWS0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 17:18:26 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,697,1384329600"; 
   d="scan'208";a="470363745"
Date: Tue, 21 Jan 2014 14:17:06 -0800
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Branimir Maksimovic <branimir.maksimovic@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: latest git usb3.0 ports not working
Message-ID: <20140121221706.GC12657@xanatos>
References: <52DEC0BA.1060007@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52DEC0BA.1060007@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 21, 2014 at 07:47:22PM +0100, Branimir Maksimovic wrote:
> asus maximus v gene motherboard,
> this is from dmesg:
> 
> [   75.576160] xhci_hcd 0000:03:00.0: Timeout while waiting for a slot
> [   88.991634] xhci_hcd 0000:03:00.0: Stopped the command ring
> failed, maybe the host is dead
> [   88.991748] xhci_hcd 0000:03:00.0: Abort command ring failed
> [   88.991845] xhci_hcd 0000:03:00.0: HC died; cleaning up
> [   93.985489] xhci_hcd 0000:03:00.0: Timeout while waiting for a slot
> [   93.985494] xhci_hcd 0000:03:00.0: Abort the command ring, but
> the xHCI is dead.
> [   98.982586] xhci_hcd 0000:03:00.0: Timeout while waiting for a slot
> [   98.982591] xhci_hcd 0000:03:00.0: Abort the command ring, but
> the xHCI is dead.
> [  103.979696] xhci_hcd 0000:03:00.0: Timeout while waiting for a slot
> [  103.979702] xhci_hcd 0000:03:00.0: Abort the command ring, but
> the xHCI is dead.

By latest git, do you mean linus/master, or 3.13.0?  If it's
linus/master, please provide the commit ID.  Which kernel version worked
for you?

Sarah Sharp

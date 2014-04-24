Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752780AbaDXTrN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 15:47:13 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38895 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752679AbaDXTrK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 15:47:10 -0400
Date: Thu, 24 Apr 2014 12:50:03 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Mathias Nyman <mathias.nyman@linux.intel.com>
Cc: linux-usb@vger.kernel.org, sarah.a.sharp@linux.intel.com,
        linux-kernel@vger.kernel.org,
        Igor Gnatenko <i.gnatenko.brain@gmail.com>
Subject: Re: [PATCH 4/5] xhci: extend quirk for Renesas cards
Message-ID: <20140424195003.GD12809@kroah.com>
References: <1398169382-12097-1-git-send-email-mathias.nyman@linux.intel.com>
 <1398169382-12097-5-git-send-email-mathias.nyman@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398169382-12097-5-git-send-email-mathias.nyman@linux.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2014 at 03:23:01PM +0300, Mathias Nyman wrote:
> From: Igor Gnatenko <i.gnatenko.brain@gmail.com>
> 
> After suspend another Renesas PCI-X USB 3.0 card doesn't work.
> [root@fedora-20 ~]# lspci -vmnnd 1912:
> Device:	03:00.0
> Class:	USB controller [0c03]
> Vendor:	Renesas Technology Corp. [1912]
> Device:	uPD720202 USB 3.0 Host Controller [0015]
> SVendor:	Renesas Technology Corp. [1912]
> SDevice:	uPD720202 USB 3.0 Host Controller [0015]
> Rev:	02
> ProgIf:	30
> 
> Reported-and-tested-by: Anatoly Kharchenko <rfr-bugs@yandex.ru>
> Reference: http://redmine.russianfedora.pro/issues/1315
> Signed-off-by: Igor Gnatenko <i.gnatenko.brain@gmail.com>
> Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
> ---
>  drivers/usb/host/xhci-pci.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)

Again, no stable?


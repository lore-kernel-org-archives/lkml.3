Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752893AbaDXTrm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 15:47:42 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38898 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751177AbaDXTrj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 15:47:39 -0400
Date: Thu, 24 Apr 2014 12:50:32 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Mathias Nyman <mathias.nyman@linux.intel.com>
Cc: linux-usb@vger.kernel.org, sarah.a.sharp@linux.intel.com,
        linux-kernel@vger.kernel.org,
        David Cohen <david.a.cohen@linux.intel.com>
Subject: Re: [PATCH 5/5] usb/xhci: fix compilation warning when !CONFIG_PCI
 && !CONFIG_PM
Message-ID: <20140424195032.GE12809@kroah.com>
References: <1398169382-12097-1-git-send-email-mathias.nyman@linux.intel.com>
 <1398169382-12097-6-git-send-email-mathias.nyman@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1398169382-12097-6-git-send-email-mathias.nyman@linux.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2014 at 03:23:02PM +0300, Mathias Nyman wrote:
> From: David Cohen <david.a.cohen@linux.intel.com>
> 
> When CONFIG_PCI and CONFIG_PM are not selected, xhci.c gets this
> warning:
> drivers/usb/host/xhci.c:409:13: warning: ‘xhci_msix_sync_irqs’ defined
> but not used [-Wunused-function]
> 
> Instead of creating nested #ifdefs, this patch fixes it by defining the
> xHCI PCI stubs as inline.
> 
> Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
> Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
> ---
>  drivers/usb/host/xhci.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)

What patch caused this problem?  Does it show up in 3.14?  3.10?  2.0?
:)

Please be more specific...


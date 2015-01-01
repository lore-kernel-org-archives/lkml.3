Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752014AbbAARvZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2015 12:51:25 -0500
Received: from casper.infradead.org ([85.118.1.10]:54694 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750739AbbAARvX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2015 12:51:23 -0500
Message-ID: <54A58916.3020802@infradead.org>
Date: Thu, 01 Jan 2015 09:51:18 -0800
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org
CC: linux-kernel@vger.kernel.org, USB list <linux-usb@vger.kernel.org>,
        Paul Zimmerman <paulz@synopsys.com>
Subject: Re: linux-next: Tree for Dec 31 (usb/dwc2)
References: <20141231122902.76fc458e@canb.auug.org.au>
In-Reply-To: <20141231122902.76fc458e@canb.auug.org.au>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/30/14 17:29, Stephen Rothwell wrote:
> Hi all,
> 
> There will only be intermittent releases of linux-next between now and
> Jan 5.
> 
> Changes since 20141226:
> 

on i386, when CONFIG_USB=m, CONFIG_USB_GADGET=y, and CONFIG_USB_DWC2=y:

drivers/built-in.o: In function `_dwc2_hcd_urb_dequeue':
hcd.c:(.text+0x7db39): undefined reference to `usb_hcd_check_unlink_urb'
hcd.c:(.text+0x7dc50): undefined reference to `usb_hcd_unlink_urb_from_ep'
hcd.c:(.text+0x7dc76): undefined reference to `usb_hcd_giveback_urb'
drivers/built-in.o: In function `_dwc2_hcd_start':
hcd.c:(.text+0x7e707): undefined reference to `usb_hcd_resume_root_hub'
drivers/built-in.o: In function `dwc2_assign_and_init_hc':
hcd.c:(.text+0x7f969): undefined reference to `usb_hcd_unmap_urb_for_dma'
drivers/built-in.o: In function `_dwc2_hcd_urb_enqueue':
hcd.c:(.text+0x7fd81): undefined reference to `usb_hcd_link_urb_to_ep'
hcd.c:(.text+0x7ff66): undefined reference to `usb_hcd_unlink_urb_from_ep'
drivers/built-in.o: In function `dwc2_host_complete':
(.text+0x800fc): undefined reference to `usb_hcd_unlink_urb_from_ep'
drivers/built-in.o: In function `dwc2_host_complete':
(.text+0x8012c): undefined reference to `usb_hcd_giveback_urb'
drivers/built-in.o: In function `dwc2_hcd_init':
(.text+0x8060a): undefined reference to `usb_disabled'
drivers/built-in.o: In function `dwc2_hcd_init':
(.text+0x80735): undefined reference to `usb_create_hcd'
drivers/built-in.o: In function `dwc2_hcd_init':
(.text+0x80a91): undefined reference to `usb_add_hcd'
drivers/built-in.o: In function `dwc2_hcd_init':
(.text+0x80acc): undefined reference to `usb_put_hcd'
drivers/built-in.o: In function `dwc2_hcd_remove':
(.text+0x80ba2): undefined reference to `usb_remove_hcd'
drivers/built-in.o: In function `dwc2_hcd_remove':
(.text+0x80bc1): undefined reference to `usb_put_hcd'
drivers/built-in.o: In function `dwc2_hc_handle_tt_clear.isra.13':
hcd_intr.c:(.text+0x80f9a): undefined reference to `usb_hub_clear_tt_buffer'
drivers/built-in.o: In function `dwc2_hcd_qtd_add':
(.text+0x82e14): undefined reference to `usb_calc_bus_time'




-- 
~Randy

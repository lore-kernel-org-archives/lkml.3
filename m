Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753647Ab3DVVpc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 17:45:32 -0400
Received: from casper.infradead.org ([85.118.1.10]:37858 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752622Ab3DVVpb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 17:45:31 -0400
Message-ID: <5175AF66.8070906@infradead.org>
Date: Mon, 22 Apr 2013 14:45:10 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: werner <w.landgraf@ru.ru>
CC: linux-kernel@vger.kernel.org
Subject: Re: 3.9-rc2  this dont compile / link    dwc3_gadget , usb_gadget_map_request
References: <web-853669895@zbackend1.aha.ru>
In-Reply-To: <web-853669895@zbackend1.aha.ru>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/11/13 02:27, werner wrote:
> 
> drivers/built-in.o: In function `__dwc3_gadget_kick_transfer':
> gadget.c:(.text+0xbb21d9): undefined reference to `usb_gadget_unmap_request'
> drivers/built-in.o: In function `__dwc3_gadget_ep_queue':
> gadget.c:(.text+0xbb22a9): undefined reference to `usb_gadget_map_request'
> drivers/built-in.o: In function `dwc3_gadget_giveback':
> (.text+0xbb24db): undefined reference to `usb_gadget_unmap_request'
> drivers/built-in.o: In function `dwc3_gadget_exit':
> (.text+0xbb2e52): undefined reference to `usb_del_gadget_udc'
> drivers/built-in.o: In function `dwc3_gadget_init':
> (.text+0xbb3a88): undefined reference to `usb_add_gadget_udc'
> drivers/built-in.o: In function `__dwc3_ep0_do_control_data':
> ep0.c:(.text+0xbb3f10): undefined reference to `usb_gadget_map_request'
> ep0.c:(.text+0xbb3f6a): undefined reference to `usb_gadget_map_request'

Hi Werner,

Has this been fixed?  If not, please provide your kernel .config file.

thanks,
-- 
~Randy

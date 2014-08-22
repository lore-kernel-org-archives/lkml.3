Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751569AbaHVT11 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 15:27:27 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:53469 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925AbaHVT10 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 15:27:26 -0400
Date: Fri, 22 Aug 2014 12:27:25 -0700 (PDT)
Message-Id: <20140822.122725.770028169477728776.davem@davemloft.net>
To: himangi774@gmail.com
Cc: hjlipp@web.de, tilman@imap.cc, isdn@linux-pingi.de,
        gigaset307x-common@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, julia.lawall@lip6.fr
Subject: Re: [PATCH] isdn/gigaset: use USB API functions rather than
 constants
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140815162412.GA7192@himangi-Dell>
References: <20140815162412.GA7192@himangi-Dell>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 22 Aug 2014 12:27:25 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Himangi Saraogi <himangi774@gmail.com>
Date: Fri, 15 Aug 2014 21:54:12 +0530

> This patch introduces the use of the function usb_endpoint_num.
> 
> The Coccinelle semantic patch that makes these changes is as follows:
> 
> @@ struct usb_endpoint_descriptor *epd; @@
> 
> - (epd->bEndpointAddress & \(USB_ENDPOINT_NUMBER_MASK\|0x0f\))
> + usb_endpoint_num(epd)
> 
> Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
> Acked-by: Julia Lawall <julia.lawall@lip6.fr>

Applied.

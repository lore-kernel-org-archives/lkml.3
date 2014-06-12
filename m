Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751611AbaFLRuL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 13:50:11 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33944 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751213AbaFLRuJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 13:50:09 -0400
Date: Thu, 12 Jun 2014 10:54:00 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Wahib Faizi <wahibfaizi@gmail.com>
Cc: Valentina Manea <valentina.manea.m@gmail.com>, linux-usb@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2]
 drivers/staging/usbip/userspace/libsrc/usbip_host_driver.c: fix coding style
Message-ID: <20140612175400.GA30060@kroah.com>
References: <1402569338-5709-1-git-send-email-wahibfaizi@gmail.com>
 <1402594340-10867-1-git-send-email-wahibfaizi@gmail.com>
 <1402594340-10867-2-git-send-email-wahibfaizi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1402594340-10867-2-git-send-email-wahibfaizi@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 12, 2014 at 09:32:19PM +0400, Wahib Faizi wrote:
> Fix coding style issue "do not use assignment in if condition"
> detected by checkpatch.pl in usbip_host_driver.c.
> 
> Signed-off-by: Wahib Faizi <wahibfaizi@gmail.com>

Both of these patches have the same Subject: line, which isn't good as
it doesn't make much sense.

You can also shorten it a lot, for example, this one should be:
  Subject: staging: usbip: usbip_host_driver.c: fix if assignment style issue

Care to redo both of these that way?

thanks,

greg k-h

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757877Ab3HBHfc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 03:35:32 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34536 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756907Ab3HBHfa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 03:35:30 -0400
Date: Fri, 2 Aug 2013 15:36:46 +0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Joe Perches <joe@perches.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-usb <linux-usb@vger.kernel.org>
Subject: Re: [PATCH resend] MAINTAINERS: Add separate section for USB
 NETWORKING DRIVERS
Message-ID: <20130802073646.GA26981@kroah.com>
References: <1375316960686@kroah.org>
 <1375416212.2034.101.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375416212.2034.101.camel@joe-AO722>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 01, 2013 at 09:03:32PM -0700, Joe Perches wrote:
> There are several drivers in drivers/net/usb/ that
> do not have specific MAINTAINERS that should have
> emails forwarded to the linux-usb mailing list.
> 
> Add a section for those drivers.

Thanks, I'll queue this up next week for the next round of patches to go
to Linus.

greg k-h

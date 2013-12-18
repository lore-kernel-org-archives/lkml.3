Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752234Ab3LRXrm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 18:47:42 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:37848 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751954Ab3LRXrl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 18:47:41 -0500
Date: Wed, 18 Dec 2013 15:47:43 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Evgeniy Polyakov <zbr@ioremap.net>
Cc: Levente Kurusa <levex@linux.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/4] w1: call put_device if device_register fails
Message-ID: <20131218234743.GB14527@kroah.com>
References: <1386962557-8899-1-git-send-email-levex@linux.com>
 <1386962557-8899-5-git-send-email-levex@linux.com>
 <216611387034229@web23g.yandex.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <216611387034229@web23g.yandex.ru>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 14, 2013 at 07:17:09PM +0400, Evgeniy Polyakov wrote:
> Hi
> 
> 13.12.2013, 23:23, "Levente Kurusa" <levex@linux.com>:
> > Currently, memsetting and kfreeing the device is bad behaviour.
> > The device will have a reference count of 1 and hence can cause trouble
> > because it has kfree'd. Proper way to handle a failed device_register
> > is to call put_device right after it fails.
> 
> Looks good to me, thank you
> Greg, please pull it into your treee
> 
> > Signed-off-by: Levente Kurusa <levex@linux.com>
> 
> Acked-by: Evgeniy Polyakov <zbr@ioremap.net>

I don't seem to have this patch anywhere, can someone please resend it
to me?

thanks,

greg k-h

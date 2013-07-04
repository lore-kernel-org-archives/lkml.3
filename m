Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756812Ab3GDQSV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 12:18:21 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47907 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756525Ab3GDQSU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 12:18:20 -0400
Date: Thu, 4 Jul 2013 09:19:11 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Oleksandr Kravchenko <o.v.kravchenko@globallogic.com>
Cc: linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org, arnd@arndb.de,
        jic23@cam.ac.uk
Subject: Re: Issue with porting i2c driver to k3.10 (iio)
Message-ID: <20130704161911.GC20907@kroah.com>
References: <CAGH3droX_J9JJ60EP6d62Sh6MK6T5WvYTq+uwcmJkwb0c1Yurg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGH3droX_J9JJ60EP6d62Sh6MK6T5WvYTq+uwcmJkwb0c1Yurg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 04, 2013 at 04:16:43PM +0300, Oleksandr Kravchenko wrote:
> Hi All,
> 
> I wrote i2c driver for APDS-9300 light sensor in drivers/misc, but I have some
> questions regarding upstreaming of it.
> 1. It works properly in kernel-3.4, but it works very slow in kernel-3.10 (on
> mutex and i2c operations, particulary on mutex_lock() and i2c_smbus_read_data
> ()). Does anyone know why this issue may be occurred?

What is "slow"?  Have you run 'perf' on the driver to see where it is
spending time?

> 2. Can I send this driver without using Industrial I/O framework?

No, why would you even want to?

greg k-h

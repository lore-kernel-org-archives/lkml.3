Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754016AbaAUHux (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 02:50:53 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39258 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753918AbaAUHum (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 02:50:42 -0500
Date: Mon, 20 Jan 2014 23:51:23 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: stefani@seibold.net
Cc: linux-kernel@vger.kernel.org
Subject: VDSO support for 32bit time functions
Message-ID: <20140121075123.GA32170@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stefani,

About a year ago you posted a big patch to implement VDSO support for
32bit functions, and the response was a request to clean it up a bit by
breaking up the generic bits into a series to make it easier to review /
apply.

The patch I'm referring to can be found here:
	http://thread.gmane.org/gmane.linux.kernel/1411713

Did that ever happen?

If not, any specific reason why?  Do you have a newer version somewhere
for "modern" kernel versions?

If you're not interested in this anymore, mind if I take it up based on
your last version?

I'm getting some complaints that this type of thing would really be good
as 32bit gettimeofday() on 64bit kernels is really slow (65 nanoseconds
on 32bit vs. 17 nanoseconds on 64bit on a high-end i7 processor.)

thanks,

greg k-h

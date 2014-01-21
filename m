Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752553AbaAUVMf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 16:12:35 -0500
Received: from www84.your-server.de ([213.133.104.84]:36992 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750824AbaAUVMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 16:12:33 -0500
X-Greylist: delayed 1161 seconds by postgrey-1.27 at vger.kernel.org; Tue, 21 Jan 2014 16:12:33 EST
Message-ID: <1390337646.1613.12.camel@wall-e.seibold.net>
Subject: Re: VDSO support for 32bit time functions
From: Stefani Seibold <stefani@seibold.net>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org
Date: Tue, 21 Jan 2014 21:54:06 +0100
In-Reply-To: <20140121075123.GA32170@kroah.com>
References: <20140121075123.GA32170@kroah.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grek,

On Monday, the 20.01.2014, 23:51 -0800 wrote Greg KH:
> Hi Stefani,
> 
> About a year ago you posted a big patch to implement VDSO support for
> 32bit functions, and the response was a request to clean it up a bit by
> breaking up the generic bits into a series to make it easier to review /
> apply.
> 
> The patch I'm referring to can be found here:
> 	http://thread.gmane.org/gmane.linux.kernel/1411713
> 
> Did that ever happen?
> 

I have revamped the patch, but the request for the IA32_EMULATION is
still pending. I have now a solution for this which i had already
implemented, but i need to do some tests.

> If not, any specific reason why?  Do you have a newer version somewhere
> for "modern" kernel versions?
> 

Currently my latest version is for 3.10, but i think i can bring it to
3.13. I will do this next weekend and post the patch.

> If you're not interested in this anymore, mind if I take it up based on
> your last version?
> 

I am interested since i must port again and again to the next kernel
version for my devices. 

Your support will be welcome.

> I'm getting some complaints that this type of thing would really be good
> as 32bit gettimeofday() on 64bit kernels is really slow (65 nanoseconds
> on 32bit vs. 17 nanoseconds on 64bit on a high-end i7 processor.)
> 

Stay tune until next week.

- Stefani



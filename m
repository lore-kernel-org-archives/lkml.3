Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753509AbaEDU1k (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 16:27:40 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38488 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751362AbaEDU1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 16:27:39 -0400
Date: Sun, 4 May 2014 16:27:38 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, satoru.takeuchi@gmail.com,
        shuah.kh@samsung.com, stable@vger.kernel.org
Subject: Re: [PATCH 3.14 000/158] 3.14.3-stable review
Message-ID: <20140504202738.GA25318@kroah.com>
References: <20140504154029.975081050@linuxfoundation.org>
 <5366769D.2010104@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5366769D.2010104@roeck-us.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 04, 2014 at 10:19:25AM -0700, Guenter Roeck wrote:
> On 05/04/2014 08:38 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 3.14.3 release.
> > There are 158 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Tue May  6 15:38:47 UTC 2014.
> > Anything received after that time might be too late.
> >
> 
> Build results:
> 	total: 127 pass: 121 skipped: 4 fail: 2
> 
> Qemu tests all passed.
> 
> Additional failure is from new build target unicore32:defconfig, which fails
> in all releases. The second failure is powerpc:allmodconfig which, together
> with powerpc:allyesconfig, fails to build in 3.14 and later kernels.
> Results are therefore as expected.
> 
> Details are available at http://server.roeck-us.net:8010/builders.
> 

If unicore32 doesn't build on any kernel version, should we just drop
the whole arch?

I'd suggest the same for powerpc, but odds are, there are still users :)

thanks,

greg k-h

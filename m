Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755828Ab3JCVS2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 17:18:28 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:41257 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755405Ab3JCVSZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 17:18:25 -0400
Date: Thu, 3 Oct 2013 14:18:18 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org
Subject: Re: [ 00/13] 3.0.99-stable review
Message-ID: <20131003211818.GA12828@roeck-us.net>
References: <20131003040400.753642257@linuxfoundation.org>
 <524D0663.209@roeck-us.net>
 <20131003184048.GB8901@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131003184048.GB8901@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 03, 2013 at 11:40:48AM -0700, Greg Kroah-Hartman wrote:
> On Wed, Oct 02, 2013 at 10:53:39PM -0700, Guenter Roeck wrote:
> > On 10/02/2013 09:04 PM, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 3.0.99 release.
> > > There are 13 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > >
> > > Responses should be made by Sat Oct  5 04:03:47 UTC 2013.
> > > Anything received after that time might be too late.
> > >
> > > The whole patch series can be found in one patch at:
> > > 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.0.99-rc1.gz
> > > and the diffstat can be found below.
> > >
> > 
> > Heads up: I am getting lots of build failures in 3.0 and 3.4 builds.
> > 
> > mm/built-in.o: In function `__put_compound_page':
> > slab.c:(.text+0xaa3c): undefined reference to `PageHuge'
> > mm/built-in.o: In function `put_compound_page':
> > slab.c:(.text+0xaab0): undefined reference to `PageHuge'
> > mm/built-in.o: In function `__get_page_tail':
> > slab.c:(.text+0xb178): undefined reference to `PageHuge'
> > make: *** [.tmp_vmlinux1] Error 1
> > 
> > More tomorrow.
> 
> Should now be fixed, if not, please let me know.
> 
Yes, much better:
	total: 98 pass: 71 skipped: 16 fail: 11
This matches the results from the previous release.

qemu tests also pass.

Details are at http://server.roeck-us.net:8010/builders, as usual.

Thanks,
Guenter

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757972Ab3IFQkM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 12:40:12 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33645 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757583Ab3IFQkI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 12:40:08 -0400
Date: Fri, 6 Sep 2013 09:40:07 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org
Subject: Re: [ 00/36] 3.10.11-stable review
Message-ID: <20130906164007.GC17541@kroah.com>
References: <20130905202702.289738686@linuxfoundation.org>
 <20130905225922.GC1358@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130905225922.GC1358@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 05, 2013 at 03:59:22PM -0700, Guenter Roeck wrote:
> On Thu, Sep 05, 2013 at 01:27:29PM -0700, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 3.10.11 release.
> > There are 36 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sat Sep  7 20:26:25 UTC 2013.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.10.11-rc1.gz
> > and the diffstat can be found below.
> > 
> buildbot says:
>         total: 100 pass: 100 skipped: 0 fail: 0
> Just like the previous release, this is a perfect result. Time to add some
> failing builds to raise the challenge ?

Heh, no, I like it as-is :)

> qemu test runs for arm, microblaze, mips, mips64, ppc, x86, and x86_64 are fine.

Thanks for testing and letting me know.

greg k-h

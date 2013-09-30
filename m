Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754325Ab3I3BuJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 21:50:09 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33435 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753213Ab3I3BuF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 21:50:05 -0400
Date: Sun, 29 Sep 2013 18:50:07 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org
Subject: Re: [ 00/17] 3.0.98-stable review
Message-ID: <20130930015007.GA13344@kroah.com>
References: <20130929190757.138351117@linuxfoundation.org>
 <5248D2E4.10206@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5248D2E4.10206@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 29, 2013 at 06:24:52PM -0700, Guenter Roeck wrote:
> On 09/29/2013 12:26 PM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 3.0.98 release.
> > There are 17 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Tue Oct  1 19:07:47 UTC 2013.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> > 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.0.98-rc1.gz
> > and the diffstat can be found below.
> >
> 
> 
> Build test results:
> 	total: 98 pass: 71 skipped: 16 fail: 11
> 
> qemu:
> 	ppc, sh, sparc, x86, x86_64 passed
> 	arm, microblaze, mips, mips64, sparc64 skipped
> 
> Same results as with 3.0.97.

Nice, thanks for testing and letting me know.

greg k-h

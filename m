Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755736Ab3HZEYj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 00:24:39 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:49869 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755179Ab3HZEYi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 00:24:38 -0400
Date: Sun, 25 Aug 2013 21:26:53 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Steve Cotton <steve@s.cotton.clara.co.uk>
Subject: Re: Commit 9a11899 (USB: OHCI: add missing PCI PM callbacks to
 ohci-pci.c) breaks several builds
Message-ID: <20130826042653.GA2778@kroah.com>
References: <521ACBEF.60006@roeck-us.net>
 <521AD347.1090601@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <521AD347.1090601@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 25, 2013 at 09:02:15PM -0700, Guenter Roeck wrote:
> On 08/25/2013 08:30 PM, Guenter Roeck wrote:
> > Broken builds:
> >      mips:ath79_defconfig
> >      parisc:defconfig
> >      sparc32:defconfig
> >      sparc64:defconfig
> >      tile:defconfig
> >
> Add:
> 	powerpc:ppc64e_defconfig
> 	powerpc:cell_defconfig
> 	powerps:maple_defconfig
> 
> That makes it 8 out of 82 builds, or roughly 10% of all builds.
> 
> My qemu test build for powerpc (which has its own config file)  fails as well :(.

Ugh, I got no reports of this from linux-next or the 0-day build system,
odd.

Alan, can you send a follow-on patch to fix this?

thanks,

greg k-h

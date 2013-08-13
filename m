Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758873Ab3HMR7B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 13:59:01 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38829 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757355Ab3HMR67 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 13:58:59 -0400
Date: Tue, 13 Aug 2013 10:58:58 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org
Subject: Re: [ 00/17] 3.4.58-stable review
Message-ID: <20130813175858.GC7336@kroah.com>
References: <20130813063501.728847844@linuxfoundation.org>
 <520A1D56.2050507@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <520A1D56.2050507@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 13, 2013 at 04:49:42AM -0700, Guenter Roeck wrote:
> On 08/12/2013 11:35 PM, Greg Kroah-Hartman wrote:
> >This is the start of the stable review cycle for the 3.4.58 release.
> >There are 17 patches in this series, all will be posted as a response
> >to this one.  If anyone has any issues with these being applied, please
> >let me know.
> >
> >Responses should be made by Thu Aug 15 06:34:52 UTC 2013.
> >Anything received after that time might be too late.
> >
> >The whole patch series can be found in one patch at:
> >	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.4.58-rc1.gz
> >and the diffstat can be found below.
> >
> Cross build results:
> 	Total builds: 62 Total build errors: 10

As I'm sticking with 3.4 for another year, should I work to fix those
build errors?

> qemu:
> 	mips, ppc, x86, x86_64 pass (boot to login prompt)
> 
> Details:
> 	http://server.roeck-us.net:8010/waterfall

I tried to find the build errors here, but can't seem to see them.  What
should I be looking for?

thanks,

greg k-h

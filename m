Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758603Ab3HMR5f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 13:57:35 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38818 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757355Ab3HMR5e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 13:57:34 -0400
Date: Tue, 13 Aug 2013 10:57:33 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org
Subject: Re: [ 00/60] 3.10.7-stable review
Message-ID: <20130813175733.GA7336@kroah.com>
References: <20130813063331.950321483@linuxfoundation.org>
 <520A1F15.7010209@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <520A1F15.7010209@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 13, 2013 at 04:57:09AM -0700, Guenter Roeck wrote:
> On 08/12/2013 11:33 PM, Greg Kroah-Hartman wrote:
> >This is the start of the stable review cycle for the 3.10.7 release.
> >There are 60 patches in this series, all will be posted as a response
> >to this one.  If anyone has any issues with these being applied, please
> >let me know.
> >
> >Responses should be made by Thu Aug 15 06:33:14 UTC 2013.
> >Anything received after that time might be too late.
> >
> >The whole patch series can be found in one patch at:
> >	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.10.7-rc1.gz
> >and the diffstat can be found below.
> >
> Cross build results:
> 	Total builds: 69 Total build errors: 0

Nice, finally :)

> qemu:
> 	mips, ppc, x86, x86_64 pass (boot to login prompt)
> 	arm: fail (known problem, see https://lkml.org/lkml/2013/8/11/41)
> 
> Details:
> 	http://server.roeck-us.net:8010/waterfall
> 
> Builds failing on 3.10.6 (mips:allmodconfig and arm:allmodconfig) now pass,
> so results are better than with the previous release.

That's great to see, thanks for letting me know.

greg k-h

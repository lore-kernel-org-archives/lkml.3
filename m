Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757652Ab3IFR6Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 13:58:24 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:64778 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751087Ab3IFR6W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 13:58:22 -0400
Date: Fri, 6 Sep 2013 10:58:18 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org
Subject: Re: [ 00/14] 3.4.61-stable review
Message-ID: <20130906175817.GA17955@roeck-us.net>
References: <20130905202614.354156084@linuxfoundation.org>
 <20130905225628.GB1358@roeck-us.net>
 <20130906163948.GB17541@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130906163948.GB17541@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 06, 2013 at 09:39:48AM -0700, Greg Kroah-Hartman wrote:
> On Thu, Sep 05, 2013 at 03:56:28PM -0700, Guenter Roeck wrote:
> > On Thu, Sep 05, 2013 at 01:28:11PM -0700, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 3.4.61 release.
> > > There are 14 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > > 
> > > Responses should be made by Sat Sep  7 20:25:41 UTC 2013.
> > > Anything received after that time might be too late.
> > > 
> > > The whole patch series can be found in one patch at:
> > > 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.4.61-rc1.gz
> > > and the diffstat can be found below.
> > > 
> > 
> > buildbot says:
> >         total: 93 pass: 80 skipped: 8 fail: 5
> > This matches the test results for the previous release.
> 
> Hm, did we ever figure out how to fix those 5 failures?  Or have we just
> given up on them for now (which is fine by me.)
> 
I concluded that the failues are too complex for me to fix,
and/or there are too many failures.

Of course, if someone else wants to give it a try, here are the logs:

alpha-allmodconfig
	http://server.roeck-us.net:8010/builders/stable-queue-alpha-3.4/builds/20/steps/buildcommand/logs/stdio
arm-allmodcfonfig
	http://server.roeck-us.net:8010/builders/stable-queue-arm-3.4/builds/14/steps/buildcommand/logs/stdio
	[ easy to fix by itself but then there are secondary failures ]
m32r:defconfig
	http://server.roeck-us.net:8010/builders/stable-queue-m32r-3.4/builds/5/steps/buildcommand/logs/stdio
sparc64:allmodconfig
	http://server.roeck-us.net:8010/builders/stable-queue-sparc64-3.4/builds/11/steps/buildcommand/logs/stdioxtensa:defconfig
	http://server.roeck-us.net:8010/builders/stable-queue-xtensa-3.4/builds/12/steps/buildcommand/logs/stdio

Guenter

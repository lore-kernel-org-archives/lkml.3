Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758044Ab3HQAe2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 20:34:28 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:60204 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755295Ab3HQAeW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 20:34:22 -0400
Date: Fri, 16 Aug 2013 13:27:02 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>,
        Linux MIPS Mailing List <linux-mips@linux-mips.org>
Subject: Re: [ 00/17] 3.4.58-stable review
Message-ID: <20130816202702.GD4568@roeck-us.net>
References: <520A1D56.2050507@roeck-us.net>
 <20130813175858.GC7336@kroah.com>
 <20130813201936.GA18358@roeck-us.net>
 <20130815063158.GB25754@kroah.com>
 <520C86BD.2020903@roeck-us.net>
 <CAMuHMdU+EOC_etihOzUC6N0cqc2qHaGm3_L+gyTRxESCGhOzEg@mail.gmail.com>
 <520DB045.7000309@roeck-us.net>
 <20130816051041.GA23784@kroah.com>
 <520DE21D.8000905@roeck-us.net>
 <20130816124140.GD24550@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130816124140.GD24550@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 16, 2013 at 05:41:40AM -0700, Greg Kroah-Hartman wrote:
> On Fri, Aug 16, 2013 at 01:26:05AM -0700, Guenter Roeck wrote:
> > On 08/15/2013 10:10 PM, Greg Kroah-Hartman wrote:
> > [ .. ]
> > 
> > >> three to go (arm:allmodconfig, sparc32:defconfig, and sparc64:allmodconfig).
> > >
> > 
> > Please add (in this order) the following patches to 3.4.
> > 
> > de36e66d5f sparc32: add ucmpdi2
> > 74c7b28953 sparc32: Add ucmpdi2.o to obj-y instead of lib-y.
> > 
> > This fixes the sparc32:defconfig build error.
> 
> Now applied, thanks.
> 
Down to three failures now, out of 69 builds.

Still failing:
	arm:allmodconfig
	sparc64:allmodconfig
	xtensa:defconfig

None of those appear simple to fix.

In case someone wants to have a look, here is the latest log:

http://server.roeck-us.net:8010/builders/stable-queue-3.4/builds/45/steps/shell/logs/stdio
	
Guenter

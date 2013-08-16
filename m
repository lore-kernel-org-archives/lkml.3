Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753368Ab3HPBgz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 21:36:55 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44802 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753055Ab3HPBgy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 21:36:54 -0400
Date: Thu, 15 Aug 2013 18:38:29 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [ 00/17] 3.4.58-stable review
Message-ID: <20130816013829.GA30889@kroah.com>
References: <20130813175858.GC7336@kroah.com>
 <20130813201936.GA18358@roeck-us.net>
 <CAMuHMdVetwp7r=O_svmnyHBEQzdg-OdRxRB-3TJVQeQ7KULU7g@mail.gmail.com>
 <20130813223622.GA12790@roeck-us.net>
 <CAMuHMdVsR3Af+ccWMq6aU99UUAtCXyf8Ss0fbSYw7tR_w2mwkA@mail.gmail.com>
 <520B5873.6010708@roeck-us.net>
 <20130815063648.GE25754@kroah.com>
 <520CE978.5010000@roeck-us.net>
 <20130816012248.GB28289@kroah.com>
 <520D8042.6060203@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <520D8042.6060203@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 15, 2013 at 06:28:34PM -0700, Guenter Roeck wrote:
> On 08/15/2013 06:22 PM, Greg Kroah-Hartman wrote:
> >> That was "fixed" by a complete arm Kconfig overhaul. I don't think you want
> >> that in 3.4.
> >> --------------
> >
> > Not a "complete" overhaul, no.  But getting a default allmodconfig
> > building for arm would be nice, if possible.
> >
> 
> I agree. I'll look into it a bit further.

Thanks, much appreciated.

> Also, to keep you busy:
> 
> cd8d2331 alpha: makefile: don't enforce small data model for kernel builds
> 
> fixes the alpha defconfig build for 3.4.

Nice, now applied.

greg k-h

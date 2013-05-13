Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752307Ab3EMD2H (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 May 2013 23:28:07 -0400
Received: from mail.active-venture.com ([67.228.131.205]:52834 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751704Ab3EMD2F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 May 2013 23:28:05 -0400
X-Originating-IP: 108.223.40.66
Date: Sun, 12 May 2013 20:28:17 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
        Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: Build failures due to commit ea4054a2384 (handle huge number of
 modules)
Message-ID: <20130513032817.GA17184@roeck-us.net>
References: <20130508213007.GA11946@roeck-us.net>
 <8761ytnf8f.fsf@rustcorp.com.au>
 <20130509041448.GA11398@roeck-us.net>
 <87ehdb39gu.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ehdb39gu.fsf@rustcorp.com.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 13, 2013 at 11:52:09AM +0930, Rusty Russell wrote:
> Guenter Roeck <linux@roeck-us.net> writes:
> > Attached is a failing configuration for x86_64. Note that
> > drivers/staging/android/logger.c fails to build with this configuration,
> > so you have to build it with make -i to see the problem.
> >
> > Looking through my logs, it seems that the problem may be related to other
> > build errors. At least in my latest nightly builds there was always some other
> > build error when this happened.
> 
> That would explain it.  Perhaps some kind of race?
> 
> I can't see this as a real problem, though.
> 
It reduces the value of "make -i" significantly, as it creates lots of false
compile errors. If you think that is not a problem, fine with me. I can (and do)
filter the resulting errors from my auto-build scripts by now . That may cause
the scripts it to miss some real errors, but after all I can only do so much.
And it does seeem as if no one else cares, or maybe I am the only one seeing
the problem, so I guess you are right.

Thanks,
Guenter

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756062AbaJWQHK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 12:07:10 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:39421 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755482AbaJWQHI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 12:07:08 -0400
Date: Thu, 23 Oct 2014 17:07:03 +0100
From: Daniel Walter <dwalter@google.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        Pavel Machek <pavel@ucw.cz>,
        kernel list <linux-kernel@vger.kernel.org>, sre@kernel.org,
        B38611@freescale.com, aaro.koskinen@iki.fi, jg1.han@samsung.com,
        linux-input@vger.kernel.org
Subject: Re: 3.18.rc1: compile failure in tsc2005.c
Message-ID: <20141023160703.GA3230@google.com>
References: <20141023125325.GB30572@amd>
 <201410231501.04540@pali>
 <20141023154751.GB18714@dtor-ws>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20141023154751.GB18714@dtor-ws>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 23, 2014 at 08:47:51AM -0700, Dmitry Torokhov wrote:
> On Thu, Oct 23, 2014 at 03:01:04PM +0200, Pali Rohár wrote:
> > On Thursday 23 October 2014 14:53:25 Pavel Machek wrote:
> > > Hi!
> > > 
> > > I get this. Before I start patching it, perhaps someone has
> > > fixed it already?
> > > 
> > > 								Pavel
> > > 
> > >   CC      drivers/input/touchscreen/tsc2005.o
> > > drivers/input/touchscreen/tsc2005.c: In function
> > > 'tsc2005_disable_store':
> > > drivers/input/touchscreen/tsc2005.c:406:2: error: implicit
> > > declaration of function 'strict_strtoul'
> > > [-Werror=implicit-function-declaration] cc1: some warnings
> > > being treated as errors
> > > scripts/Makefile.build:257: recipe for target
> > > 'drivers/input/touchscreen/tsc2005.o' failed
> > > make[3]: *** [drivers/input/touchscreen/tsc2005.o] Error 1
> > > scripts/Makefile.build:402: recipe for target
> > > 'drivers/input/touchscreen' failed
> > > make[2]: *** [drivers/input/touchscreen] Error 2
> > > scripts/Makefile.build:402: recipe for target 'drivers/input'
> > > failed make[1]: *** [drivers/input] Error 2
> > > make[1]: *** Waiting for unfinished jobs....
> > >   CC      net/core/request_sock.o
> > 
> > Hi, I read somewhere that strict_strtoul function was replaced by 
> > some kstrtol function... So maybe somebody forgot to fix tsc2005 
> > driver?
> 
> Yeah, I see patch from Daniel removing these but forgettign tsc2005.
> 
> Pavel, if you have hardware then a patch connverting to kstro* would be
> very welcome.
> 
> Thanks.
> 
> -- 
> Dmitry

Hi Pavel,

what tree are you working with, since I do not see any reference to
strict_strto* in mainline,

thanks
--
Daniel

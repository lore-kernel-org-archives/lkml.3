Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753663Ab3JDKLO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 06:11:14 -0400
Received: from dan.rpsys.net ([93.97.175.187]:51767 "EHLO dan.rpsys.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751469Ab3JDKLM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 06:11:12 -0400
X-Greylist: delayed 870 seconds by postgrey-1.27 at vger.kernel.org; Fri, 04 Oct 2013 06:11:10 EDT
Message-ID: <1380880553.18603.575.camel@ted>
Subject: Re: [PATCH] MAINTAINERS: remove Richard Purdie as backlight
 maintainer
From: Richard Purdie <rpurdie@rpsys.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jingoo Han <jg1.han@samsung.com>, linux-kernel@vger.kernel.org,
        linux-fbdev@vger.kernel.org,
        "'Thierry Reding'" <thierry.reding@gmail.com>,
        "'Tomi Valkeinen'" <tomi.valkeinen@ti.com>,
        "'Laurent Pinchart'" <laurent.pinchart+renesas@ideasonboard.com>,
        "'Michael Hennerich'" <michael.hennerich@analog.com>,
        "'Milo Kim'" <milo.kim@ti.com>,
        "'Daniel Jeong'" <gshark.jeong@gmail.com>
Date: Fri, 04 Oct 2013 10:55:53 +0100
In-Reply-To: <20131003174315.d9aa8af7.akpm@linux-foundation.org>
References: <017f01cebb35$f6a82ac0$e3f88040$%han@samsung.com>
	 <20131003162048.d4be6510f36da5c61dc61c43@linux-foundation.org>
	 <003801cec093$6b3c1bf0$41b453d0$%han@samsung.com>
	 <20131003174315.d9aa8af7.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-10-03 at 17:43 -0700, Andrew Morton wrote:
> On Fri, 04 Oct 2013 08:50:57 +0900 Jingoo Han <jg1.han@samsung.com> wrote:
> 
> > On Friday, October 04, 2013 8:21 AM, Andrew Morton wrote:
> > > On Fri, 27 Sep 2013 12:59:28 +0900 Jingoo Han <jg1.han@samsung.com> wrote:
> > > 
> > > > Remove Richard Purdie as backlight subsystem maintainer, since he
> > > > is not responding for a few years.
> > > 
> > > It's nice to give a person a ./CREDITS entry when we remove them from
> > > ./MAINTAINERS.
> > 
> > However, Richard Purdie still remains as maintainers of other two entries
> > as below:
> > In this case, is it still necessary give him a ./CREDITS entry?
> 
> Necessary?  No.  Nice?  Yes ;) I like to think that it reduces any of
> the sting from being removed from MAINTAINERS.  Plus it is more
> accurate and costs nothing.

It is sad to be removed from there but equally, I haven't had the time
to spend on it for a while and it is justified. I am still around, I
have been reading some of the patches, there are just other things which
are more in need of my time (the Yocto Project primarily). I'd done what
I'd set out to do with the backlight/leds subsystems and its time to let
others take them forward. So a credits entry sounds nice and probably
more appropriate now, thanks :)

Cheers,

Richard


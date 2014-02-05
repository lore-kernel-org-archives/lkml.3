Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753057AbaBEXFa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 18:05:30 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38956 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751400AbaBEXF1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 18:05:27 -0500
Date: Wed, 5 Feb 2014 15:06:34 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
Cc: Felipe Balbi <balbi@ti.com>,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        Pavel Machek <pavel@ucw.cz>, Sebastian Reichel <sre@ring0.de>,
        USB list <linux-usb@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Aaro Koskinen <aaro.koskinen@iki.fi>
Subject: Re: BUG: usb: obex in g_nokia.ko causing kernel panic
Message-ID: <20140205230634.GA25598@kroah.com>
References: <201311191151.17153@pali>
 <201311271740.42913@pali>
 <20131127173904.GD8123@saruman.home>
 <201401091517.36357@pali>
 <CAHYPw2HfJwPHVXzvcNkFgfMm2TS-MQstuAF4hzcva-ycJSxevQ@mail.gmail.com>
 <52F2BA51.4060007@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <52F2BA51.4060007@gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 06, 2014 at 12:25:21AM +0200, Ivaylo Dimitrov wrote:
> Hi Felipe,
> 
> >>>
> >>>cool, I'll send this during the -rc and Cc stable, then I'll
> >>>manually backport it to stable later.
> >>
> >>PING!
> >>
> >>I still do not see this patch in linus tree. What happened?
> >>
> >>--
> >>Pali Rohár
> >>pali.rohar@gmail.com
> >
> >BUMP
> >
> >Is there any problem with above patch?
> >
> 
> If you are short on time or have some another reasons preventing you pushing
> that patch, I can send that patch for you, are you ok with that?

Felipe is on vacation, care to resend the patch and cc: me?

thanks,

greg k-h

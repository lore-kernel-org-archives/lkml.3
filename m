Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752351AbaBMRDJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 12:03:09 -0500
Received: from cpsmtpb-ews03.kpnxchange.com ([213.75.39.6]:57810 "EHLO
	cpsmtpb-ews03.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751323AbaBMRDH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 12:03:07 -0500
Message-ID: <1392310984.23598.15.camel@x220>
Subject: Re: [PATCH] Blackfin: bf537: rename "CONFIG_ADT7310" and friends
From: Paul Bolle <pebolle@tiscali.nl>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Lars-Peter Clausen <lars@metafoo.de>, Steven Miao <realmz6@gmail.com>,
        adi-buildroot-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Date: Thu, 13 Feb 2014 18:03:04 +0100
In-Reply-To: <52FCF2CD.9000008@roeck-us.net>
References: <1364211831.1390.285.camel@x61.thuisdomein>
		 <20130325152258.GA17467@roeck-us.net> <51507126.2040002@metafoo.de>
		 <1392285474.30853.28.camel@x220> <1392287466.30853.48.camel@x220>
	 <52FCF2CD.9000008@roeck-us.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.3 (3.10.3-1.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 13 Feb 2014 17:03:04.0485 (UTC) FILETIME=[75B71550:01CF28DD]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-02-13 at 08:29 -0800, Guenter Roeck wrote:
> On 02/13/2014 02:31 AM, Paul Bolle wrote:
> > On Thu, 2014-02-13 at 10:57 +0100, Paul Bolle wrote:
> >> This issue is still present in v3.14-rc2. Guenter's suggestion is the
> >> easiest way out. Should I submit a trivial patch that just removes the
> >> dead code depending on never defined CONFIG_ADT7310 and
> >> CONFIG_ADT7310_MODULE?
> >
> 
> My suggestion was to remove the ifdefs, not the code, and if I
> understand the reply correctly that won't work because in that
> case multiple devices would be registered with the SPI core
> on the same SPI interface.

Then I misinterpreted your suggestion. But removing the dead code
remains the easiest way out, of course. (Note that the code has only
been dead since v3.8, ie only a year now.)

> > And that is probably also true for for CONFIG_ADT7410 and
> > CONFIG_ADT7410_MODULE. See https://lkml.org/lkml/2013/5/13/497 (and my
> > follow up to that message).
> 
> Both Jean and myself sent Reviewed-by/Acked-by feedback.
> Not being the maintainers, that is pretty much all we can do.
>  From there it is really up to the maintainer to accept
> or reject the patches.

Jean and you are included in (some of) the threads regarding a few
blackfin patches I sent last year. I forgot why you two are. Anyhow,
those patches were (mostly) ignored by the people working on blackfin.
The maintainer appears to be more responsive now. So I figured it might
be worthwhile to send reminders. Maybe I have more luck this time.


Paul Bolle


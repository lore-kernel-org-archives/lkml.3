Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758285Ab3E1Kw4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 06:52:56 -0400
Received: from service87.mimecast.com ([91.220.42.44]:58359 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756363Ab3E1Kwz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 06:52:55 -0400
Message-ID: <1369738372.3148.7.camel@hornet>
Subject: Re: [RFC PATCHv4 0/6] arm: Initial TI-Nspire support
From: Pawel Moll <pawel.moll@arm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Daniel Tang <dt.tangr@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux@arm.linux.org.uk ARM Linux" <linux@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        "fabian@ritter-vogt.de Vogt" <fabian@ritter-vogt.de>,
        Lionel Debroux <lionel_debroux@yahoo.fr>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Date: Tue, 28 May 2013 11:52:52 +0100
In-Reply-To: <201305271231.40693.arnd@arndb.de>
References: <1369480087-24786-1-git-send-email-dt.tangr@gmail.com>
	 <201305262323.29519.arnd@arndb.de>
	 <30BA4666-664F-4DA4-A1D5-C2B8AA63C6AB@gmail.com>
	 <201305271231.40693.arnd@arndb.de>
X-Mailer: Evolution 3.6.4-0ubuntu1
Mime-Version: 1.0
X-OriginalArrivalTime: 28 May 2013 10:52:52.0967 (UTC) FILETIME=[80CDA770:01CE5B91]
X-MC-Unique: 113052811525300801
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-05-27 at 11:31 +0100, Arnd Bergmann wrote:
> On Monday 27 May 2013, Daniel Tang wrote:
> > > The one remaining bit that sticks out is the clcd platform data. As I
> > > said before, I won't require you to convert that to DT in order to
> > > get your code merged, but I'd also really like to see that happen,
> > > as we will also need that to get rid of auxdata on the ARM reference
> > > platforms (integrator, versatile, realview, vexpress).
> > 
> > How would you like me to convert the platform data to DT? AFAIK, the clcd
> > driver isn't aware of DT so the only way is to use the AUXDATA right now.
> 
> Linus Walleij mentioned on IRC that Pawel Moll already posted a series
> that adds DT support for clcd:
> 
> http://lists.freedesktop.org/archives/dri-devel/2013-April/037519.html
> 
> The series does a few more things, but you can probbly split out the
> parts you need and base on that.

The main "issue" with the series is its dependency on Laurent Pinchart's
Common Display Framework (or rather on the progress of its upstreaming).
I'm planning to discuss this in details in during the Linaro Connect in
Dublin, but generally, if it's not getting merged in the next window,
I'll spin the series to use the standard video modes bindings instead of
CDF. This will make me hurt on Versatile Express, but should work for
others.

Paweł



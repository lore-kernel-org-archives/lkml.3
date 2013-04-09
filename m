Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936633Ab3DIMCE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 08:02:04 -0400
Received: from service87.mimecast.com ([91.220.42.44]:60472 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935615Ab3DIMCB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 08:02:01 -0400
Message-ID: <1365508916.24306.17.camel@hornet>
Subject: Re: [RFC PATCH arm: initial TI-Nspire support]
From: Pawel Moll <pawel.moll@arm.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Daniel Tang <dt.tangr@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "fabian@ritter-vogt.de" <fabian@ritter-vogt.de>,
        Lionel Debroux <lionel_debroux@yahoo.fr>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 09 Apr 2013 13:01:56 +0100
In-Reply-To: <CACRpkda9Nue-8Esp3cJ6u2-MJ2ZL8hH-2BnrhHwWv4GZP2VR5w@mail.gmail.com>
References: <6FE4B33E-A503-4A75-AEED-831CB2C06D83@gmail.com>
	 <4B3FD561-84FC-40CD-B747-13851692D673@gmail.com>
	 <521DFDFC-7E9E-47EA-ACDA-C91BBDC8454E@gmail.com>
	 <201304072323.42173.arnd@arndb.de>
	 <CACRpkda9Nue-8Esp3cJ6u2-MJ2ZL8hH-2BnrhHwWv4GZP2VR5w@mail.gmail.com>
X-Mailer: Evolution 3.6.2-0ubuntu0.1
Mime-Version: 1.0
X-OriginalArrivalTime: 09 Apr 2013 12:01:57.0274 (UTC) FILETIME=[08C2F7A0:01CE351A]
X-MC-Unique: 113040913015805801
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-04-09 at 12:23 +0100, Linus Walleij wrote:
> On Sun, Apr 7, 2013 at 11:23 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> > On Sunday 07 April 2013, Daniel Tang wrote:
> >> Here's an updated patch that enables support for the LCD.
> >>
> >> I looked into drivers/video/of_display_timing.c but it doesn't have the fields to describe the
> >> PL11x specific options needed in struct clcd_panel. At the moment, it is implemented by
> >> hardcoding the values in the kernel and using the device tree to select the correct
> >> configuration.
> >>
> >> Signed-off-by: Daniel Tang <dt.tangr@gmail.com>
> >
> > I think you should for now keep the clcd stuff in a separate file,
> > since it will be replaced with DT logic eventually. For now, the
> > auxdata method is ok, but Linus Walleij might already have thought
> > about how pl111 should get all its data from the device tree.
> 
> So last thing I heard there was *someone* at ARM working on
> device tree support for the PL110/PL111, so I just don't know who
> this was.
> 
> But I bet Pawel knows, because it will be needed for all
> ARM reference designs.

So I have PL111 code almost working here, however today it depends on
not-yet-upstream (to my knowledge) generic/common panel/display
framework. If I'm not disturbed again I may get something done this
week, hopefully removing the dependency.

There's also some work going on on a DRM driver for PL111, but I can't
promise any dates.

As to PL110 I have no idea how different is it from the PL111, but
nothing is happening about it anyway.

Paweł



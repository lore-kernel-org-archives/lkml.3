Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760370Ab3B0RQ7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 12:16:59 -0500
Received: from relais.videotron.ca ([24.201.245.36]:48018 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752760Ab3B0RQ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 12:16:57 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; CHARSET=US-ASCII
Date: Wed, 27 Feb 2013 12:16:55 -0500 (EST)
From: Nicolas Pitre <nico@fluxnic.net>
To: Joe Perches <joe@perches.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Peter Korsgaard <jacmet@sunsite.dk>,
        "Markus F.X.J. Oberhumer" <markus@oberhumer.com>,
        Kyungsik Lee <kyungsik.lee@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Michal Marek <mmarek@suse.cz>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org, x86@kernel.org,
        celinux-dev@lists.celinuxforum.org,
        Nitin Gupta <nitingupta910@gmail.com>,
        Richard Purdie <rpurdie@openedhand.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Joe Millenbach <jmillenbach@gmail.com>, David Sterba <dsterba@suse.cz>,
        Richard Cochran <richardcochran@gmail.com>,
        Albin Tonnerre <albin.tonnerre@free-electrons.com>,
        Egon Alter <egon.alter@gmx.net>, hyojun.im@lge.com, chan.jeong@lge.com,
        raphael.andy.lee@gmail.com
Subject: Re: [RFC PATCH v2 0/4] Add support for LZ4-compressed kernel
In-reply-to: <1361984688.2035.20.camel@joe-AO722>
Message-id: <alpine.LFD.2.03.1302271211360.1254@syhkavp.arg>
References: <1361859870-15751-1-git-send-email-kyungsik.lee@lge.com>
 <512D1C12.4080109@oberhumer.com>
 <alpine.LFD.2.03.1302261557220.1254@syhkavp.arg>
 <87fw0i7n6d.fsf@dell.be.48ers.dk>
 <20130226221027.GW17833@n2100.arm.linux.org.uk>
 <1361929234.1924.8.camel@joe-AO722>
 <20130227095609.GY17833@n2100.arm.linux.org.uk>
 <1361980152.2035.13.camel@joe-AO722>
 <20130227163118.GB17833@n2100.arm.linux.org.uk>
 <1361984688.2035.20.camel@joe-AO722>
User-Agent: Alpine 2.03 (LFD 1266 2009-07-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Feb 2013, Joe Perches wrote:

> On Wed, 2013-02-27 at 16:31 +0000, Russell King - ARM Linux wrote:
> > On Wed, Feb 27, 2013 at 07:49:12AM -0800, Joe Perches wrote:
> > > On Wed, 2013-02-27 at 09:56 +0000, Russell King - ARM Linux wrote:
> > > > On Tue, Feb 26, 2013 at 05:40:34PM -0800, Joe Perches wrote:
> > > > > On Tue, 2013-02-26 at 22:10 +0000, Russell King - ARM Linux wrote:
> > > > > > So... for a selected kernel version of a particular size, can we please
> > > > > > have a comparison between the new LZO code and this LZ4 code, so that
> > > > > > we can see whether it's worth updating the LZO code or replacing the
> > > > > > LZO code with LZ4?
> > > > > 
> > > > > How could it be questionable that it's worth updating the LZO code?
> > > > 
> > > > Please read the comments against the previous posting of these patches
> > > > where I first stated this argument - and with agreement from those
> > > > following the thread.  The thread started on 26 Jan 2013.  Thanks.
> > > 
> > > https://lkml.org/lkml/2013/1/29/145
> > > 
> > > I did not and do not see significant value in
> > > adding LZ4 given Markus' LZO improvements.
> > 
> > Sorry, a 66% increase in decompression speed over the updated LZO code
> > isn't "significant value" ?
> 
> We disagree.
> 
> > I'm curious - what in your mind qualifies "significant value" ?
> 
> faster boot time. smaller, faster overall code.

Sorry, but you certainly successfully got me confused, and probably 
others as well.

RMK says that "66% increase in decompression speed over LZO" is 
significant.  You apparently disagree with that.

Then you say that faster boot time is significant.

Again, can you (or anyone else) provide comprehensive test results in a 
single email with both compression methods?


Nicolas

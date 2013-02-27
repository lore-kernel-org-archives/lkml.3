Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760554Ab3B0RwZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 12:52:25 -0500
Received: from relais.videotron.ca ([24.201.245.36]:44427 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760035Ab3B0RwW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 12:52:22 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; CHARSET=US-ASCII
Date: Wed, 27 Feb 2013 12:52:19 -0500 (EST)
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
In-reply-to: <1361986787.20540.8.camel@joe-AO722>
Message-id: <alpine.LFD.2.03.1302271246440.1254@syhkavp.arg>
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
 <alpine.LFD.2.03.1302271211360.1254@syhkavp.arg>
 <1361986787.20540.8.camel@joe-AO722>
User-Agent: Alpine 2.03 (LFD 1266 2009-07-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Feb 2013, Joe Perches wrote:

> On Wed, 2013-02-27 at 12:16 -0500, Nicolas Pitre wrote:
> > RMK says that "66% increase in decompression speed over LZO" is 
> > significant.  You apparently disagree with that.
> 
> Yeah, I can see how that can be interpreted.
> I'm referring only to the new LZO.
> 
> I guess Russell has not reviewed the new LZO.
> 
> There is apparently no speed increase for LZ4 over
> the new LZO.
> 
> I believe Markus has shown comparison testing in
> this very thread.
> 
> https://patchwork.kernel.org/patch/2187441/

Right.

Can the new LZO code be merged by Linus now?  It has been sitting in 
linux-next for quite some time.  Afterwards we could revisit lz4 
worthiness without all the present confusion.

BTW, I still wonder what that patch requiring ARM people approval is.


Nicolas

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753346Ab3B1EW7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 23:22:59 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:56263 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750916Ab3B1EW4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 23:22:56 -0500
Message-ID: <1362025374.1928.13.camel@joe-AO722>
Subject: Re: [RFC PATCH v2 0/4] Add support for LZ4-compressed kernel
From: Joe Perches <joe@perches.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Peter Korsgaard <jacmet@sunsite.dk>, Nicolas Pitre <nico@fluxnic.net>,
        "Markus F.X.J. Oberhumer" <markus@oberhumer.com>,
        Kyungsik Lee <kyungsik.lee@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Michal Marek <mmarek@suse.cz>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org, x86@kernel.org,
        celinux-dev@lists.celinuxforum.org,
        Nitin Gupta <nitingupta910@gmail.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Joe Millenbach <jmillenbach@gmail.com>, David Sterba <dsterba@suse.cz>,
        Richard Cochran <richardcochran@gmail.com>,
        Egon Alter <egon.alter@gmx.net>, hyojun.im@lge.com, chan.jeong@lge.com,
        raphael.andy.lee@gmail.com
Date: Wed, 27 Feb 2013 20:22:54 -0800
In-Reply-To: <20130227173644.GC17833@n2100.arm.linux.org.uk>
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
	 <20130227173644.GC17833@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(removed Richard Purdie and Albin Tonnerre as their email addresses
 seem to be bounding)

> While recently asking someone to enable VFP debugging, so I could help
> sort out a problem they had reported, this is the debug output I was
> greeted by thanks to your meddling:

:) Meddling... You sound like one of those nameless
villains on Scooby Doo.  If only I had a cool nickname
like Dave "Shaggy" Kliekamp.  I guess you'd have to call
me Velma.

> [  927.235546] \x01\x01\x01\x01\x01\x01\x01\x01
> ...
> [  927.241505] \x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01                     
> 
> 7.6 `.asciz "STRING"'...
> ========================
> 
> `.asciz' is just like `.ascii', but each string is followed by a zero
>                                     ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> byte.  The "z" in `.asciz' stands for "zero".
> ^^^^^

Yeah, sorry.  I thought that the zero was after any
concatenation like .c.  Learned something.  'preciate
that.  Would have appreciated a polite "you broke it"
email too.

> ??? Yea, right, meanwhile breaking the ability of stuff to produce
> kernel messages.

Fortunately, that's the only .S instance.

> > > > > > > so that we can see whether it's worth updating the LZO code
> > Sounded as if you were doubtful to me.
> _In_ the decompressor.  We're talking about the _decompressor_ in
> this thread.

My opinion is it's useful to update LZO.

cheers, Joe (aka: Velma)


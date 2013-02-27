Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759453Ab3B0QJB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 11:09:01 -0500
Received: from relais.videotron.ca ([24.201.245.36]:64256 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752265Ab3B0QI7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 11:08:59 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; CHARSET=US-ASCII
Date: Wed, 27 Feb 2013 11:08:53 -0500 (EST)
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
In-reply-to: <1361980152.2035.13.camel@joe-AO722>
Message-id: <alpine.LFD.2.03.1302271055430.1254@syhkavp.arg>
References: <1361859870-15751-1-git-send-email-kyungsik.lee@lge.com>
 <512D1C12.4080109@oberhumer.com>
 <alpine.LFD.2.03.1302261557220.1254@syhkavp.arg>
 <87fw0i7n6d.fsf@dell.be.48ers.dk>
 <20130226221027.GW17833@n2100.arm.linux.org.uk>
 <1361929234.1924.8.camel@joe-AO722>
 <20130227095609.GY17833@n2100.arm.linux.org.uk>
 <1361980152.2035.13.camel@joe-AO722>
User-Agent: Alpine 2.03 (LFD 1266 2009-07-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Feb 2013, Joe Perches wrote:

> https://lkml.org/lkml/2013/1/29/145

Connecting to lkml.org (lkml.org)|87.253.128.182|:443... connected.
HTTP request sent, awaiting response... 500 Server Error

> I did not and do not see significant value in
> adding LZ4 given Markus' LZO improvements.

Please someone post a comprehensive comparison with all the results in 
the same email.

> The new LZO code is faster than ever and it's
> a standalone improvement.
> 
> Why would the LZO code not be updated?

It is used by filesystems, etc.  So of course it needs to be updated to 
faster code.

> Markus has posted what seems a clean git pull
> request.  It was not cc'd to arm or linux-arch.
> 
> http://linux-kernel.2935.n7.nabble.com/GIT-PULL-Update-LZO-compression-code-for-v3-9-td605184.html

Maybe a reminder should be sent to Linus about this.

>From the above we can see this:

   **LZO-2013-UA : updated LZO version available in linux-next plus 
   experimental ARM Unaligned Access patch. This needs approval from 
   some ARM maintainer ist NOT YET INCLUDED.

What is that experimental patch in need of approval?


Nicolas

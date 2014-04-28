Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755977AbaD1NFW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 09:05:22 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:50067 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755446AbaD1NFT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 09:05:19 -0400
Date: Mon, 28 Apr 2014 09:04:24 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Andrew Lutomirski <amluto@gmail.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Alexander van Heukelum <heukelum@fastmail.fm>,
        Borislav Petkov <bp@alien8.de>,
        Arjan van de Ven <arjan.van.de.ven@intel.com>,
        Brian Gerst <brgerst@gmail.com>,
        Alexandre Julliard <julliard@winehq.com>,
        Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86-64: espfix for 64-bit mode *PROTOTYPE*
Message-ID: <20140428130424.GB2860@phenom.dumpdata.com>
References: <tip-kicdm89kzw9lldryb1br9od0@git.kernel.org>
 <1398120472-6190-1-git-send-email-hpa@linux.intel.com>
 <535714A1.9080502@linux.intel.com>
 <CAObL_7HsnpGKRoBh+NZkW7SURqGx_4Dkfow=1-_7UU9uBV4UkA@mail.gmail.com>
 <53571A7D.8050702@zytor.com>
 <5357CD0B.5050003@oracle.com>
 <5357F0A0.6040909@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5357F0A0.6040909@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 23, 2014 at 09:56:00AM -0700, H. Peter Anvin wrote:
> On 04/23/2014 07:24 AM, Boris Ostrovsky wrote:
> >>
> >> Konrad - I really could use some help figuring out what needs to be done
> >> for this not to break Xen.
> > 
> > This does break Xen PV:
> > 
> 
> I know it does.  This is why I asked for help.

This week is chaotic for me but I taking a stab at it. Should have
something by the end of the week on top of your patch.

> 
> This is fundamentally the problem with PV and *especially* the way Xen
> PV was integrated into Linux: it acts as a development brake for native
> hardware.  Fortunately, Konrad has been quite responsive to that kind of
> problems, which hasn't always been true of the Xen community in the past.

Thank you for such kind words!

I hope that in Chicago you will be have a chance to meet other folks that
are involved in Xen and formulate a similar opinion of them.

Cheers!

> 
> 	-hpa
> 

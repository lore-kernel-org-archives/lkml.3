Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752344AbaIBG6P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 02:58:15 -0400
Received: from STOEXHUB01.domain01.net ([83.145.59.142]:28884 "EHLO
	STOEXHUB01.domain01.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750927AbaIBG6O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 02:58:14 -0400
Date: Tue, 2 Sep 2014 08:57:53 +0200
From: Anders Darander <anders@chargestorm.se>
To: Matt Fleming <matt@console-pimps.org>
CC: Yinghai Lu <yinghai@kernel.org>, Matt Fleming <matt.fleming@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Mantas =?utf-8?Q?Mikul=C4=97nas?= <grawity@gmail.com>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Harald Hoyer <harald@redhat.com>
Subject: Re: [PATCH] x86: only load initrd above 4g on second try
Message-ID: <20140902065752.GA5634@ad.chargestorm.se>
References: <1409089544-24221-1-git-send-email-yinghai@kernel.org>
 <20140827105901.GC28116@console-pimps.org>
 <CAE9FiQWrPtEe3tkJjgOzyJJPPzX=AtMYgR4c91pDHL3q3ZLLKQ@mail.gmail.com>
 <20140830112426.GA2911@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20140830112426.GA2911@console-pimps.org>
X-Accept-Language: sv, en, de
X-GPG-Fingerprint: 5AF0 B2E9 78FE 9D75 D110  6F8F 3E31 84D7 920E 938C
X-GPG-Key-Id: 0x920E938C
X-GPG-Keyserver: hkp://keys.gnupg.net
Organization: ChargeStorm AB
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Matt Fleming <matt@console-pimps.org> [140830 13:24]:
> On Wed, 27 Aug, at 10:13:22AM, Yinghai Lu wrote:
> > How about adding more info print out like:
> >   "Try to load initrd file to higher address..."

> Yeah, that could work, at least we've had some debugging information to
> go on if people start reporting hangs, though I'd suggest using "Trying"
> or "Attempting".

That should be fine. That would at least give the user something easy to
search for (both web and source), and thus make it possible to at least
get an idea of why the boot is hanging for the few people that's going
to hit this.

For most systems, the default to load the initrd/initramfs below 4G (and
only load it above on the second attempt) will handle our buggy EFI's...

To me this sounds like something that should work.

Cheers,
Anders

-- 
Option Paralysis:
	The tendency, when given unlimited choices, to make none.
		-- Douglas Coupland, "Generation X: Tales for an Accelerated
		   Culture"

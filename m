Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752537AbaEOJIp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 05:08:45 -0400
Received: from casper.infradead.org ([85.118.1.10]:56959 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750916AbaEOJIn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 05:08:43 -0400
Date: Thu, 15 May 2014 11:08:39 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Richard Weinberger <richard@nod.at>
Cc: linux-arch@vger.kernel.org, arnd@arndb.de, linux-kernel@vger.kernel.org
Subject: Re: Consolidate tlb.h
Message-ID: <20140515090839.GJ30445@twins.programming.kicks-ass.net>
References: <1400093999-18703-1-git-send-email-richard@nod.at>
 <20140515083258.GD30445@twins.programming.kicks-ass.net>
 <53747F65.4090203@nod.at>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Sao9idefCFjK9Dt3"
Content-Disposition: inline
In-Reply-To: <53747F65.4090203@nod.at>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Sao9idefCFjK9Dt3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, May 15, 2014 at 10:48:37AM +0200, Richard Weinberger wrote:

> If it helps I can pickup your series and finalize it.
> Actually I was abound to consolidate TLB gather implementations too.

If you have the cycles, please do. I'll try and help where I can.

--Sao9idefCFjK9Dt3
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTdIQXAAoJEHZH4aRLwOS6o10P/2tfN37Q2qlB7IF9gaPaJb4w
Np8aJiFPvcZ/mQu5SiPhHq/Qkx9HH+jlRP05kGaxCNqRtjIWVaYBdufkMB54s8jb
9LdMyuynjYkKFk0is+D0upAtRaEbbhJ4EVPmozvP+3kOORxI1SBgJ9bJwtzTEoxN
KSbxOxsIG4gpdEVW17kPtHAL9rAss2ca1jghhA6FHLQkBKq9+aTHa2RX3ZdQ88Ld
VRoobPbWzhkNEJuZeXnamw+GvGMpz3LXjXqukDzIONoqdip1ALwt6iGTW3QZEm6F
YEzZfkmZE4VXPzJmIxjMyBbclpWGvEIi8vKVFDTRja7d2som3/RI8GyZVuI+mLJ3
hlc3/7SICSIGye3JwD6Ff8A9twefuEWWBZ6IveXRSdFKXpib1O2lPwwEDGpTEpPe
Vsu5C0JgM6+CrA5QExGQ4Dlh+USftSsYnppDW3IFtJUzVJr3P9J0VAjtIFr2vLVE
X04I15DoWnx4ItTzV/8uPGiG93+43ysU959Mrn2F6mqOCD9Ftp3ykn4au4aZDXMj
nEyQ0rVKQyEQ6yoUcwAzqT1KTvw3Cp7CWgnF+4uwSPZY8HQSndEDxGmpWFdD/9K7
xsjZkTeo0pNJi/92LWZ6nfbVTllPpTeYvdAhTTY/7y8UtmmAWzHGQMGGdyLyHjGR
K//GHWMp3aQDvs17Jf9X
=gJQ9
-----END PGP SIGNATURE-----

--Sao9idefCFjK9Dt3--

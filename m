Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752564AbaEVHB0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 03:01:26 -0400
Received: from casper.infradead.org ([85.118.1.10]:43761 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752216AbaEVHBZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 03:01:25 -0400
Date: Thu, 22 May 2014 09:01:19 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Michael Ellerman <mpe@ellerman.id.au>
Cc: Anshuman Khandual <khandual@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: Fwd: [V6 00/11] perf: New conditional branch filter
Message-ID: <20140522070119.GM30445@twins.programming.kicks-ass.net>
References: <1399280953-31442-1-git-send-email-khandual@linux.vnet.ibm.com>
 <537C6DDE.9000204@linux.vnet.ibm.com>
 <20140521092313.GF30445@twins.programming.kicks-ass.net>
 <537C827B.9090505@linux.vnet.ibm.com>
 <20140521120146.GD2485@laptop.programming.kicks-ass.net>
 <1400733004.14864.9.camel@concordia>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wyYQCv9VYpiQX0rh"
Content-Disposition: inline
In-Reply-To: <1400733004.14864.9.camel@concordia>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wyYQCv9VYpiQX0rh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 22, 2014 at 02:30:04PM +1000, Michael Ellerman wrote:
> Can you take just the first 4 in your tree please. I asked Anshuman to ju=
st
> send those 4 but he & I seem to have miscommunicated on that.
>=20
> We only depend on patch 1 in order for the powerpc parts to build, so I t=
hink
> we'll just merge that into the powerpc tree and it should merge fine when=
 it
> hits next.
>=20

OK, will do. Thanks!

--wyYQCv9VYpiQX0rh
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTfaC/AAoJEHZH4aRLwOS6qBEP/Rb7hXOuh1Negul6/r/6j7zW
3GJsLCv5V+5dH+6Kwu8mnc91Zoli1R4y05Okxyq1mkz0iuTXJsVmuUvG90SRqTt+
EknsR+Vl02gIQTiQPOwgpFFmqI4f5Tbca5tNlWDQPjyQ5AIC9RCmE8/M7rWZPoNR
m8OXlTarIfEj9LbndbUdfiqtocZU7akDdKIVrlla7D1CBj4I5dwUeBMLicppJTqT
ONouCNGFIU+a/nvDSTcYpbaMPPicHXYZrfu/zbD4Q/At14oePUjj3qS67W5hWUwB
RI0LzTL1qf/GgRBAP1q3mdRIb0iJ/3Xqib+vrGCQv3zXKdB/KqY+0v2eEtb/sXzs
355HfeK0w7mDkzkfog7HltpzJ7brb3jY/vqSZ7FEXK65kirh8o2ESrpbZPMbjsIt
NhdMZPRmlLjxIFX5e18HcbX9LNbYFqcN4HiE9GyCzJg+UuGgIH4+FJ6C9NJxLBL3
CPmg+JdjfuQEdNGX9fCm9vyjrVD0xVSd0otgULN32wJGHrqKXcKOmaMvtb77qtuH
Ugkrf2Bbaob+ms2ObNN3oihW//xdIM15zFyPfeDuLO+UGZIy1iT6FYwdu8M1xSPF
nvink/50t6bHsjYmvF2Gtdva+txmLZ7y2qEKnK9QBR/mKVFsvG+PsdVqFdKDWhMv
M3RhV2bqvZ0GH4LJvqlN
=001L
-----END PGP SIGNATURE-----

--wyYQCv9VYpiQX0rh--

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751534AbaEOIdL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 04:33:11 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:54178 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750AbaEOIdJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 04:33:09 -0400
Date: Thu, 15 May 2014 10:32:58 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Richard Weinberger <richard@nod.at>
Cc: linux-arch@vger.kernel.org, arnd@arndb.de, linux-kernel@vger.kernel.org
Subject: Re: Consolidate tlb.h
Message-ID: <20140515083258.GD30445@twins.programming.kicks-ass.net>
References: <1400093999-18703-1-git-send-email-richard@nod.at>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="y9n12KajPNdV/7DP"
Content-Disposition: inline
In-Reply-To: <1400093999-18703-1-git-send-email-richard@nod.at>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--y9n12KajPNdV/7DP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 14, 2014 at 08:59:32PM +0200, Richard Weinberger wrote:
> While staring at an UML TLB bug I've noticed that most archs
> copy and pasted stuff from each others tlb.h.
> This patch series combines common stuff into the generic tlb.h.
>=20

Were you aware of this series:

  http://www.spinics.net/lists/linux-mm/msg37369.html

I've been meaning to refresh and continue with it, but somehow I never
get time to actually do it :/

At the time only s390 still have a relatively trivial problem but all
archs were using generic code.

--y9n12KajPNdV/7DP
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTdHu6AAoJEHZH4aRLwOS66GoP/ixqHc6y/0XqrvVNlTcitRRK
VTvtygj8V3xdjso0/z6FeE5Zbg/Ri1FsgL+mIa+5c83vsxFe5oWMlZAGIrEj1Zxq
N9s9Jdy5qR2vwqwTmWGJiEpIW2lGhIvGTyvW+OE9j5UAcvipIMy/ArmPHM3yR6CS
Oa7R8ICRyUvz78dBOgqHiEy0K0+EDuedmhs2kWAo+6efhrqhp0ZVflE3DhH8W2nt
VFqDs60w5LmWoRXkNj0/sYQcv0SP5DeAR3h5WrLUknM45/Pa4TernIvUFoqfTH5U
8FGCl2qlSHGxWie/EdT6puCukE+F1koBd+PBu4qY3YEkpjOjkC+e/hVzBJrZ7R2S
LLg1HXHTetUQ2ei3Y/be2RGEK2lgcH3e7/dVQncWFt+36BVg7IR4u2Q113tFq47/
mqdOcqgcouOOkp+WSJbqe+oifLYTQHXd5YYvbpAIYWQ2xAIjj9Fg8Se6iET7cNAP
vDCm5EudD+0gmhjIg6HHw4NjKZ3C+djHYTmyTudJwHcqjW/3/nRWLoBbUk9fwiZv
bqD5Mf7k0vmGUketMI2yE9MvnYn+k9edjlyn9l29Kmf1GpZPeuy4WgLlacxqDMIj
2NYorI07R90MFoa/F64exYk7U3twDQrsxTw8uul7SuJx7PrzFQVKZzuv18FGd11+
mIElMXQ6ryEqrScnka/m
=KC9j
-----END PGP SIGNATURE-----

--y9n12KajPNdV/7DP--

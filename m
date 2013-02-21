Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754965Ab3BUXOP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 18:14:15 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:33708 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753789Ab3BUXOL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 18:14:11 -0500
Date: Fri, 22 Feb 2013 10:13:59 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Cc: James Hogan <james.hogan@imgtec.com>, Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>, <arm@kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@arm.linux.org.uk>, <linux-next@vger.kernel.org>
Subject: Re: [PATCH 01/11] ARM: disable virt_to_bus/virt_to_bus almost
 everywhere
Message-Id: <20130222101359.0c91a7259f648a3d06221bd8@canb.auug.org.au>
In-Reply-To: <5125CED4.7030905@synopsys.com>
References: <1360849767-1463135-1-git-send-email-arnd@arndb.de>
	<1360849767-1463135-2-git-send-email-arnd@arndb.de>
	<CAAG0J9_VqCGJJJZjSWGfFggALHU=vdWsSBeS39-DtxV=VXcJwQ@mail.gmail.com>
	<201302201600.47522.arnd@arndb.de>
	<5124FA93.5090504@imgtec.com>
	<5125CED4.7030905@synopsys.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__22_Feb_2013_10_13_59_+1100_myA6AUwIDcG6w0z8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__22_Feb_2013_10_13_59_+1100_myA6AUwIDcG6w0z8
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, 21 Feb 2013 13:07:56 +0530 Vineet Gupta <Vineet.Gupta1@synopsys.com=
> wrote:
>
> >> I guess you'll have to do something similar for arch/metag, and Vineet
> >> will do it for arch/arc.
>=20
> After getting the tip-bot msg about Stephen's patch for -mm, I never saw =
it in
> -next and thus was not sure how when it will start showing up in -next.

It arrived in next-21030220.

> >> Stephen's patch is currently in Andrew's tree, and I don't see an easy
> >> way to coordinate this. The patch we will need once both are merged
> >> is below.
> >>
> >> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> >=20
> > FWIW:
> > Acked-by: James Hogan <james.hogan@imgtec.com> (for arch/metag)
> >=20
> Acked-by: Vineet Gupta <vgupta@synopsys.com> (for arch/arc)
>=20
> So this means Stephen's patch - once merged will take care of existing in=
-tree
> arches and your's will take care of metag/arc.

The easiest way would be to put the follow up patches in Andrew's patch
set (since it is still based on top of linux-next).  It usually is merged
pretty late, so I would get your own trees merged ASAP and this can be
taken care of when Andrew sends his patch set to Linus.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__22_Feb_2013_10_13_59_+1100_myA6AUwIDcG6w0z8
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRJqo3AAoJEECxmPOUX5FEQtMP+gPUyDRq30uA/glrvzfXZrsU
xo8eSstV6SH4ZC6rhqGWhMjIh66a+w0oKMd2mMON/Qb8GCTSAqVwsID5uHcL4t8M
jl3zh7qvMfUgIlQ+ykn73XVvlG0BGxa8uoVmdPnVfXVklgfgAmvUxKiiKAtdUnQg
I0Z8bDC8SxujGx3HF4AboEIT28vANEIFBspaBbBjv+j6YBMrYWTLFHjZ8NohS12C
sIj6SZAvmrId9M19NlzQX/++gp5dsIn8bnVw88bDcnEQ4GNkTvShWTQui9RPpnMc
ZURDjm7HIv+jC/nkK9fgq8NqeKyRElAouMiMgjokv+FHsujZd8I+3+RI3VOUaRQv
K8/rmYeUxQV9HmCwph3vdHmQ4ahnBRA9b2a+M1uMjAXfQqWCxWVQNrkgWrXtRCg/
J2X7tce1Y//BgFHPFfvP8xbO0C6SgxyJ0/Nfm7duAKjkF1j5J4GbY5kd1KQIhDeY
Arwz5pivIV1nyUVO3cgnLX6E0cb81PfVh8aacPmARvR3fa252x/d6JdDJUTWJ4K8
CHtX4bs9e08p6cRjd2fGwTOHBV3GKBieeOYAE09gg3LxfSlQktURpT8GHP9Fjx4Q
5+9EmwyR8fLV2fWJfcYGZ77O74K8OCM9yXDmrhGWMx+uiWk3oR4amoPhzFuSKS4P
pROLvLrPvALOzp4aKQR0
=VUlF
-----END PGP SIGNATURE-----

--Signature=_Fri__22_Feb_2013_10_13_59_+1100_myA6AUwIDcG6w0z8--

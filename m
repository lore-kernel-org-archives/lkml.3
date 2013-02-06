Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756945Ab3BFIqU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 03:46:20 -0500
Received: from mail.gw90.de ([188.40.100.199]:55192 "EHLO mail.gw90.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752296Ab3BFIqS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 03:46:18 -0500
Message-ID: <1360140363.4790.7.camel@mattotaupa>
Subject: Re: [PATCH 1/2] sp5100_tco: Fix wrong indirect I/O access for
 getting value of reserved bits
From: Paul Menzel <paulepanter@users.sourceforge.net>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: Takahisa Tanaka <mc74hc00@gmail.com>, linux-watchdog@vger.kernel.org,
        Arkadiusz Miskiewicz <arekm@maven.pl>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jonathan Nieder <jrnieder@gmail.com>, linux-kernel@vger.kernel.org,
        Florian Mickler <florian@mickler.org>
Date: Wed, 06 Feb 2013 09:46:03 +0100
In-Reply-To: <20130130191945.GA20100@spo001.leaseweb.com>
References: <1358128918-4415-1-git-send-email-mc74hc00@gmail.com>
	 <20130130191945.GA20100@spo001.leaseweb.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-Y+cQJDlz2d/SXiZefQjt"
X-Mailer: Evolution 3.4.4-1.1~pre4 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Y+cQJDlz2d/SXiZefQjt
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Dear Wim,


Am Mittwoch, den 30.01.2013, 20:19 +0100 schrieb Wim Van Sebroeck:

> > In case of SB800 or later chipset and re-programming MMIO address(*),
> > sp5100_tco module may read incorrect value of reserved bit, because the=
 module
> > reads a value from an incorrect I/O address. However, this bug doesn't =
cause
> > a problem, because when re-programming MMIO address, by chance the modu=
le
> > writes zero (this is BIOS's default value) to the low three bits of reg=
ister.
> > * In most cases, PC with SB8x0 or later chipset doesn't need to re-prog=
ramming
> >   MMIO address, because such PC can enable AcpiMmio and can use 0xfed80=
b00 for
> >   watchdog register base address.
> >=20
> > This patch fixes this bug.
> >=20
> > Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=3D43176
> > Signed-off-by: Takahisa Tanaka <mc74hc00@gmail.com>
>=20
> Added to linux-watchdog-next.

Is it allowed to rewrite history of linux-watchdog-next? If yes, could
you please add `CC: stable@vger.kernel.org` to both of Takahisa=E2=80=99s
patches and also add my

    Tested-by: Paul Menzel <paulepanter@users.sourceforge.net>
        ASRock E350M1 (SB800)

as commented on the bug report to it?


Thanks,

Paul

--=-Y+cQJDlz2d/SXiZefQjt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEABECAAYFAlESGEsACgkQPX1aK2wOHVgXogCeL4Bb0eWEhGxvFww9y5hCNTW3
picAn3Vd8XOTUGGZyzgUSOodA2hx4lbQ
=P72B
-----END PGP SIGNATURE-----

--=-Y+cQJDlz2d/SXiZefQjt--


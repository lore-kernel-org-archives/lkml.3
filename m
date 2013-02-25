Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759000Ab3BYLCK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 06:02:10 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:45922 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752579Ab3BYLCG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 06:02:06 -0500
Date: Mon, 25 Feb 2013 22:02:04 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michael Grzeschik <m.grzeschik@pengutronix.de>
Subject: Re: linux-next: build failure after merge of the kbuild tree
Message-Id: <20130225220204.3e52fddd01b612723fda2fd2@canb.auug.org.au>
In-Reply-To: <20130225215845.c0ec14a467aa6fe8e788e80e@canb.auug.org.au>
References: <20130225105650.6b89477b11c895ba99a666fe@canb.auug.org.au>
	<512B3CD8.5070802@suse.cz>
	<20130225215845.c0ec14a467aa6fe8e788e80e@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__25_Feb_2013_22_02_04_+1100_2X8U.dyy3BBwgc73"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__25_Feb_2013_22_02_04_+1100_2X8U.dyy3BBwgc73
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, 25 Feb 2013 21:58:45 +1100 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> But bash in sh mode does not work:

The bash manual says:

       .  filename [arguments]
       source filename [arguments]
              Read and execute commands from filename  in  the  current  sh=
ell
              environment  and return the exit status of the last command e=
xe=E2=80=90
              cuted from filename.  If filename does not contain a slash, f=
ile
              names  in  PATH  are used to find the directory containing fi=
le=E2=80=90
              name.  The file searched for in PATH  need  not  be  executab=
le.
              When  bash  is  not  in  posix  mode,  the  current directory=
 is
              searched if no file is found in PATH.  If the sourcepath  opt=
ion
              to  the  shopt  builtin  command  is turned off, the PATH is =
not
              searched.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__25_Feb_2013_22_02_04_+1100_2X8U.dyy3BBwgc73
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRK0SsAAoJEECxmPOUX5FEbfAQAKJycrNh7MsD8Pt/c8RIwfrG
Pqi0Q+10UYrRollCuPGu85PmJ14+SS2iYZNg3fKK8Elw+rmu7z/G4sO0k0cLXNyR
OuVzlj4SR7AHe5TRpPjVGll3ydRSuSHTNe2D7GcBjKgrLvJ+43vuh9cPvkKtTHw0
lgm1EJStPu888PiA449UxW4KI2HCv2xzi8perGeLSllP0orOubSwzmplgQ+pIB8C
wIfiBXES8AfD4J9JQbhnNX2Mi9SPdlUq+KlMDCLVafyF42fgEmeNeg12zhnUNuad
Iw3g2WBYrconZatp2J4BjkrCdniy6ngCJllqj+ubRJ4ym0kpc1n/ljpjChBcb9NM
Ng+VNIhorlaiYBZc0o7CXQMeIzWoabRfr/tZft/jZ1srUAPcVyOcvNqpekDthR6y
NxEgR24zOtWXGNOJNjbpYZCjlVDWynWmU6V+HvibCK/U/BIOUEknS0Wy5Kyv4KfN
cy7auwGmmWh1PIMpGNqVcjPiAz2QAzEc10QrUXw7i8uApd43ZRmKEYG7X/db2Q9n
U8dQmBQ+xlVJFSd5J/bOoQUqhvMnMfooUpFFDIcD6f5mA+81K6US8/5Tw4E7/EcU
g1i2q436GfohOm9SsPWIQeEAJZtOXrDvB2U02xGYdoZkfigA7qpFDmQKKfC2K5iP
MiDeGXQRPpvUxWKba/kl
=iiNz
-----END PGP SIGNATURE-----

--Signature=_Mon__25_Feb_2013_22_02_04_+1100_2X8U.dyy3BBwgc73--

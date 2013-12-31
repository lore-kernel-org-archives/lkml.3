Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752638Ab3LaJ7u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Dec 2013 04:59:50 -0500
Received: from mail-bk0-f45.google.com ([209.85.214.45]:55904 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752254Ab3LaJ7t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Dec 2013 04:59:49 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH] afs: proc cells and rootcell are writeable
Date: Tue, 31 Dec 2013 10:59:39 +0100
User-Agent: KMail/1.13.7 (Linux/3.11.0-15-generic; KDE/4.12.0; x86_64; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
References: <20131215230004.97d14ce7.akpm@linux-foundation.org> <201311201430.56135@pali> <20263.1387305065@warthog.procyon.org.uk>
In-Reply-To: <20263.1387305065@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2843209.Ed2boYq0IV";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201312311059.43847@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2843209.Ed2boYq0IV
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tuesday 17 December 2013 19:31:05 David Howells wrote:
> Andrew Morton <akpm@linux-foundation.org> wrote:
> > David ack?
>=20
> I've signed it off and added here:
>=20
> 	http://git.kernel.org/cgit/linux/kernel/git/dhowells/linux-fs
> .git/commit/?h=3Dafs&id=3D8de69dbba9012693d4f9e7a7e3c12a0b467f85f3
>=20
> David

Can you propose this patch also for stable branches? Without this=20
patch it is not possible to write to cells and rootcell files=20
which means that it is not possible to add new servers to cells,=20
so it is not possible to access afs disks and afs driver is=20
unusable...

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com


--nextPart2843209.Ed2boYq0IV
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlLClYsACgkQi/DJPQPkQ1Ks5ACfXCS6CzcC/gzSxawiwGWfWWLg
xkwAoIoJuTMGbr1dGTXmJxd4TV3jfAgg
=Gw4P
-----END PGP SIGNATURE-----

--nextPart2843209.Ed2boYq0IV--

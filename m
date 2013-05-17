Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756411Ab3EQToY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 15:44:24 -0400
Received: from ngcobalt07.manitu.net ([217.11.48.107]:35244 "EHLO
	ngcobalt07.manitu.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755620Ab3EQToW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 15:44:22 -0400
Date: Fri, 17 May 2013 21:44:19 +0200
From: Roland Eggner <edvx1@systemanalysen.net>
To: Chris Jones <chrisjones@spin.net.au>
Cc: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Linux source tree size difference issue
Message-ID: <20130517194419.GA4002@mobil.systemanalysen.net>
Mail-Followup-To: Chris Jones <chrisjones@spin.net.au>,
	linux-kernel@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>
References: <519577DD.3040204@spin.net.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="X1bOJ3K7DJ5YkBrT"
Content-Disposition: inline
In-Reply-To: <519577DD.3040204@spin.net.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--X1bOJ3K7DJ5YkBrT
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2013-05-17 Friday at 10:20 +1000 Chris Jones wrote:
> I have cloned the Linux kernel source tree locally. It comes in at
> approx. ~500MB. I have then created another git repository to push the
> source to for my own work. I rsynced the tree locally to another
> directory and now I am currently pushing it in to the new repository and
> it's at 58% and is already at 525MB.
>=20
> I can not understand the stark difference in source and directory size.
> Running diff tells me both local source tree directories are exactly the
> same.
>=20
> Can anyone explain this in layman's terms?

$  LC_ALL=3DC du --help  | grep -E -e 'apparent|sparse|fragmentation'
-------------------------------------------------------------------
      --apparent-size   print apparent sizes, rather than disk usage; altho=
ugh
                          the apparent size is usually smaller, it may be
                          larger due to holes in ('sparse') files, internal
                          fragmentation, indirect blocks, and the like
  -b, --bytes           equivalent to '--apparent-size --block-size=3D1'

--=20
Regards
Roland Eggner

--X1bOJ3K7DJ5YkBrT
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEARECAAYFAlGWiJMACgkQdN/hKfT7G/ISyACfbKQZnj7RdADy3IDurK4G99Hb
kmYAoJsvRI1H08AJ26SiVUYnC01Y6sKz
=jqSb
-----END PGP SIGNATURE-----

--X1bOJ3K7DJ5YkBrT--

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755036AbaLHKZc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 05:25:32 -0500
Received: from ozlabs.org ([103.22.144.67]:46099 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752111AbaLHKZa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 05:25:30 -0500
Date: Mon, 8 Dec 2014 21:25:23 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Ungerer <gerg@uclinux.org>, linux-m68k@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [git pull] m68k updates for 3.19
Message-ID: <20141208212523.47c3cf35@canb.auug.org.au>
In-Reply-To: <1418032337-15218-1-git-send-email-geert@linux-m68k.org>
References: <1418032337-15218-1-git-send-email-geert@linux-m68k.org>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/uDz7.AR.3b.pVjG4e98iM5A"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/uDz7.AR.3b.pVjG4e98iM5A
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Geert,

On Mon,  8 Dec 2014 10:52:17 +0100 Geert Uytterhoeven <geert@linux-m68k.org=
> wrote:
>
> The following changes since commit cac7f2429872d3733dc3f9915857b1691da2eb=
2f:
>=20
>   Linux 3.18-rc2 (2014-10-26 16:48:41 -0700)
>=20
> are available in the git repository at:
>=20
>   git://git.kernel.org/pub/scm/linux/kernel/git/geert/linux-m68k.git for-=
linus
>=20
> for you to fetch changes up to f0b99a643e9613beb28af43333bbfa90d4bf85cc:
>=20
>   m68k/mm: Eliminate memset after alloc_bootmem_pages (2014-11-10 09:56:4=
4 +0100)

It looks like this branch has not updated yet (or you forgot to push).
It is still commit f7bbd12a4b7e088f53f20dd31019984459699fb9 on
git.kernel.org.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/uDz7.AR.3b.pVjG4e98iM5A
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUhXyYAAoJEMDTa8Ir7ZwV9eYQAICS4N5jfSULupwomr4is24b
fv98ja+PnyPZgq+5NBCavPxFBco1MD1nalGYhfGqifPeN/8rrUNID9Ffca+hnKbs
3OIfiIRGJOIkVehNXr+fXHZqDJRmj9/MZXDIigcH4QV2MidBF+UtPwwrT+Nt+zrH
gEC28SWZymn/GFwZmpY+2qtXCsKHGBjHitKilpfGbyIlohPifkrec7ilXodckSmw
a3A2WY0Y4G8cgSr6IV2cZg0c7viemxChtRJxLxSdyDmFbEi32XJqGmPQ8qbSbXtK
Y1iA+ZJbkH2TuaNjYaX9Dc4mm3dsogKnmxX5kPlxWknMyZ44AZhsbW9QHIw8diTY
2Mso/jGIsGIHLs7ODDaCd65dqinoW1cFd7lSzHUrHShhgilKd7lh1srTuq4UUQ4e
iuAvznn/VGL9FISrWCkTJnyt8KGRJhJa7PaN8+9qxoie49n5DjwfUXsE6Yj9Tehm
TSG1gUkQg248vbIYuft1gsIIsNbB3OnND0KzXXVLg13eMDvIsXuq9nxDsWPE96pp
dyoes1eibnZx4uWoBIjnlW3Y5LTKkn1sK15i5bFfnMjLcjrMzk/NrHJh4x8EI0c9
pQEQjb9DAm/ZaHRLvxrDCHTzZo2wVE++W0QMFhT1k8OxuIq5EVma7wAiOcJr3N69
jOV0FvL0xna1qBpMF1m4
=S59Q
-----END PGP SIGNATURE-----

--Sig_/uDz7.AR.3b.pVjG4e98iM5A--

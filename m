Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751780AbaGNA01 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2014 20:26:27 -0400
Received: from ozlabs.org ([103.22.144.67]:50520 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751225AbaGNA0W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2014 20:26:22 -0400
Date: Mon, 14 Jul 2014 10:26:13 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Randy Dunlap <rdunlap@infradead.org>, Michal Marek <mmarek@suse.cz>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        David Herrmann <dh.herrmann@googlemail.com>,
        Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH 2/6] samples: refactor Makefile
Message-ID: <20140714102613.00495ec5@canb.auug.org.au>
In-Reply-To: <20140713195236.GA8711@ravnborg.org>
References: <20140713183636.GA17241@ravnborg.org>
	<1405276974-17323-1-git-send-email-sam@ravnborg.org>
	<1405276974-17323-2-git-send-email-sam@ravnborg.org>
	<53C2DD2D.2030902@infradead.org>
	<20140713195236.GA8711@ravnborg.org>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/z0VQ57x7yw6c3_G4joHBkLv"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/z0VQ57x7yw6c3_G4joHBkLv
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Sam,

On Sun, 13 Jul 2014 21:52:36 +0200 Sam Ravnborg <sam@ravnborg.org> wrote:
>
> On Sun, Jul 13, 2014 at 12:25:33PM -0700, Randy Dunlap wrote:
> > On 07/13/14 11:42, Sam Ravnborg wrote:
> > > Use one line per module/program in Makefile.
> > > This style is easier to read/extend.
> > >=20
> > > Introduce inverse xmas style sorting.
> >=20
> > google search couldn't tell me what that means and I cannot
> > deduce it from the new Makefile ordering (if there is some ordering).
> > Please explain.
>=20
> Sort by length - with longest entry first. Like an xmas tree upside-down.
> For entries with same lenght sort alphabetically.

If you are going to sort, just sort alphabetically ... this length
based sorting just means you have to search to find anything ... It
looks pretty, but that is about all.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/z0VQ57x7yw6c3_G4joHBkLv
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJTwyOpAAoJEMDTa8Ir7ZwVkkoP/R/AhctE4Aq0+2wwcORErQx+
0H5tRTKFk4lMiXqgWHYutq5vRi/g0kiJPK9u+EoKVSAGtDHAXQOrRgypPVO45SZj
H1XkNDEZi6JRGabn0VApA+J6CHr6ZfTHeUbO7BYsRP2PHTzX1NWw9T5HXaL30Vqe
ouJo1ivtQcvBmKiWMTb5nYFa1tM7NJtU5+K7pWednybnfKm4c6Fopvq9/Pqwm+/5
W1Pw3ThIdkTwXlh2vmg87Fmzu0UbNEHtC5eYJ7rIxh0nnfVM9pbeEmvRq0A2ijZe
KOMItxPVKOA0LcOZrDBgVUkNglbwSx5uok8Z5vrbuO1PgCrfuSvrEsPqX9Jgr5P6
AreV/I9BNexBOsYbyzf3CN8/VvXf5HIcL2Z7MWx4u6NtHXR1OrAsu9Oj5qZIaMcm
mqBj38khdnjAYOejP2nIt1f1KEfuOYmG8+Sfl7t3YCKtGqpNWlEXimn3s7fMDZUi
rq8+2X+pCJMKhnFHaD16sQh08AfpejFj+IjfSva10eWFswPwQaqiwWynJTqgAgfN
EI5JxCbhijpWPZYXOJTNblQHOhgTD10Rm6bHQ2bh/9YGWV4sJzrqFKpRx724+MhM
TPzSKu0vsgjjPZjrzdKfhUBnhnJWXEjQr2vwfrGvE2gb1zVGnv6zhQIlTjQs+MUO
/MBrVWSEZGB3CNd2YjGk
=1/+w
-----END PGP SIGNATURE-----

--Sig_/z0VQ57x7yw6c3_G4joHBkLv--

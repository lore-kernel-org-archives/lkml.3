Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752480AbaESBzu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2014 21:55:50 -0400
Received: from ozlabs.org ([103.22.144.67]:35097 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750969AbaESBzt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2014 21:55:49 -0400
Date: Mon, 19 May 2014 11:55:41 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Amos Kong <akong@redhat.com>, linux-kernel@vger.kernel.org,
        "Sasha Levin" <sasha.levin@oracle.com>
Subject: Re: [PATCH 1/2] virtio-rng: cope if struct hwrng.name is changed to
 const
Message-ID: <20140519115541.659bdc03@canb.auug.org.au>
In-Reply-To: <87zjiek56y.fsf@rustcorp.com.au>
References: <20140515153140.49b8028b@canb.auug.org.au>
	<87zjiek56y.fsf@rustcorp.com.au>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/A4uXY6LnxDq8KnA.G24.E+V"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/A4uXY6LnxDq8KnA.G24.E+V
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Rusty,

On Mon, 19 May 2014 09:30:53 +0930 Rusty Russell <rusty@rustcorp.com.au> wr=
ote:
>
> Stephen Rothwell <sfr@canb.auug.org.au> writes:
> > Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> > ---
> >  drivers/char/hw_random/virtio-rng.c | 6 ++++--
> >  1 file changed, 4 insertions(+), 2 deletions(-)
> >
> > Based on the current virtio tree in linux-next.
>=20
> Actually, Sasha Levin did a nice cleanup which replaces these two,
> and restores the const.
>=20
> I've applied them, so you should have it in today's linux-next.

Yep, saw that. Thanks.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/A4uXY6LnxDq8KnA.G24.E+V
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTeWShAAoJEMDTa8Ir7ZwV3kUP/AxNImzKXMpHEuBRNPtWNz1L
lfNAvaisjIW/Vu+aHwZqx0Qp+nwtOG+0ewLUIhSxsYKo3pz59eSA0L0/xKiqSnA7
oI3hp5bwV6N99aONPaBX/07XI+Jz0R+dnWRtYvXATqOyJ29sJ1r4tIQ8Kd9duBWo
1QAGD3KhVS9HUdKZWbthvCHOfhuSG2/rvfqKlv/aA1UGi5Z+qrrdw5t/bK61EWNJ
5sFOVj/YNf+sJnhp2lGvVW/yR4zu7KsNOiW4RY37GsIii/ONcB5yhe62A5h9yoEk
ur6gOMi6hiY8LNJ9HFTX8LfxCaP5giARUhqBvhT5rxLlI47p8LGGuXl6vmxSzIW8
zxsw2zUa2+aeQ+5UjKBtuZQOo8iWi2OBB8lU8wfetM+zBfVq5YPhg3blurrMlz4n
qm2JVXB96ozXCIar6eftXqum7kZx1S1X+D322yt5QqXrrSPOf2XPGBP5eIxqof1z
javEBAxoPolmwDyeuADyR+5mclSmiuFHlz0TuspNrsvwlbesyOezC1CsCagpSVw/
OW3o7EVZXcR0iOMeJjC2ceaELI7FR+JQCSPFhMef+41cwcVnOuV7CCdpHLlBkD+7
i09CFgvrAmulIZKOZKlNj/8OewnhKjlGh2Gp6SiQy1jqq+39xkgUFGe1uh8t804q
vcLR1VIAVjKrsszQ6KuN
=g04y
-----END PGP SIGNATURE-----

--Sig_/A4uXY6LnxDq8KnA.G24.E+V--

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752504AbaC3Uea (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 16:34:30 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:35839 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752401AbaC3Ue1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 16:34:27 -0400
Message-ID: <1396211650.1241.17.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [v3.2.y][PATCH 1/1] cifs: set MAY_SIGN when sec=krb5
From: Ben Hutchings <ben@decadent.org.uk>
To: Joseph Salisbury <joseph.salisbury@canonical.com>
Cc: sfrench@samba.org, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Date: Sun, 30 Mar 2014 21:34:10 +0100
In-Reply-To: <4f795fd099859c91c56b7a05996bc38a040bc9c0.1393535604.git.joseph.salisbury@canonical.com>
References: <cover.1393535604.git.joseph.salisbury@canonical.com>
	 <4f795fd099859c91c56b7a05996bc38a040bc9c0.1393535604.git.joseph.salisbury@canonical.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-sbrzFLE0MmY3nuwGj2K0"
X-Mailer: Evolution 3.8.5-2+b3 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-sbrzFLE0MmY3nuwGj2K0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2014-02-28 at 16:07 -0500, Joseph Salisbury wrote:
> Backport from mainline commit: 0b7bc84000d71f3647ca33ab1bf5bd928535c846.
> This backport was done so including mainline commit
> 8830d7e07a5e38bc47650a7554b7c1cfd49902bf is not needed.
>=20
> BugLink: http://bugs.launchpad.net/bugs/1285723
>=20
> Signed-off-by: Joseph Salisbury <joseph.salisbury@canonical.com>

Queued up for 3.2, thanks.

Please include the original patch header in future.

Ben.

> ---
>  fs/cifs/connect.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>=20
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 56c152d..49d6e21 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -1113,7 +1113,8 @@ cifs_parse_mount_options(const char *mountdata, con=
st char *devname,
>  				cERROR(1, "Krb5 cifs privacy not supported");
>  				goto cifs_parse_mount_err;
>  			} else if (strnicmp(value, "krb5", 4) =3D=3D 0) {
> -				vol->secFlg |=3D CIFSSEC_MAY_KRB5;
> +				vol->secFlg |=3D CIFSSEC_MAY_KRB5 |=20
> +					CIFSSEC_MAY_SIGN;
>  			} else if (strnicmp(value, "ntlmsspi", 8) =3D=3D 0) {
>  				vol->secFlg |=3D CIFSSEC_MAY_NTLMSSP |
>  					CIFSSEC_MUST_SIGN;

--=20
Ben Hutchings
If more than one person is responsible for a bug, no one is at fault.

--=-sbrzFLE0MmY3nuwGj2K0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUAUzh/wue/yOyVhhEJAQp3HQ//S6rNKgEqUitPHomdUt/LZJ90jwMmQ/cy
9FyixNvwssHsIf9ATbWOzvaqFkIUvoFhND6H8R4ZZnOdQ3Tvol7T0hadbqNMvlzS
T7qtF3B1vwQEErdwA4W81Bl8H0TC+cutH1PnuHB/b2bsqqRrbZ/q11xLV5Yt6ZV+
AoSjYY92aphHKXr6d4FmYGNgGijobVAcjmkvEZnsxbahkUSmMHYWIICInrzWkql1
PoYuVZGhUNTUhvmlZZJO5Z602iy+eeODT43NITQ5bFFZAVwi04pyPcyPxKLjYSm3
z1PmrZkYscew3onEBIdGzjJ8DT6wAhjeceR9tZm4UnXlpVvIPVv0DyieZSHOrB11
/qCDuFHZn+6MCiZxEmAyUxudhztRoH1nVBc3u+C4y3uYjjETRdOjxJ7yelJPR1t8
lVXTI9Xlvy8ZBTiMojVkipGenkB1uZEmddTTFYuu/K6zWkJ/ciwL4f7nssTonqEr
GccMq8WBHVgdy/d8UVUGqdkPwiHGUZUNRLBZQoNirgyfWjTUOZKna9o8bXvkzSjK
BiXlN95emUFYV8yY6h6XTAyr4xCIzEvSSALqDHT0Nw+NoSLLi8u70ZHGGlpRMac0
i9yPlhoaGf00XQe3NvS/PrOUttC8uXLDNwnODox0LgncY3Ziu4GtQxXisR6y7uWR
zWiyscaG/9U=
=MNhB
-----END PGP SIGNATURE-----

--=-sbrzFLE0MmY3nuwGj2K0--

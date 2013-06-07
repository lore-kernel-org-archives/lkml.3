Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753663Ab3FGDtL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 23:49:11 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:49986 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751916Ab3FGDtI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 23:49:08 -0400
Message-ID: <1370576938.4021.66.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [ 044/184] ALSA: ice1712: Initialize card->private_data
From: Ben Hutchings <ben@decadent.org.uk>
To: Willy Tarreau <w@1wt.eu>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Sean Connor <sconnor004@allyinics.org>, Takashi Iwai <tiwai@suse.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Fri, 07 Jun 2013 04:48:58 +0100
In-Reply-To: <20130604172132.135940874@1wt.eu>
References: <20130604172132.135940874@1wt.eu>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-mJFNCNdc5i44ZvrBT4Ke"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-mJFNCNdc5i44ZvrBT4Ke
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2013-06-04 at 19:22 +0200, Willy Tarreau wrote:
> 2.6.32-longterm review patch.  If anyone has any objections, please let m=
e know.
>=20
> ------------------
>  properly
>=20
> From: Sean Connor <sconnor004@allyinics.org>
>=20
> commit 69a4cfdd444d1fe5c24d29b3a063964ac165d2cd upstream.
>=20
> Set card->private_data in snd_ice1712_create for fixing NULL
> dereference in snd_ice1712_remove().

This bug appears to have been introduced in Linux 3.8 and doesn't need
fixing in 2.6.32.

Ben.

> Signed-off-by: Sean Connor <sconnor004@allyinics.org>
> Signed-off-by: Takashi Iwai <tiwai@suse.de>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Willy Tarreau <w@1wt.eu>
> ---
>  sound/pci/ice1712/ice1712.c | 2 ++
>  1 file changed, 2 insertions(+)
>=20
> diff --git a/sound/pci/ice1712/ice1712.c b/sound/pci/ice1712/ice1712.c
> index d74033a..95496ae 100644
> --- a/sound/pci/ice1712/ice1712.c
> +++ b/sound/pci/ice1712/ice1712.c
> @@ -2574,6 +2574,8 @@ static int __devinit snd_ice1712_create(struct snd_=
card *card,
>  	snd_ice1712_proc_init(ice);
>  	synchronize_irq(pci->irq);
> =20
> +	card->private_data =3D ice;
> +
>  	err =3D pci_request_regions(pci, "ICE1712");
>  	if (err < 0) {
>  		kfree(ice);

--=20
Ben Hutchings
Theory and practice are closer in theory than in practice.
                                - John Levine, moderator of comp.compilers

--=-mJFNCNdc5i44ZvrBT4Ke
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUbFYKue/yOyVhhEJAQqKdhAAh1Wc71KjA1O+qhae1LQIiR6+0hOmCJUm
1j0HmvhLKbzZ4llElGsobmiCy646ZW3rgVbZzUPAsOMA4VQqR20cAcHde2v4go5V
h8w/6jElJLvs4H5Rl5QnAsx7NOsyPvu4twZybLqTz24a7vSynJEpBcPETMf86ut/
vtiTPD9CarvxeTNo9aVEOSQFU0v+iy9ZMGK+iwMYW9q9wVK8JVw7wPssxGeELnbQ
2qMxbo2Cb56D0+WgDCrug1s6xVxZo1OVwtzsql2hBXYOXlcS+gwuk2G4a7r44if1
jXmA56/MVmS2YdK3HKmeUyeTYcnXuTlpoWrpAAhCq6KqgcWVUq9qIdYW1sg++mMk
FuyDJfDWxOUTJiGdW9dsSJj8OE4ICcozsbaFd/cZWMZXHcrDqTAg4slYkihSY5rs
FEg4WXB8ZeTg+Q1q74/GEP+NyAydUIa+7sjNW6naXOck6hl16R8Ng+qGcGDjoW01
nSDl7i8QONJ9xGO2kbonRWx/Dd/8WSTjYBV58zAinbsQ4iJH9PNr+oMV02z25iSG
16SvM4HHQ4W1A22mylOzt4TpNkrQorEvdctj4uh+AvjKa+p9gqlwOJNoRUN+biPp
qNPHMnxASj0UwSHH/dP0RRoYpWBK3QTLqrMMWnvqCbkm/XeIogNFWi91brXQODDB
1uZJIiYt+Yw=
=pVqj
-----END PGP SIGNATURE-----

--=-mJFNCNdc5i44ZvrBT4Ke--

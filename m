Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753536Ab3CEFYa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 00:24:30 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43054 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750974Ab3CEFY3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 00:24:29 -0500
Message-ID: <1362461065.3768.395.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [ 052/153] idr: idr_for_each_entry() macro
From: Ben Hutchings <ben@decadent.org.uk>
To: Philipp Reisner <philipp.reisner@linbit.com>
Cc: stable@vger.kernel.org, akpm@linux-foundation.org,
        LKML <linux-kernel@vger.kernel.org>
Date: Tue, 05 Mar 2013 05:24:25 +0000
In-Reply-To: <1607973.Qpkavuy2AM@quad>
References: <20130304033712.754098899@decadent.org.uk>
	 <1362373013.3768.295.camel@deadeye.wl.decadent.org.uk>
	 <1607973.Qpkavuy2AM@quad>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-G23B/akFNo20qvCkih3q"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a11:96ff:fec6:70c4
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-G23B/akFNo20qvCkih3q
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2013-03-04 at 22:05 +0100, Philipp Reisner wrote:
> Sure, here it is:
> ----------
>=20
> From: Philipp Reisner <philipp.reisner@linbit.com>
>=20
> commit 9749f30f1a387070e6e8351f35aeb829eacc3ab6 upstream.
>=20
> Inspired by the list_for_each_entry() macro
>=20
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>

Thanks.

Ben.

> ---
>  include/linux/idr.h |   11 +++++++++++
>  1 file changed, 11 insertions(+)
>=20
> diff --git a/include/linux/idr.h b/include/linux/idr.h
> index 255491c..52a9da2 100644
> --- a/include/linux/idr.h
> +++ b/include/linux/idr.h
> @@ -152,4 +152,15 @@ void ida_simple_remove(struct ida *ida, unsigned int=
 id);
> =20
>  void __init idr_init_cache(void);
> =20
> +/**
> + * idr_for_each_entry - iterate over an idr's elements of a given type
> + * @idp:     idr handle
> + * @entry:   the type * to use as cursor
> + * @id:      id entry's key
> + */
> +#define idr_for_each_entry(idp, entry, id)                             \
> +       for (id =3D 0, entry =3D (typeof(entry))idr_get_next((idp), &(id)=
); \
> +            entry !=3D NULL;                                            =
 \
> +            ++id, entry =3D (typeof(entry))idr_get_next((idp), &(id)))
> +
>  #endif /* __IDR_H__ */
>=20
>=20

--=20
Ben Hutchings
Always try to do things in chronological order;
it's less confusing that way.

--=-G23B/akFNo20qvCkih3q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUTWBiee/yOyVhhEJAQpYyBAAj0OzAFbv8q7MPDPbmEoh3Mf+SnnKVLsN
+SThgS5R8mwS9fROckn1nSxYKVpFav1W/B7Mnbhj2oIvr9cluSY6k8sETzPfMpjj
0GUt9aWjh4y+pOnBvs1FmpBwnD6Cm77xPVqdz9fbWh5E5I+y1DsnEixJytC3MqPY
R1UOclOevjkTCFmcp+7c3ql4ISCW0W5T6nlWVqg6wTiw0QDhtSc+dcL4t/OMdUPL
Hv5StlM4ka1LuWsxsLps0LaxxKtVjf2Yuu/JDsNsjb4k4rJZV+0dKzntHvl6ZYmC
SX22ycb+pxTDwwy8aHLjIwcRCi4l1peyoq0PZ9+nOmcDGE1QrBgvMWNriPJN45iU
WhS7VLeBvKC67hWATSCJ0oudmIcgEge8TpoXviqTuYbK/GOWwFReFgYzyLBWRVbe
lkajbxsMqy1wNW5BX3UdgN3KLUNKcB6+WsxwU+53KWWkRCcdE99aC/Za498trNnI
rBYopagsdrsY86UEILVOuw3weaEpqeLq/H6FqOzwwxH2R5LvLEYVRCd100kM0xO2
ySCoW1FXNQ5kKPL+ZoiOVNcIYIm+x1uHSDO+5W7SFanY+O6d2smrQAq6+33FBJ/w
etDgiTwPGScjIwv9/ncA1t42rqCQitMauimtPIz8yAJlGd+Ve4FPqg1Gt3DtIZNH
N/0yQCzmolU=
=rhYu
-----END PGP SIGNATURE-----

--=-G23B/akFNo20qvCkih3q--

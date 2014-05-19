Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754672AbaESNFF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 09:05:05 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:38661 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752681AbaESNFC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 09:05:02 -0400
Message-ID: <537A0170.3050307@ti.com>
Date: Mon, 19 May 2014 16:04:48 +0300
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Julia Lawall <Julia.Lawall@lip6.fr>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
CC: <kernel-janitors@vger.kernel.org>, <linux-fbdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] video: delete unneeded call to platform_get_drvdata
References: <1400308369-24375-2-git-send-email-Julia.Lawall@lip6.fr>
In-Reply-To: <1400308369-24375-2-git-send-email-Julia.Lawall@lip6.fr>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="VpxRe3FN0xqxWeRfWJ1iwJthjGAGC98gM"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--VpxRe3FN0xqxWeRfWJ1iwJthjGAGC98gM
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 17/05/14 09:32, Julia Lawall wrote:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
>=20
> Platform_get_drvdata is an accessor function, and has no purpose if its=

> result is not used.
>=20
> The semantic patch that fixes this problem is as follows:
> (http://coccinelle.lip6.fr/)
>=20
> // <smpl>
> @@
> identifier x;
> type T;
> @@
> - T x =3D platform_get_drvdata(...);
> ... when !=3D x
> // </smpl>
>=20
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
>=20
> ---
>  drivers/video/fbdev/bf54x-lq043fb.c |    2 --
>  1 file changed, 2 deletions(-)

Thanks, queued for 3.16.

 Tomi



--VpxRe3FN0xqxWeRfWJ1iwJthjGAGC98gM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTegFwAAoJEPo9qoy8lh71NpoP/2/FfP5A5wq5/LnOuwHRZUFm
7/xZx79XWFpvTeBluG3Edw29Z0++4LZDjPJZSubUfvPA+VEDcmnSUMuXAx4jZK9b
ayu+wKpGH91Z0lvrvQvXTMeUta4tNkt6iD/LRQkMxojT1EfiE9khpuqoL9+VFwD5
LN4jvSDXsvYBicxYx/NSbkapVF3LWS11AbejMuDdjl5Z00AyQ6IUYYu+ogOTPpA+
yidtVWyJk4kfCmryOPdTMet0pvp+9OTauctXnkl5U8J8NKWNr8vimhXoDAKiNuyp
adYL2t5MbQy6U5nW4PMCtfRI9Zgp/i7WmCbvk8745Y0hP6wKIozRT3768x3XyWyx
Mna6Vvk01JycvLR5Mt0ZpnffN8rUtBym77ijZq3lAd6ATNS01iUFBB5cJ8AwsAH+
NM83p9RkyVZsqi2XSwKCriy/6eZGGAGJgnreA7S4AYeTDGiM+kSg9BA449Bn7q/S
S/6uFYn4rpuFtv3XwAzReLi8//+sYAm1PZIB44emOr4fb4DrvJoddc94x747mogm
RNTkDOqSO7hOcEENcfbd7XrPn1VJcc0vVMa+ihqXjNoCWV/x4U9jbxZ5OMTugHyD
GwrAOHXQNyHDWza0BnjKtd8mgS6asH3DR9RO+fI8he70pAzoiDb3ysFIxJd3DVEW
hAqYaQtSye86XOVYwm4Z
=f1nT
-----END PGP SIGNATURE-----

--VpxRe3FN0xqxWeRfWJ1iwJthjGAGC98gM--

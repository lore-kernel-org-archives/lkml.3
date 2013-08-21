Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752738Ab3HUVy3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 17:54:29 -0400
Received: from top.free-electrons.com ([176.31.233.9]:40613 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751624Ab3HUVy2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 17:54:28 -0400
Date: Wed, 21 Aug 2013 23:54:24 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Emilio Lopez <emilio@elopez.com.ar>, kevin.z.m.zh@gmail.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-sunxi@googlegroups.com
Subject: Re: [PATCHv3 5/9] pinctrl: sunxi: Fix inconsistent indentation
Message-ID: <20130821215424.GA2970@lukather>
References: <1375610330-18185-1-git-send-email-maxime.ripard@free-electrons.com>
 <1375610330-18185-6-git-send-email-maxime.ripard@free-electrons.com>
 <CACRpkdb0-Ue3aRT8ohHVMUU3RmeL4D0ZDR6pB-OBb0p+2Anw9Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pf9I7BMVVzbSWLtt"
Content-Disposition: inline
In-Reply-To: <CACRpkdb0-Ue3aRT8ohHVMUU3RmeL4D0ZDR6pB-OBb0p+2Anw9Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--pf9I7BMVVzbSWLtt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 21, 2013 at 11:49:58PM +0200, Linus Walleij wrote:
> On Sun, Aug 4, 2013 at 11:58 AM, Maxime Ripard
> <maxime.ripard@free-electrons.com> wrote:
>=20
> > Some pin functions in the array were not indented like the other
> > functions in this array. Fix this.
> >
> > Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> > Cc: Linus Walleij <linus.walleij@linaro.org>
>=20
> Patch applied.
>=20
> Since the reply mentions that you want me to apply it I
> did so.
>=20
> And I assume you want to take the two others so I
> applied those as well.
>=20
> The thing that made it take time was partly that it
> was part of a multi-patch set and I couldn't figure out
> how that was going to be merged and as there were
> comments on the other patches in the set I assume
> the whole thing will be respun.
>=20
> But whatever, I applied these three patches now,
> tell me if there are more of them.

Great, thanks! :)

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--pf9I7BMVVzbSWLtt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSFTcQAAoJEBx+YmzsjxAg7fEP/0WO4YxKR3xtJFaMO6uwAnkf
BgX+sOy/xOlwNwkW+B2JJu92sB/ZIJ/C+xIxiSHqU1nS5bzJ8WB+grgNmJYwnNJH
cdm8Wu47fVoGDyjCbfw/EEFDT9DwWKHn2CV35dDXR72twQsIMJEku+2tkJtWrP5M
1V4PRGRMQj155NjO2ptHnx/TGijVb7Ks/ZycNrgRxBoYfO2gszy+iPL8rIF70mPu
ylpK3IGLnm/hULZ+FAnyWXMwITklLlek0oCBkvhO5NLsLK/f4eTXtac5UpCj4rlq
BFueFS4+5Y3nNP1UdgsNm2ROf2Zt+MjYeZm5AkvKcnluZmRNTfb/j5FQNrR85o9D
2thw0XeYWy1d1kh0L8zxqLBCp+M5kvf5sNouAFQt4l6dqy+tJKI0DYTmU1f8+n0I
iBDm9pG4XXLkWV4tji5JY2hZRzP3uFb8Ka0WvZ9Ediro4WzHj4eHofKGcL01PcK1
Kg8xG7K041KqHLTSmmjCX1VWEVLFm9FfKU6/TLZk9z/LmL2TEZ7KTzz/UZGEOFDt
2yHbGbymf6ZwUmnDclmDQ2oBrjF9C8CBGuEJkpcpvEtQ5cAgYH5gxX5w0g0zwGyk
ZFqi2Rezw+zDX7xhQm+YHQ4NfEv5eZoKQIZvCTJy2XkKsfEUXB12Eahdb6fAmL8L
+QuTULzKTlY5+Fo+mZk6
=2aQa
-----END PGP SIGNATURE-----

--pf9I7BMVVzbSWLtt--

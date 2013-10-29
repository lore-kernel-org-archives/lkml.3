Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756193Ab3J2N7h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 09:59:37 -0400
Received: from nereida.gnuservers.com.ar ([207.192.69.134]:46753 "EHLO
	nereida.gnuservers.com.ar" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755876Ab3J2N7f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 09:59:35 -0400
X-Greylist: delayed 531 seconds by postgrey-1.27 at vger.kernel.org; Tue, 29 Oct 2013 09:59:35 EDT
Date: Tue, 29 Oct 2013 14:50:36 +0100
From: Maximiliano Curia <maxy@gnuservers.com.ar>
To: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Margarita Manterola <margamanterola@gmail.com>,
        Pavel Machek <pavel@ucw.cz>, Peter Hurley <peter@hurleysoftware.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, bug-readline@gnu.org,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Subject: Re: Large pastes into readline enabled programs causes breakage from
 v2.6.31 onwards
Message-ID: <20131029135036.GA30992@gnuservers.com.ar>
References: <CAP+fKSpvJqeh8JCHisByDBsGWPOWOcDN4qeVYJOn1tgg8HR0eg@mail.gmail.com>
 <CAP+fKSp5ze3-qWHY_D_e3AXxnFM-AB9FBfRLjy0yOFnOp6bp4w@mail.gmail.com>
 <201309030717.57866.a.miskiewicz@gmail.com>
 <201310241800.18490.a.miskiewicz@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="J/dobhs11T7y2rNN"
Content-Disposition: inline
In-Reply-To: <201310241800.18490.a.miskiewicz@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--J/dobhs11T7y2rNN
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

=A1Hola Arkadiusz!

El 2013-10-24 a las 18:00 +0200, Arkadiusz Miskiewicz escribi=F3:
> Was just going over bug-readline and lkml archives and found no continuat=
ion
> of this.

> There was a patch proposed but didn't get applied.
> https://lkml.org/lkml/2013/8/17/31
> Maybe it only needs proper patch submission?

The latest patch is: https://lkml.org/lkml/2013/9/3/539

And the latest reply is: https://lkml.org/lkml/2013/9/11/825

Where Peter Hurley suggests that the patch needs a complete and detailed
analysis, but sadly I'm still not sure how to provide it. If anybody is up =
for
the task, by all means, go ahead.

The patch seems to be applied in the ubuntu kernel without any known issues=
 so
far.

> Looking from bug-readline archives debugging it took huge amount of work =
and
> would be sad that all that ended up being wasted.

True, but I somehow agree with Peter in that a known bug is better than
applying a fix with unknown consequences, even though I think that
this particular patch won't break anything.

Happy hacking,
--=20
"If you have too many special cases, you are doing it wrong." -- Craig Zaro=
uni
Saludos /\/\ /\ >< `/

--J/dobhs11T7y2rNN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJSb70rAAoJEMcZdpmymyMqCRkQALABZb+kwykkZh/XEMdAEE7M
FpWZxAjPl1dlkPuDTLWsIFwmG2CRKUi2wh1zc3/FMoXhj31btjC8lJjXLTsuU4YL
mYBJqvkrjyBx7afkI1wwkYQLMsRzUoJshS2+TkkW4dPkUOyn46KeL3lPGyxFA7M/
uHcYtSZmypn8pR9Gl6c72x+ZrGPgZ8XVvJDmZ9P4VcUyXr/xLBnsY6N0NtzrKrwC
3gj52mNniwmxOTNQrj/25UXIyh+Bc+WQGozhw3WeAQump8ffdtrPKIDr8yii5chm
FzxVFXdR7uL4R1QLdOWuOJiPlm9sEKSppJ63Bg7/rSsPdh43r/LQeOQsoPuPYOuH
YjcpiSzP1xaoURJWGt1CeIGViFHSkvOKuY06kOgh98K6PFHy+FCw+bu5ZoJz/jZI
zEUs9lMaqdEhJnyzQiX2/WBy8Xi53L7CiRHdIFKZkoqoEOaZX5VnO4YxhPueSR42
CWMKkkw4/uTIWOrhgfk1IUrqBPmivC8N805/bn+WzpS49mr9wMI/LRp2fSMC0c5z
pkQFam5FXUfy3snNANv0DDFY/csL0/p/NQv/cSUR/3MXnKKXlVbiuqfaaEBvmeks
PZ0yzM/AT8lP68wfxn31y4D54Z2maqonFoKFxUD7EJTEYBKpPWQRbd70R9z3Jfs3
ovjmxkAElbL13c/k0cYK
=FF8H
-----END PGP SIGNATURE-----

--J/dobhs11T7y2rNN--

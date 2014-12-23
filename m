Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754499AbaLWSof (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 13:44:35 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:33927 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750725AbaLWSod (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 13:44:33 -0500
Date: Tue, 23 Dec 2014 12:44:07 -0600
From: Felipe Balbi <balbi@ti.com>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
CC: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
        Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Peter Chen <peter.chen@freescale.com>,
        Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 06/17] net2280: Remove restart_dma inline function
 definition
Message-ID: <20141223184407.GK9147@saruman>
Reply-To: <balbi@ti.com>
References: <1417182662-7405-1-git-send-email-ricardo.ribalda@gmail.com>
 <1417182662-7405-7-git-send-email-ricardo.ribalda@gmail.com>
 <54788AC3.9090808@cogentembedded.com>
 <CAPybu_1R+L91kGTG1sHhKiChd3v7=wa70v2VWDrQ-TH1FYyxSQ@mail.gmail.com>
 <5478D810.3060101@cogentembedded.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7ArrI7P/b+va1vZ8"
Content-Disposition: inline
In-Reply-To: <5478D810.3060101@cogentembedded.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--7ArrI7P/b+va1vZ8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 28, 2014 at 11:16:16PM +0300, Sergei Shtylyov wrote:
> On 11/28/2014 06:21 PM, Ricardo Ribalda Delgado wrote:
>=20
> >Thanks for reviewing. I will fix it and resend it on the next version
> >of the patchset to avoid spamming the ML
>=20
> >I guess it is ok to add your Reviewed-by
>=20
>    Yes, if you like.
>=20
> >Thanks!
>=20
>    Not at all. :-)
>=20
> [...]
>=20
> >>On 11/28/2014 04:50 PM, Ricardo Ribalda Delgado wrote:
>=20
> >>>restart_dma is not used before it is declaration. Therefore we can
>=20
> >>    s/it is/its/.
>=20
>    Also s/declaration/definition/.
>=20
> >>>remove this definition.
>=20
> >>    You're removing the declaration, not definition.

do I get a new version of this patch ?

--=20
balbi

--7ArrI7P/b+va1vZ8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUmbf3AAoJEIaOsuA1yqREuFYQAK0Kh4WuHw0av90ATue6IAQx
MX2eTcD+jKfX8Ld53X4GTrrZE/zLOhAWH9cf3VpT0pQX7LUHnOa8LaC+XtrXA0+9
fJWcCrBMY8m1DNvyxA1yB5hSDEEUM1tWefxvvZmPpPgEzp4bqvvxFszl5TT2izLS
RFxSjjEICkwl9SjCGfx+5Duh9OfBH3rJIi7a527lpeZeO9gxjR4NYJnx1y/qKUWn
Y9CVUgzBkjA2CWHDCqoaGJv/m3RwvtJa8m5M32upb4yWUWWdcKwja1QVCxkV8z6W
xlTRFYu4cvbEAajjrS8iBjreGAQ6feyALfaCh4lAmZY2qXyIOycXM1uY3W+kG19J
c8InFAkLyPk2gQ35U63aoaL/B3a8JImyBYbkpI3EMQhnHpk7V7ybXGUoY3h1WUo5
tvsy1Wgl9XCfjvUq1LY4+iTy5dUzIbz8R5yDiEWA+W5CIfd9XDsqbTikXqwBb5Bb
zW+LrtagSWSbR3r4iLubpakl6oh9mYIBpVhDa+22rZFnjl5GAjY5HmKQBpgvkVbq
J9ZBpZ3Pt/FTQqwhYogwBz2XFfd0EdW7r2ypwdI3RT2dVCUHRZOXX/GUCYeE5wX+
jPxKFf1hTHl8MwT65ha3YaWoDlKefgVOKG+h2DT3JuCVWYwsCVKeOwa1jJZasJ3k
IqesvqaN9RnHC8A9aXv3
=nALV
-----END PGP SIGNATURE-----

--7ArrI7P/b+va1vZ8--

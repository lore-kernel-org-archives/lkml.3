Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756269Ab3JXPzP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 11:55:15 -0400
Received: from top.free-electrons.com ([176.31.233.9]:51415 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755275Ab3JXPzI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 11:55:08 -0400
Date: Thu, 24 Oct 2013 16:52:20 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Valentin Ilie <valentin.ilie@gmail.com>
Cc: mturquette@linaro.org, emilio@elopez.com.ar,
        gregory.clement@free-electrons.com, sboyd@codeaurora.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] clk: sunxi: fix memory leaks
Message-ID: <20131024155220.GA2768@lukather>
References: <1382617513-9259-1-git-send-email-valentin.ilie@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cNdxnHkX5QqsyA0e"
Content-Disposition: inline
In-Reply-To: <1382617513-9259-1-git-send-email-valentin.ilie@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--cNdxnHkX5QqsyA0e
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Oct 24, 2013 at 03:25:13PM +0300, Valentin Ilie wrote:
> When the if condition is true, "fixed" and "gate" should be free'd before=
 return.
>=20
> Signed-off-by: Valentin Ilie <valentin.ilie@gmail.com>

A patch has already been submitted for this.

https://lkml.org/lkml/2013/10/18/524

Thanks anyway!
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--cNdxnHkX5QqsyA0e
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSaUIzAAoJEBx+YmzsjxAgsmkP/A3AO2+xlHUVHLlhVbS2Q027
H5RoYpsimxqb6/71Ae19YJTJrMXvYG6Wv5IGKY7hNxftVKu3uPmFkyXLjrcSBL53
ph890KY1VMw5Brgun9XK+wSAiOnUtZ7w+Wh5YQVDyQpJXiIlM8y/UL4nP5pFysut
AcarCxZcud39y5bQLze87IN7ekm0lg4W7gDTtp6s/bekHRhHxRa0cOS4BOc+3T5f
VGyprGbwiAmQ42AYCRPN6C0HV1gcwm8vRoKoi/iETYesrkVo9wY7f7RxGeUMFJ4W
tcE1p+gokHFK9v+OIcTHdbtndk6aVOnc6y90pt54AVFUFlulnRaPzqX2MSlqI/rd
e4xIKfQRbEPImlVySNPv8Bfflgwha5i5BIvoJEVclL7HNQpTuA575tbk2d+344o4
vPBSsiJBDDp96qr7WsphTKIefzFOEzRtf1InxH7xye8ZdxFegm8yFUygBy8BrFHG
ApfM6vwAQwo5EoulDUhJEH/zfl+Eu2GHBK2BrfnNZx0YM0Lkvo6FgNIFX6I1NSSW
T27UWbPUuFPOwJjGxhAMg9D0JR2ZsoT06qAbnsWo3ie0lAfPKRZvSlflBqsogFoG
3OkZOF6lDV2gMbzTHer0ggST3B232BJaxgjBmDe1O7/904PNEJjne5U5pmoOLP2Y
o8dT8/yDfd7pvbLfh6aO
=DCqM
-----END PGP SIGNATURE-----

--cNdxnHkX5QqsyA0e--

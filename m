Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752332AbaBLPPw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 10:15:52 -0500
Received: from sauhun.de ([89.238.76.85]:41493 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751942AbaBLPPt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 10:15:49 -0500
Date: Wed, 12 Feb 2014 16:15:43 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: linux@roeck-us.net
Cc: linux-i2c@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Rob Landley <rob@landley.net>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/17] Documentation: i2c: describe devicetree method for
 instantiating devices
Message-ID: <20140212151543.GA10871@katana>
References: <1392026654-5343-1-git-send-email-wsa@the-dreams.de>
 <1392026654-5343-2-git-send-email-wsa@the-dreams.de>
 <20140210122119.115858a7ntu4lr40@67.228.131.205>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rwEMma7ioTxnRzrJ"
Content-Disposition: inline
In-Reply-To: <20140210122119.115858a7ntu4lr40@67.228.131.205>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--rwEMma7ioTxnRzrJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


> There is now also a means to instantiate I2C devices through
> ACPI. This is documented in Documentation/acpi/enumeration.txt.
>=20
> Might be worthwhile to reference it from instantiating-devices.
> I guess that would be a separate patch though.

Yes, it would. Thanks for the pointer!


--rwEMma7ioTxnRzrJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJS+5AfAAoJEBQN5MwUoCm28tMP/168mE9oo/SJj64Qh5ZeM8vL
pPoxY3k/4I4LSpyWysiuV9exTZb8DLi0llyWGmCw6T98nIxcpIeqMpHm91wxMY4X
JNTHMneAvcHgS1aRI/TtlvrrxP+TCt/DE9qFeyREjfH/MidVZkBQR5kPfpzGJ758
6hs0JlUEJW/8ysiTLGI/ToBIOty5el+T9rX8QweMt8TBaiQqat60o1hD4nR3qTrI
cAVcLGdOJ9ix41ghJeO/r1QGSkYVKUvLS9aHGyLoHH6GZ3oVP4g8mvXfklz6TB9R
dFqnBgWtVajVO5HNFGJ+S1fO3qFqpzP5AlWetQO0xccW2mTu+cUfWuxJFR5/B+UG
TQPwoDuUcAFlOoKg36G4/d3Lq5CK8UJ3kbNRQeGTLwrP7A8p+//glRs8PoO4Znr/
frq6xKhzwI7vAW+82j9sAI2Du/DlWhbkNkGNmhvZW7vLPLwdYueMEVJi/82uJeAV
4wxTAYX5+vvL4aurgh+O3G+iPtCFr7pxVhXT8UhwMHa9Yp9gvKfwBdyWWtOgWtCh
69L/ZfbZm09kFn5Ao3xawPaleb+XWfI9bE1s8+ZUVuqrawOUayYLCUk1UuKQtm7c
gyv8YMzA+HcSRab+R9P20q1ltWugJV3ppkdEkNqva8mTvSPc/SGO9Pq6XnrhJryF
CI/gvqRjbf/PrlDckTZM
=Uqmz
-----END PGP SIGNATURE-----

--rwEMma7ioTxnRzrJ--

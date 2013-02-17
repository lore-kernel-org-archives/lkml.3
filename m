Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751141Ab3BQQZg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 11:25:36 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42368 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751024Ab3BQQZf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 11:25:35 -0500
Date: Sun, 17 Feb 2013 16:25:24 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Cc: Eric Piel <eric.piel@tremplin-utc.net>,
        Ilkka Koskinen <ilkka.koskinen@nokia.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: Driver lis3lv02d_i2c not working on Nokia RX-51
Message-ID: <20130217162523.GC1583@opensource.wolfsonmicro.com>
References: <201302170046.26569@pali>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="B4IIlcmfBL/1gGOG"
Content-Disposition: inline
In-Reply-To: <201302170046.26569@pali>
X-Cookie: Is this really happening?
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--B4IIlcmfBL/1gGOG
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Feb 17, 2013 at 12:46:25AM +0100, Pali Roh=E1r wrote:

> Accelerometer driver lis3lv02d_i2c not working on Nokia RX-51=20
> with linux kernel 3.8-rc3. Probing for i2c device failing.

> I tried to compile older version and it working without problem.=20
> Then I bisected commit which broke support for RX-51.

> That commit is ec400c9fab99d16a491cea17d27d0c6a5780b97c
> "lis3lv02d: make regulator API usage unconditional"

> CCing everybody who signed off that commit. When I reverted that=20
> commit on top of 3.8-rc3, lis3lv02d working without problem.

> It looks like driver is trying to use some regulator, but there=20
> is nothing defined for RX-51.

> Any idea what to do?

It would be helpful to provide some more detailed information on the
problem you are seeing than "the probe is failing".  Are there any error
messages or other indications as to where in the probe the error occurs?

--B4IIlcmfBL/1gGOG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRIQRrAAoJELSic+t+oim9AEAP/3VppxyYF25HD0gXSbr5IwMp
+kw63+JZ+kkS7VcLsAd1aN7J45t+5PU0DLwc6KSXXPCZ+dzafD2/EYMbZDa76zat
XS+LiWZSqu9u4D62+3oyDiwDVtcCxGm4A+pXLpzSEHyLA5X8WPJSZUMHa5RvYpPb
dVWJpQ5Ee1CXtsUqv6li+6VLR84zgfKU9kHVAxGMbWChgvBDOokK9dyF6qsGCp0o
88Ogzs4Au6eGMalQIqhkADxbjBL71sCeMk200fi4vUL0uWDRkLMBem5JBezCElQZ
BcUoQ/wEG7YW+gmVX7/4Cwa9QRKRBAGBvaWRoufFl+emPODakPysIPyei62ImEUX
b+kj5464GEOiFzBnwBj+8t/JPwVNZEm49ocBcsM5x20yyHG6Fv1eS9a5k9F0eTGQ
9J4V8s50GiAo0hEp3L7FvHoBiJzghzOlIwubHyedO2CJn3WPi6uxktx38upx90l2
Xtquu0HV5ZdHHbmDZIrCIMFQPejFgKWt6K21+8Sw2f8k0unT8R4ZTxLsF7sTUmBB
t0lONlNl/mI6P7+ouk+eVrI7jcQU7+3uJ4g5HaCj9Tf0zXu6xsfmQJ4fFfJP80Ia
74lNeGs+lYzgJYrxu2FNh8539JMdVVioJeITIwm7AwHfqPif14GVniS4rv8QeC4B
qUzRAub1/beBGFGNcpEm
=l8oo
-----END PGP SIGNATURE-----

--B4IIlcmfBL/1gGOG--

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752280Ab3HPFsb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 01:48:31 -0400
Received: from ozlabs.org ([203.10.76.45]:44362 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751420Ab3HPFs3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 01:48:29 -0400
Date: Fri, 16 Aug 2013 15:48:24 +1000
From: Tony Breeds <tony@bakeyournoodle.com>
To: Max Filippov <jcmvbkbc@gmail.com>
Cc: Guenter Roeck <linux@roeck-us.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Linux kernel cross-compilers
Message-ID: <20130816054823.GB28445@thor.bakeyournoodle.com>
Mail-Followup-To: Max Filippov <jcmvbkbc@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <520C9A39.3030808@roeck-us.net>
 <CAMo8BfKyqZYMkh96wyZSpYUpXwqFQZkco=XgtjUrNG-jSzW5pA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="KFztAG8eRSV9hGtP"
Content-Disposition: inline
In-Reply-To: <CAMo8BfKyqZYMkh96wyZSpYUpXwqFQZkco=XgtjUrNG-jSzW5pA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--KFztAG8eRSV9hGtP
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 15, 2013 at 01:46:16PM +0400, Max Filippov wrote:
=20
> Yes, xtensa compiler/linker is known to have issues with link-time
> relaxation; e.g. it may fail to build linux image without CONFIG_LD_NO_RE=
LAX.

Is there something I can do at linker build time to help with this?

Yours Tony

--KFztAG8eRSV9hGtP
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)

iQIcBAEBCAAGBQJSDb0nAAoJEEsCiJRY75GKid4QAJKu2msnt+D3sru/Bz+7jtVz
T/q6BtbX6rSupQsNxgRS23R9gv/1MNeDZNCO5Fq2tAPNICjkXGnNb6G1QzLSr57Y
Zzj/fxhjkfSb4oQvAb6Bf1JoGr9XUWcog1TivUvtjKIQZn/d0KAl/qT/h7I1NBDl
1y4qJVwzp90tAwgmcsdzQrPrLT0tsUHEmRiNSvFlHOsqz82scCLVFjUeZWsrdyDM
38uI07MsmtRgtjBVswspYJz8JC4ujuL/lxpVoP9DEeUbN1WIlIpU4MSHZ+kn4+G4
PKiP0obLZQmIm/NbgLUqwQpKGHoij7C74vxoQQyFnpWHSd3lyF5I0VmueoBv0og9
4xZpZB98KHOTh4BARAi+0dNFqoaPQTx5/HTWB6aEUq7Vq4ukoQiPISY9ZhSGZX6t
mGcTUIb5APwtqXnjOhZyUePb3KGPxBTLWMankHBGrVSusGKjyGF00Uttrv61q6vI
4uQJQgQR4JqSMBSptxnrAKhP8VnBuQfqCE89ugtWqFpU5y/RSE+9n09q/a6BDZ7o
DOqdlcIt2NTM5o+kyNtoVBaYyyW5vqmEv85MQrHQWsNCkSaKWP5exosz+1p03BdY
JbipqhHvYf6O4D6T0LTRB9L/u6JtYb8V40cW10NBpbv3zlgDlrhig0EjBMD/ehEW
SwpbU+rYpFIKd6Hw19RO
=TUmP
-----END PGP SIGNATURE-----

--KFztAG8eRSV9hGtP--

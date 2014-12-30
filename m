Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752074AbaL3B5P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 20:57:15 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:37231 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751807AbaL3B5O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 20:57:14 -0500
Message-ID: <1419904618.5686.34.camel@decadent.org.uk>
Subject: Re: [PATCH 3.2 00/27] 3.2.66-rc1 review
From: Ben Hutchings <ben@decadent.org.uk>
To: Satoru Takeuchi <satoru.takeuchi@gmail.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, Guenter Roeck <linux@roeck-us.net>,
        Phil Jensen <pjensen@evernote.com>, akpm@linux-foundation.org
Date: Tue, 30 Dec 2014 02:56:58 +0100
In-Reply-To: <87d272q8xc.wl-satoru.takeuchi@gmail.com>
References: <lsq.1419815490.288081487@decadent.org.uk>
	 <87d272q8xc.wl-satoru.takeuchi@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-X6T0Ez4RqOq1SFKwMPrm"
X-Mailer: Evolution 3.12.9-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 46.189.28.191
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-X6T0Ez4RqOq1SFKwMPrm
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2014-12-30 at 09:26 +0900, Satoru Takeuchi wrote:
> At Mon, 29 Dec 2014 02:11:30 +0100,
> Ben Hutchings wrote:
> >=20
> > This is the start of the stable review cycle for the 3.2.66 release.
> > There are 27 patches in this series, which will be posted as responses
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >=20
> > Responses should be made by Wed Dec 31 12:00:00 UTC 2014.
> > Anything received after that time might be too late.
>=20
> This kernel passed my test.
>=20
>  - Test Cases:
>    - Build this kernel.
>    - Boot this kernel.
>    - Build the latest mainline kernel with this kernel.
>=20
>  - Test Tool:
>    https://github.com/satoru-takeuchi/test-linux-stable
>=20
>  - Test Result (kernel .config, ktest config and test log):
>    http://satoru-takeuchi.org/test-linux-stable/results/<version>-<test d=
atetime>.tar.xz
>=20
>  - Build Environment:
>    - OS: Debian Jessy x86_64
>    - CPU: Intel(R) Core(TM) i5-2400 CPU @ 3.10GHz x 4
>    - memory: 8GB
>=20
>  - Test Target Environment:
>    - Debian Jessy x86_64 (KVM guest on the Build Environment)
>    - # of vCPU: 2
>    - memory: 2GB

Thanks for testing.

Ben.

--=20
Ben Hutchings
It is easier to write an incorrect program than to understand a correct one=
.

--=-X6T0Ez4RqOq1SFKwMPrm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUAVKIGb+e/yOyVhhEJAQr1nQ//TD3EGVjjtUASaUvhTdQBmdxpQeovpBOy
lSbHcC0X8gP3vYu+qrR7zJJVZ5QZ94u4ulhicy1ejErK/J6qL88KZc05hSEXD3vE
q8q0NG3FG0lpIgpWAMhRrgNizrpwqt4kxYvbo+O8pOtQDWd0AsqXSXxR1LOnXsRd
86iI0g//xXgXEFEsyciQ3+CxtOEHVHpwM0vSXFdS1FeP4aOhg8N8XX/RhZ9gt1qv
1+XPLHNkms99H5Qghg4VTIu5F+9ntuZuiz1x3VicoXIWMPP6dZCqCCfYQAvpugZb
l8neKlgpu3cKPoTLRvUFNxjGrEmn4f6fz0w522z0xJEJRN0JY+lP3Jq2jBL9cfKn
ZSpTojQFUkhrQvYGxHuTl9lEu2v3T4SbBg+i82oeH3CS/Oz/A2eTPE+1eTq0nVK/
z92blz1fVbqPWKn4hVQ72E1KvgERz+lh8GSPYGmh3yMOO6boKVtbx4/De3kVTJkx
lVIgwo1N7u/7rUTOARCG4Tkh3j6KAYXLuaWBTqmVq0c5PLF5KbJ7uyXOtbHWxrBq
MjjUp7GKfRE8Tq7TInyqYHNOOyJeGKH6PynTYMpGnsRsa++kr85yc7bfw4dZ6P80
y++loDtEuA4n8KXm3w0ovK+AEFmkBwD4BLTZvWUn33wxakJP8bJToLGzpFIQSsZP
r7JOHvtanuU=
=hOZi
-----END PGP SIGNATURE-----

--=-X6T0Ez4RqOq1SFKwMPrm--

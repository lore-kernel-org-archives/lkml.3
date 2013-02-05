Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755566Ab3BEDqV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 22:46:21 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:48961 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751151Ab3BEDqT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 22:46:19 -0500
Message-ID: <1360035964.32217.9.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [ 105/128] efi: Make efi_enabled a function to query EFI
 facilities
From: Ben Hutchings <ben@decadent.org.uk>
To: Matt Fleming <matt.fleming@intel.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        akpm@linux-foundation.org, David Airlie <airlied@linux.ie>,
        Corentin Chary <corentincj@iksaif.net>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Dave Jiang <dave.jiang@intel.com>, Olof Johansson <olof@lixom.net>,
        Peter Jones <pjones@redhat.com>,
        Colin Ian King <colin.king@canonical.com>,
        Steve Langasek <steve.langasek@canonical.com>,
        Tony Luck <tony.luck@intel.com>,
        Konrad Rzeszutek Wilk <konrad@kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Date: Tue, 05 Feb 2013 03:46:04 +0000
In-Reply-To: <1359996265.7515.180.camel@mfleming-mobl1.ger.corp.intel.com>
References: <20130203144653.313760856@decadent.org.uk>
	 <1359904557.1822.2.camel@deadeye.wl.decadent.org.uk>
	 <1359996265.7515.180.camel@mfleming-mobl1.ger.corp.intel.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-Bhpj3zX60jyK6cNdJG7C"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a11:96ff:fec6:70c4
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Bhpj3zX60jyK6cNdJG7C
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2013-02-04 at 16:44 +0000, Matt Fleming wrote:
> On Sun, 2013-02-03 at 16:15 +0100, Ben Hutchings wrote:
> > As you can see this needed quite a lot of work to backport, and I
> > haven't been able to test it yet.  So I would particularly appreciate
> > careful review of this.
>=20
> Everything looks fine to me but I haven't actually booted with these
> changes.

Thanks.  I've now tested this on a 64-bit EFI system myself:

x86_64 kernel build:
- Boots successfully
- x86_efi_facilities =3D 0x3f
- efifb works
- efivars can be loaded and creates /sys/firmware/efi/vars

i386 kernel build:
- Boots as far as an initramfs shell, but the machine doesn't have an
i386 installation to continue with
- x86_efi_facilities =3D 0x21
- efifb works
- efivars can be loaded but does nothing

All of which I think is correct.

Ben.

--=20
Ben Hutchings
Everything should be made as simple as possible, but not simpler.
                                                           - Albert Einstei=
n

--=-Bhpj3zX60jyK6cNdJG7C
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAURCAfOe/yOyVhhEJAQqo1xAAi1LyVScMTjypjN9IkqJsq7eJbuV6l7Pb
Odv3Xoy2SqJsh3bHEfAI+Zcf+CHGEXC5BK6thdAXgZ6lq7QdVRNHgQKHaidke8PZ
hgAqb9y/pa5UCA3GLzqqwLgVhZ2lQ5mPM+Ilvn94eqzy44iebb+jI6Jwvyovw5xd
e2OIsi/VlQe5cBKQIZ63m8Z5A0M3OgRi4041mhxVQtgNeHBBbiry1W8t7aGIQnn1
kPnMCVIEaymsyfVSXSQusRb8QIcX7ZwPbb6rQFVWlQ5mZTokkVaoxb6SSVT0BTgf
jENeXjL6OWWtDDOq8lcDcB//D0xVMtnIWgV/7JzS5y2F9jVSxv/5Gt/7rDQaIw98
cyg9isvvg5OvLap+zc7f8qcg1xegll35HfcGYdFpacCt8+impLnRwL8U4swApJRe
rOAWhIGN1qOGyTj5DG7k5ccW77sIbNVciB5RqcMxhIhl0JoGP4kBhg7tZBji/SUz
StYE3M5Bp4dALzV3v9iOlXcA7ntdqJEJsIBRo9nytcvHk4YUYoHMnTeOLepgiPJy
t3lcvN+dBW3GYKmjoEIBm9j1bnn6JxN+D3gUx09jC6109fu73UDmBXhweoOH87Yl
uM60lE5Q/Mizzu1Yt65Z5fd3ivAgAHCQt56iWscaxgwiS5Kl7tXXz3TOvuY8z97h
cDXZyfz7xRk=
=3rpP
-----END PGP SIGNATURE-----

--=-Bhpj3zX60jyK6cNdJG7C--

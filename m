Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932823AbaHFRHG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 13:07:06 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:35475 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756428AbaHFRHD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 13:07:03 -0400
Message-ID: <1407344808.8341.45.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH 3.2 00/94] 3.2.62-rc1 review
From: Ben Hutchings <ben@decadent.org.uk>
To: Satoru Takeuchi <satoru.takeuchi@gmail.com>
Cc: Guenter Roeck <linux@roeck-us.net>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
Date: Wed, 06 Aug 2014 18:06:48 +0100
In-Reply-To: <87lhr192dc.wl%satoru.takeuchi@gmail.com>
References: <lsq.1407170911.107020799@decadent.org.uk>
	 <20140804175544.GA7631@roeck-us.net>
	 <87lhr192dc.wl%satoru.takeuchi@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-8F7GjHV0sQgly8rhlG+k"
X-Mailer: Evolution 3.12.2-1+b1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-8F7GjHV0sQgly8rhlG+k
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2014-08-06 at 22:25 +0900, Satoru Takeuchi wrote:
> At Mon, 4 Aug 2014 10:55:44 -0700,
> Guenter Roeck wrote:
> >=20
> > On Mon, Aug 04, 2014 at 05:48:31PM +0100, Ben Hutchings wrote:
> > > This is the start of the stable review cycle for the 3.2.62 release.
> > > There are 94 patches in this series, which will be posted as response=
s
> > > to this one.  If anyone has any issues with these being applied, plea=
se
> > > let me know.
> > >=20
> > > Responses should be made by Wed Aug 06 17:00:00 UTC 2014.
> > > Anything received after that time might be too late.
> > >=20
> > Build results:
> > 	total: 111 pass: 105 fail: 6
> > Failed builds:
> > 	microblaze:mmu_defconfig
> > 	microblaze:nommu_defconfig
> > 	mips:allmodconfig
> > 	sparc64:allmodconfig
> > 	xtensa:defconfig
> > 	xtensa:allmodconfig
> >=20
> > Qemu tests all passed.
> >=20
> > This is a significant improvement over the previous versions, where we =
used
> > to see up to 10 build failures. The previously failing builds for unico=
re32
> > and score now pass, as well as alpha:allmodconfig.
> >=20
> > Note that I rearranged arm builds to improve test coverage.
> >=20
> > Details are available at http://server.roeck-us.net:8010/builders.
> >=20
> > Guenter
>=20
> This kernel passed my test.

Thanks for testing!

Ben.

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
>=20
> Thanks,
> Satoru

--=20
Ben Hutchings
To err is human; to really foul things up requires a computer.

--=-8F7GjHV0sQgly8rhlG+k
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUAU+Jgrue/yOyVhhEJAQpEgA//Uz5M2S6Auc6dyz+7NDRCZdPxDVQj0obu
lMuHQcuqq5Z1SVbsZ4vvUI6ZA15wcc/lTGzDKFslcAIFEsljVnp9wNz0omYZYmgJ
4tsCmirnlzrv3Miq8n6okU+QfvRwsyTw5LqH4w2FDQrcMEzfAwQvfSPBn6304o+L
w1pZZWJyaWnQ6dm+dCWL7qK1v7AXhkIJNMiWQjjeWBIvjhzWQsjE8KWz/hdpnkrU
9BMBFWxd4p+8kfHODX5fTFws5fIuq3++YNjOLZf7NuCjZcnlbZQt5avDofayExSg
FQr+Qs41UCuLgqAOxZOAiDxrndP/KWuJ4llUso39fM8Z0LQVxhneolpa41928Tvc
bmtuwXXBEPINN2UdGVyfuQFfy12IV2os2jUbxmKXLqVEEC4u8YDAnBqbimvXEyjs
zcOB4lvrTB6tvRGeAO8I/mfMlncjpvVey1UBcqovuuu5WUHo+X6UKsQ4tLPTq7Nt
msb9ZEmMzToi2WrcuT0VfVXJqlULYNqUHJyc+K4LL9eIGG0IkSb78m6LhHHZVWdV
Hjo/ia3HA0cbXUk0ceYQVy794Qzx9QsXhfzAhm92i+LtqwKr2fmKdUXCfMRwuveJ
NVAxjRB+UvVQkrzy+A7DdqFvOtcc0dvwvl8ij+aLDWDlpSrGxYDtSwB9hqin8aR8
cOSdtrgIXgc=
=pJDw
-----END PGP SIGNATURE-----

--=-8F7GjHV0sQgly8rhlG+k--

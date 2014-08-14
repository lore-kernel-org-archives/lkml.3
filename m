Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754585AbaHNUwM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 16:52:12 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:51617 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752498AbaHNUwK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 16:52:10 -0400
Date: Thu, 14 Aug 2014 22:51:43 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Ashwin Chaugule <ashwin.chaugule@linaro.org>
Cc: linux-kernel@vger.kernel.org, catalin.marinas@arm.com,
        mike.turquette@linaro.org, morten.rasmussen@arm.com,
        arjan@linux.intel.com, mingo@kernel.org, len.brown@intel.com,
        rjw@rjwysocki.net, linaro-acpi@lists.linaro.org, arnd@arndb.de,
        linux-acpi@vger.kernel.org, cpufreq@vger.kernel.org,
        patches@linaro.org
Subject: Re: [RFC 0/3] Experimental patchset for CPPC
Message-ID: <20140814205143.GY6758@twins.programming.kicks-ass.net>
References: <1408046230-16439-1-git-send-email-ashwin.chaugule@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PC0PHm7MMXIrr506"
Content-Disposition: inline
In-Reply-To: <1408046230-16439-1-git-send-email-ashwin.chaugule@linaro.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--PC0PHm7MMXIrr506
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 14, 2014 at 03:57:07PM -0400, Ashwin Chaugule wrote:
>=20
>=20
> What is CPPC:
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>=20
> CPPC is the new interface for CPU performance control between the OS and =
the
> platform defined in ACPI 5.0+. The interface is built on an abstract
> representation of CPU performance rather than raw frequency.  Basic opera=
tion
> consists of:

Why do we want this? Typically we've ignored ACPI and gone straight to
MSR access, intel_pstate and intel_idle were created especially to avoid
ACPI, so why return to it.

Also, the whole interface sounds like trainwreck (one would not expect
anything else from ACPI).

So _why_?

--PC0PHm7MMXIrr506
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJT7SFfAAoJEHZH4aRLwOS6JDMP/A+qgY83dqBOG/f2GSj6cUpF
TL2HoAN4wNrXHf0Qs5IfCto7a68mRw7ghvvKe7szpFZL9Sh/UkOyZHjHqrE50ZDQ
Zjs2JWXyoJN0bwH4pVfDgAUDymzUPc0uhX06iQ6OYk/OoOnIs+TiUONg/jDlEPmQ
IL7dNd8+tgsZfKQ/s7LmkA7RN6f3Xqd2Npsm3tdA3XDzwG9UuNvlAC1DzOy5xEZm
vEeG3zhMHmPLzrHwN9DoE4qIPQwC70XM4qvM4AwIXDmJbWtQM2zjGjNm8FbyMxPY
ggY5aONzLuymsHTA7HiVzgleR5Nvl5pvhyiEB0WDbayaTuhEgNoBE+cxBId0GL+E
0/JttU2wJ3KJMqoIlkfwWkosOfcjLfXqKItTtcgh8w4NVn1wpufImH0AmN4onQ30
U4+G0D/pzUz6SV2BJfXyBrvlYvjmPpRIur3dkBAfRvIDPPL2ofmiDkOKHqeOp/SF
loLqJ+X4FTMkUqFfvzSxokWCyS489EIC+vPdxAgCmx+qQ81iCai/hVSxm17C0VxT
nebeKszuhV8964e/5QCV9TQ7JRJcSAOzb/YflNbd4uSmReTrAjUpRPSlrW/88DRI
5TGFaBZ78n9VA5XflcXSv6i4ybV1iDGPTYqkBIOi/+HZHL7swnXcal0Bdso+OJW4
/ygZfv+7UuaT/jHB5Mil
=maYp
-----END PGP SIGNATURE-----

--PC0PHm7MMXIrr506--

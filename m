Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755406Ab3JaQNA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 12:13:00 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43960 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752032Ab3JaQM6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 12:12:58 -0400
Message-ID: <1383235969.7651.42.camel@fourier>
Subject: Re: [PATCH 0/4] ACPICA: Stable material of ACPI executer fixes for
 linux-3.8.
From: Kamal Mostafa <kamal@canonical.com>
To: Lv Zheng <lv.zheng@intel.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Bob Moore <robert.moore@intel.com>
Date: Thu, 31 Oct 2013 09:12:49 -0700
In-Reply-To: <cover.1383181113.git.lv.zheng@intel.com>
References: <cover.1383181113.git.lv.zheng@intel.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-o6TH7ILyAIjnDe1vXfJ1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-o6TH7ILyAIjnDe1vXfJ1
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2013-10-31 at 09:07 +0800, Lv Zheng wrote:
> There are bug-fixes for AML interpreter upstreamed, fixing some serious
> issues found in recent platforms.  These fixes make Linux AML interpreter
> more ACPI 2.0 ASL concept compliant.  Further AML interpreter fixes shoul=
d
> be based on such improvements, thus they are good materials for stable.
>=20
> This patch set can be safely applied to linux-3.8:
> commit 19f949f52599ba7c3f67a5897ac6be14bfcb1200 upstream.
>=20
> The patch set has passed build/boot tests on the following machines:
>   Dell Inspiron Mini 1010 (i386)
>   HP Compaq 8200 Elite SFF PC (x86-64)
>=20
> Bob Moore (4):
>   ACPICA: Interpreter: Fix Store() when implicit conversion is not
>     possible.
>   ACPICA: DeRefOf operator: Update to fully resolve FieldUnit and
>     BufferField refs.
>   ACPICA: Return error if DerefOf resolves to a null package element.
>   ACPICA: Fix for a Store->ArgX when ArgX contains a reference to a
>     field.
>=20
>  drivers/acpi/acpica/exoparg1.c |   48 +++++++++++--
>  drivers/acpi/acpica/exstore.c  |  151 +++++++++++++++++++++++++++-------=
------
>  2 files changed, 146 insertions(+), 53 deletions(-)
>=20
> Cc: Bob Moore <robert.moore@intel.com>


OK, I'm queuing these up for 3.8-stable (they'll appear in v3.8.13.13).
Thanks very much Lv, Rafael, and Bob.

 -Kamal


--=-o6TH7ILyAIjnDe1vXfJ1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABCAAGBQJScoGBAAoJEHqwmdxYrXhZV3YP/1ZTnpdv4IB7+580zcFtWqLx
hzrZTZOaBrnGrFZnpX+o3Vx2qtWLl/iV7n29h4knXQJENSZtjSSE+n4n/9c9YcEg
VSL/M77IOUER0p9JdVHeuiVRxZ1LlkiLrdJ+a51kp6Not/M5zS9QnkzrK+dpsISV
p1Xppp2R+XsYk2D3qQTj3G3B5Dk40ir9vj0o2H2j6qU3u2CTVfx6y4O3AEv79gPo
l94f6aF7dZ9RHfYqbtmFPwp4ryGZPg/UL5+y+Wb1P8lYUcNGhhLxc1f9kpfoAFrb
GPxIFILSzqC51hd6L5TWcta4aLgJ7DWrU63/t/B/LJUegrc4K/fdcniwIpIe+j+S
ymMgFP50UosJYPce0u7dVxM3R95Tsx5U8f6duih0qydJfbulPZDmfpfQ8M3fYJ5l
prXtHU9qnRsDdpekOYTwg+ppxM93toUPgGq2LhbBnWV/3QA4uG/3RrLxIl20bd4F
NzN1x2ctGHqcVPnmJWuR/xYEEE76AgJ9vyB6KH3joGPfuXUubLfkCoEce2/47xGJ
D8wwLMbrTj/7cdTOzegDTSS8B4UoDiNPVHDfY5RfLKdVTFItFuWtb9orRg/h+ETi
WDV3pUF2Wz5MVdjm+vZfpy3g0OS1P/jnS1qmml5iqwfle4caITgwetncqa907Egr
41Np7kt0XHEp8Kj6/s9q
=oaar
-----END PGP SIGNATURE-----

--=-o6TH7ILyAIjnDe1vXfJ1--


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753858AbaIXVFH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 17:05:07 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:65017 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751184AbaIXVFB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 17:05:01 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: Peter Huewe <peterhuewe@gmx.de>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-i2c@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [REGRESSION] i2c-acpi: Fix NULL Pointer dereference
Date: Wed, 24 Sep 2014 23:24:43 +0200
Message-ID: <2180819.4Kky9hrQa3@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140924210216.GA1291@katana>
References: <1410548987-3558-1-git-send-email-peterhuewe@gmx.de> <1696265.yGhHYgE97A@vostro.rjw.lan> <20140924210216.GA1291@katana>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart2079531.6bda5nDA8r"; micalg="pgp-sha256"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nextPart2079531.6bda5nDA8r
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

On Wednesday, September 24, 2014 11:02:16 PM Wolfram Sang wrote:
> On Wed, Sep 24, 2014 at 11:06:24PM +0200, Rafael J. Wysocki wrote:
> > Hi Wolfram,
> >=20
> > Do you want me to take care of this or are you going to handle it?
> >=20
> > It has been ACKed by Mika already: https://patchwork.kernel.org/pat=
ch/4897751/
>=20
> I am going to handle it. i2c-acpi is being reworked, currently. Just
> waiting for some testbot results.

Cool, thanks!

I'm dropping it from my TODO list, then.

=2D-=20
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
--nextPart2079531.6bda5nDA8r
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAABCAAGBQJUIzagAAoJEILEb/54YlRxwxwP/ApwZ5uqq092+9YVZBFl+vUt
gi1E+vNVMtCulx5IzCPiG53PTYWnFhMbQP3WEfikcXkGaT59ZggZXAfUlS6AW4VG
5WZ2TShcL5DlGZDtaxn6bK5+SUfvBUfzMvpOwWQmTReUDqbrY9j6ccsjkbX3p60y
rXWSgdBT/dtpvxZqyEau3IhHS4tKOOJ6Yv6itXSh6+lctN5WgZaW8IhtlJ404+yE
sgLj0fRMRSNfcVbaaV1MZZqqnQrUOfyXEpaBIinZuCtICkk0sbn0JDcPzprIwZcX
Ed5i7rqSQQe2bUmbQRDNWDiIyIY0Ja9u37+AuB7MPnugICO5fRb6ZKUPjxZBjEHl
04OjfdHMszuFy9hGSP8HJ4MwKweHXD72v3DulP1xxzlJOFffSEJKmiEA+vqm0m7B
KW/STpvyj7MvVEnHQgS1Qomb5qm9+np5HkllZHtOGPno4L0/5yRxNhr2GqsXNHhy
95GFR2aRjLhTsWZZN+lSsdtQK/1jgLj0mIK0HeyUuTUqwOgfTE4/CjCUaoeZkJ6b
IlSqYDh6YFHmxQZW5byxRHo//10MZzR8ySpEJu+kSYo+c1svbIbLd72iW7d9ufOD
uskNtOrL04TzhxRGsTMgCG3y/uTpUxzScCLRvLetlHyyrbtcBbSNU1vxm+Bh9xbP
0fEMWfZyNHHaref3Llzf
=PtGu
-----END PGP SIGNATURE-----

--nextPart2079531.6bda5nDA8r--


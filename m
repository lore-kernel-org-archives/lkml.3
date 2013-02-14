Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932345Ab3BNGxU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 01:53:20 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:54908 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755756Ab3BNGxT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 01:53:19 -0500
Date: Thu, 14 Feb 2013 07:52:56 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Rob Herring <rob.herring@calxeda.com>,
        Andrew Murray <andrew.murray@arm.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] of/pci: Add of_pci_get_bus() function
Message-ID: <20130214065256.GC29588@avionic-0098.mockup.avionic-design.de>
References: <1360570940-17086-1-git-send-email-thierry.reding@avionic-design.de>
 <1360570940-17086-4-git-send-email-thierry.reding@avionic-design.de>
 <20130213225607.B31223E3557@localhost>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="uXxzq0nDebZQVNAZ"
Content-Disposition: inline
In-Reply-To: <20130213225607.B31223E3557@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:MKavqk8iZFi+NAWdup0k6SldAgh6I0q2Zo7e4RWiqpl
 f2uUFBe+r0InZcnT3e9+m6iaD9iNuKmIlo1oqyFkJw43pt9/nc
 zSKt6aQ3AM2rOaNFnwYkDanODylVvyu03qy4pIuMDbLhIncTnd
 097NYM3nqitW31vipCwZE5FajF5r5YgEOfb2YK2I0FDOm+pkU5
 ksh5lJ0QWbSwyQThejeW61iT26os17rsmn4lZS7CQ++v5CpmEj
 llxHMtJrYYnRItFYxdr4djTQfd/xtgvcWOHFaW6eC8Lq/Y22FF
 HZN+v/gc2Dzc9Z6149G0FZFtWQjETMVhG20fzCGyHcVaomkzSL
 LdVI+lUFbcjibHriaxEw5+lH+PaDsmxVWXAWwULVkWSoySXP7Z
 ynQmVVgb7/Cmpl5EfJtLAkDTSL4u1j+6/Q=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--uXxzq0nDebZQVNAZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 13, 2013 at 10:56:07PM +0000, Grant Likely wrote:
> On Mon, 11 Feb 2013 09:22:19 +0100, Thierry Reding <thierry.reding@avioni=
c-design.de> wrote:
> > This function can be used to parse the number of a device's parent PCI
> > bus from a standard 5-cell PCI resource.
> >=20
> > Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
>=20
> This patch should be deferred until there is another patch in the same
> series that actually uses it.

And this one too.

Thierry

--uXxzq0nDebZQVNAZ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRHInIAAoJEN0jrNd/PrOhiDUQAK75FTtBprvcNjho1Izwk/Tl
kmEiFMfHUAhOAyDB1TyZGma7Afwzu7pGSTEMDOP+Y5ce+QiPzzFldFOMqdHXekX9
T5ewjrGSk2PulEIVFJ0K+pYzkG3eSUbiFomAAHTDXiWTMBucB1vjE2NZBeRZfy6g
b3CILSN8u1qkntiJpAmrEsDDUFtSBR0ryDLQSVsvkEjoDikArGtU78o5gW4iCBrg
VWlOjmLIqZxf4Y9uJh5xhjIzw7eUiT2Fr1bo4OIhEKMMrwe9n04WUDFBtD7HI78e
xSFcuIiOJnNHXPK4aVe4q6FMKM5j+hVtd2lbrOdUf6n7CrxMQHIFJv5qATsYmfxp
qWmebLNwy/xTi1YUm8JKhMVY60KnOfb8sKTqzUq2wYsMZTSP41+O1opuzIoJK5bk
tM7n+q2P9NLf0GocQLWbxg7Nu+BZxMeMYdoNNaK8oVIxoeDuHHURXcOjOMEQCY7R
6G5lhlTujKVsb7ummgTHpf/iKlfkyXLzTyWXHziqEIsBQyZyEp2EMJGjkkTxmzQI
Xg0A4l5a6L4pitLaIqgSaBvEwUxvrmJ3cZujH8c7z6RcdYpU6BSV0h3Y8bcTgIH9
WQ8PZdFxX/fpzaxo0REHp/Tv0gD57RAAclwG+J5fJWOhJGVlr1nGPHRl+3ckMPx6
Cjz+ADG4kQPJFAJNz8dQ
=Qni0
-----END PGP SIGNATURE-----

--uXxzq0nDebZQVNAZ--

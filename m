Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754330Ab3ITJSI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 05:18:08 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:48479 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754148Ab3ITJSF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 05:18:05 -0400
Message-ID: <523C12C7.60002@ti.com>
Date: Fri, 20 Sep 2013 12:17:59 +0300
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
CC: <linux-fbdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] radeon: Conditionally compile PM code
References: <1379508512-30155-1-git-send-email-treding@nvidia.com>
In-Reply-To: <1379508512-30155-1-git-send-email-treding@nvidia.com>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="fgoo0FikkwDbb3jv7GmBU8vfcO2RmALqG"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--fgoo0FikkwDbb3jv7GmBU8vfcO2RmALqG
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 18/09/13 15:48, Thierry Reding wrote:
> The power management code is only used on X86 and PowerMac. To prevent
> the compiler from warning about unused code, only build when PM and one=

> of X86 or PowerMac is selected.
>=20
> Signed-off-by: Thierry Reding <treding@nvidia.com>

Thanks, applied for 3.13.

 Tomi



--fgoo0FikkwDbb3jv7GmBU8vfcO2RmALqG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJSPBLHAAoJEPo9qoy8lh71/2EQAIV7f1phQ62jF9m7k4xF8rzq
BFvKSY8mySr/W6Af6HfMYx6+ETccNo2RsyxPKoztJdtGoIJ4rPjXTK+t3eGAUHKh
CoRZFMnrdnDRyqsLQfxEVWWxUAk7r8FdVr3dlmtNEw2D2Jc2+MSbRdm7diBgxBdJ
Wdw7G5Nvq7PTePxbrmkHX0ZBKM57+EoFne94ddvSPXEPeAUzN7EJiQ3LO143k/t5
heyLmH2o7Il/7m4JMQ0bjiPWNr9HvlscrMtN5IV/l1pGTBWdVC/l/XqNUZW18lfl
NukNX1juHAX3KsAGaqkWjbcoPAwlSLMt9OdBpmXMLMvfXBlEqupjd8Qpel6Fasxo
SGD4WpooXiEwovgLoQr+g8QTd+Fjya1UqX3BeTPfMTCVK61TlANMJ+i4QjLf0Ld+
A0aHAvCkKoJT81rjb/e5xBC7xcVnvB2u4CukObBbKfP4RKGgFEjMqRBLJLJhaA4h
wmD1gnEZXxPNM8kO3KYdxbvjO98dI6QeRaCfzBDEzTW3Tr3ePlFtCW75EVhYU0mm
f3RyyZzkueMLQr1ztQ1J9sRiXHyheeyRHKW6l3ggM1LVXf8Blz3p2jsaKMdoNJ9s
TVYZMeK0zFjqOTmbCTW5aJ0ETgJbBMBLpSOEtk95WmXMukqgNkxe9t0zvLfaxWvD
yDdPRRP3p3SPvw7fmErb
=Lb/F
-----END PGP SIGNATURE-----

--fgoo0FikkwDbb3jv7GmBU8vfcO2RmALqG--

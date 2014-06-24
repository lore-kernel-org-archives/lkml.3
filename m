Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752794AbaFXH4W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 03:56:22 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:41943 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751365AbaFXH4S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 03:56:18 -0400
Message-ID: <53A92F15.9010702@ti.com>
Date: Tue, 24 Jun 2014 10:56:05 +0300
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Julia Lawall <julia.lawall@lip6.fr>
CC: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        <kernel-janitors@vger.kernel.org>, <linux-fbdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/10] video: use safer test on the result of find_first_zero_bit
References: <1401872880-23685-1-git-send-email-Julia.Lawall@lip6.fr> <1401872880-23685-4-git-send-email-Julia.Lawall@lip6.fr> <53A81470.5030606@ti.com> <alpine.DEB.2.10.1406231612030.3905@hadrien>
In-Reply-To: <alpine.DEB.2.10.1406231612030.3905@hadrien>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="vE5cpRCgTAnt0HDL7MwbsMIcwxd01BGIK"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--vE5cpRCgTAnt0HDL7MwbsMIcwxd01BGIK
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 23/06/14 17:12, Julia Lawall wrote:
> On Mon, 23 Jun 2014, Tomi Valkeinen wrote:
>=20
>> On 04/06/14 12:07, Julia Lawall wrote:
>>> From: Julia Lawall <Julia.Lawall@lip6.fr>
>>>
>>> Find_first_zero_bit considers BITS_PER_LONG bits at a time, and thus =
may
>>> return a larger number than the maximum position argument if that pos=
ition
>>> is not a multiple of BITS_PER_LONG.
>>
>> Thanks, queued for 3.17.
>=20
> No, sorry you can drop it.  It doesn't hurt anything, but it is not
> necessary either.  Returning a larger number is actually not possible.

Ok, dropped.

 Tomi



--vE5cpRCgTAnt0HDL7MwbsMIcwxd01BGIK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTqS8ZAAoJEPo9qoy8lh71xiYP/iW1vUnUaBnyfUXEIrQ7roNl
J92NObRssndacXVHQA/m4EDVzc7qP8V+6uzbpgBQ7jYotnMJWgvzSCEde1eK8sFb
mEC0zQK1ogQ8s5EurCVcw7Rd8d/VR0VSeqPHwU7kwU+sUZO/5qSjAAARosBGLvUS
+m9xnpfejW5e80FjlL9Z6EWr7Yg1l0Dk8YKzfew8qT4aI3SDE13BexOWnDyZE6Qp
YymKE15+2S48UJAHB5+ha1JpLs0WnXShtWb8OF9kmujr7HUbAAowWF9tNtQ+xbWq
N3O/8gU2482HlsYKKGugXpPeOeNSSbK+LQ/r5FYOs2naPb5phRrrpohMpnNLi1q+
BSHvavNkb41C+YNcuS+Cf+ehi9e5b0ZhMJNFAfCBxuGQPf+3jQ1f4ZUsxWOVYJNi
USX3Cf95xCLAOzSjFTWyaMlwf5IOPFbRq2wOpXQMsIljJrBR1EXEn86h0tdAub1x
KbDmz7uBgnTGNXm29I5eGRAymn5zEU+SsBNf4i/Jm0ZC6dr8uv3WgUwYJ7olqQPI
zH/scqJ8VKJM3ATgeGNvncp56a7phCz6/wcHbQY17PdPr06A/TibwnaN/+5o56hQ
M/qOz435n2bYx0CdvDGqL3gGXQ2jaXczygsHiSEDv28THd4EqxbN7+Md402aTtl3
OTXbZaGpLuX8csAofx12
=gyZt
-----END PGP SIGNATURE-----

--vE5cpRCgTAnt0HDL7MwbsMIcwxd01BGIK--

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752055AbbAMMz4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 07:55:56 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:58320 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041AbbAMMzy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 07:55:54 -0500
Message-ID: <54B515D2.3050303@ti.com>
Date: Tue, 13 Jan 2015 14:55:46 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
CC: <linux-fbdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH resend] console/dummy: Move screen size selection from
 CPP to Kconfig
References: <1421093822-26761-1-git-send-email-geert@linux-m68k.org>
In-Reply-To: <1421093822-26761-1-git-send-email-geert@linux-m68k.org>
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="R486RKaKwCbvHdB40ngKKcregjOWIFRJV"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--R486RKaKwCbvHdB40ngKKcregjOWIFRJV
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 12/01/15 22:17, Geert Uytterhoeven wrote:
> PA-RISC already handled the dummy console screen size selection in
> Kconfig, so generalize this to other platforms.
>=20
> ARM keeps on using screen_info, which is filled in by
> platform-specific code, or from ATAGS.

Thanks, queued for 3.20.

 Tomi



--R486RKaKwCbvHdB40ngKKcregjOWIFRJV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUtRXSAAoJEPo9qoy8lh71jZIP/2Nhn5kO4Tk1hr5EJjdw0aJS
+T8GAP/meAcaE58VEUmv6TcZ8WbPU7r4RZRK+NT5eaNw6fa2QFq8+RR2rhHpvlru
LBzzGi5/i+r/5KRmMj9/AlbCWz6W5ANc+fgBLvfPadhOBIcTo1FzvN8iVs/8cXel
dhXgMTRDaMYu2bb7BFiinO5dfPbm4FNML+WfxypokmfANzfdLI+gMWO3N98+mGib
LHrEMX58KyiZoLzIapEz0FoWesz81sjEbqfqEToYvclL/mKEB+/u8jHhJNv9Uizn
mIUBLzigvkYLxOdc+HFuOI/u59+0UfmmU6kUbvYLqml5YxSZ0kq4p1Dkvp5W6rfU
0hym+dcULxPnzZSW35UohEWpzUd9mhpAn2DoodzQclTmRBhpQiQikXebKGFiGLJA
ivXQ6Bre55xrB/s5ySvYTiTzHua7JlmAr6iu1XrP4PWulof/cG5MletOFGB5GTdR
uDxGs11R6K8FaXABElLeCcvnp+NZX4gFgdwSu+C3tww9cAXHjNUER1lI4SGuDiFo
+ceWwE5uPywjo3eaYJ9deFLYp3hgX1G17Pt1CAJY63S7/1iVyEy8+vaXwts/neO+
789ZugX1BYug2Gx4wLfp6poUkDfn6clZQXTfEcsAmvFO9v3p279879iPNTkomzl2
sqFHOTmg+MzRYsj0H79V
=sevE
-----END PGP SIGNATURE-----

--R486RKaKwCbvHdB40ngKKcregjOWIFRJV--

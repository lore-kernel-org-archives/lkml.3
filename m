Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756588AbaCDHQE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 02:16:04 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:55176 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756574AbaCDHQC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 02:16:02 -0500
Date: Tue, 4 Mar 2014 15:15:55 +0800
From: Mark Brown <broonie@kernel.org>
To: Yibin Gong <yibin.gong@freescale.com>
Cc: "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-ID: <20140304071555.GB13126@sirena.org.uk>
References: <1393911933-25149-1-git-send-email-b38343@freescale.com>
 <20140304064642.GA13126@sirena.org.uk>
 <346e4e7976cf41f79c32484d93aaf06c@BLUPR03MB036.namprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GRPZ8SYKNexpdSJ7"
Content-Disposition: inline
In-Reply-To: <346e4e7976cf41f79c32484d93aaf06c@BLUPR03MB036.namprd03.prod.outlook.com>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 202.175.88.218
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2] regulator: pfuze100: add pfuze200 support
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--GRPZ8SYKNexpdSJ7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 04, 2014 at 07:00:26AM +0000, Yibin Gong wrote:

> 	Thanks for your reminding, PFUZE200 is currently validated on
> 	the same board(i.MX6Q Sabresd) which mounted with PFUZE100
> 	before. So the patch only adding driver level support to let
> 	others can easily add PFUZE200 support once they have the
> 	PFUZE200 board.=20

You've added a new compatible string to the driver, it's very important
that this is reflected in the binding document.

--GRPZ8SYKNexpdSJ7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTFX2oAAoJELSic+t+oim9sGwQAJg1JtKhMLDlX1lPqbiopnxx
87WgPJO8Dmqc2Gnoiwn8p+Uq07I/3eYPYmY09CAMHdvThAGoXj6dEixxl3t/Ia7D
PWGaljo1Ly7rtzBY9/DFxdsKMBFqGhEkTS/oT4g1b0+/zoCzaXD0jwMsmnGGRlDB
h/Uj5N3Tc9I63a32qYMvjz3N+/6e7AqLhWZn8QW0dx9RKOnsKGZY6hnzIcaXhB1U
t+eRf0ArBHWZw7b3AwrsHqmLuDqkbO/CItrZLW2D7at0FjmeWRaXMxEzDZ+cnxhV
GbRHBvdwnHrUy2Kq048OESh0Ww/fBDcttz4IueMmdjWVFMkIqqIbqQZcurf1wutf
en4f6xBdq/KGURsAuHurMlpK2SF+YDCc/4PLnhEFwhftSZ4Bd6RjxCxMNcRISZWK
NQYfAQbN9vVrX/BqhvsjjIrm5sR6PFEpxV4/Ad4NhYESbfMUL9oOZ1s5IXatAa2c
ZyOyiTtfOLWpCTZOpaw16m+mCamEBRMZHDb55zDVAdvT0vsDARgcbnzNZ4F119O2
eDu4KY7KDrNmmVGGW2w5YJYm8utax/mvr1mQE7LYzd6EuU6jowtxDlUZM4hKH/cv
aTv8Okd48envhbx6KPsmXj+bu1i1hGXwBl9uM5Zdp0naMFOG7HgoN2rflk0RhFK7
APWpn6Pq3banliViunCj
=ATak
-----END PGP SIGNATURE-----

--GRPZ8SYKNexpdSJ7--

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756062Ab3FQHXX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 03:23:23 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:35140 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754191Ab3FQHXV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 03:23:21 -0400
Message-ID: <51BEB955.1020809@ti.com>
Date: Mon, 17 Jun 2013 10:23:01 +0300
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Dave Airlie <airlied@linux.ie>
CC: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        <linux-fbdev@vger.kernel.org>, <linux-next@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>
Subject: Re: linux-next: manual merge of the fbdev tree with the drm tree
References: <20130617142120.b42dafb967974d3906a43fc9@canb.auug.org.au>
In-Reply-To: <20130617142120.b42dafb967974d3906a43fc9@canb.auug.org.au>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="----enig2TOCMVMLBHOFPOMFKBIQW"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------enig2TOCMVMLBHOFPOMFKBIQW
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi,

On 17/06/13 07:21, Stephen Rothwell wrote:
> Hi all,
>=20
> Today's linux-next merge of the fbdev tree got a conflict in
> drivers/video/of_display_timing.c between commit f583662347c6 ("video:
> display_timing: make parameter const") from the drm tree and commits
> fcf7e6e5bd84 ("videomode: don't allocate mem in of_get_display_timing()=
")
> and ffa3fd21de8a ("videomode: implement public of_get_display_timing()"=
)
> from the fbdev tree.
>=20
> I fixed it up (see below) and can carry the fix as necessary (no action=

> is required).

Thanks, looks correct to me.

I guess it'd be better to merge videomode and display_timing stuff via a
single tree from this on. Being in drivers/video/, I suggest the fbdev tr=
ee.

 Tomi



------enig2TOCMVMLBHOFPOMFKBIQW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJRvrlZAAoJEPo9qoy8lh71etgP/jsT/ZZt9o7oZFIrUadXPOVg
Zi8ZUf/5/4RcWWBDhuXlYbmHOawt6LhlCGVF0tmWiNBa39DBh8HSTE6uXedZ8rlX
Tf6b5kf1Je5t001Q8l98kIpgkCJT1QzQkFGK6OPvb7vhu8s+AjS//7gRUsfxmxHl
wZ5BfZsYfQ7muVEyLskhLj+MCq52RddNov0gZQWBshxKVk22jYDNwqYUzgNCAnI4
24wXPSILBGVZGUBYuZXM379hYiAGGhe6WuChgm9GauNtaX4JXUeVp5WnGhkk4Dz5
E+LBgiJOLC0Khq+OkCDwkLK49Ru35oYkOVWWn+5ZV5YhiEfM2IcqBM7qLxVnt8Js
6YoJuiwUUgXbBtfkffJb5gQuwPUK6yvRHb3nxTdXhav84iVZmpz61K4ktUMLB7sR
dWsI8V8JVMZg1fTQgL4ltak7kNlndtV0jHIQ39+BYjR0lFXW3UqTt/IeZLnzBokN
t7UdpPaqz36UifUnrX3CV7COS3yXIr1vulKeWGP7EGO8tSTerFer/A0HN93bepdy
h7540LWtvStoZof3ZTrJtBgGwSoxg1bN2vA3sLIzDh3ojwWKTnqpGc6zlOiDmpQn
CXpfXwtZ22bAqL5UsIEJ2R5EI2cdDnD3dlf195Bib3ku1zXMW0aGwyRfJaUwiug0
XpwLocVAFw7rxstdXeZD
=6nT8
-----END PGP SIGNATURE-----

------enig2TOCMVMLBHOFPOMFKBIQW--

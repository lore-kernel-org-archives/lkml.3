Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751791AbaB1KSS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 05:18:18 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:59509 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751066AbaB1KSP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 05:18:15 -0500
Message-ID: <53106262.1090202@ti.com>
Date: Fri, 28 Feb 2014 12:18:10 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Manish Badarkhe <badarkhe.manish@gmail.com>,
        <linux-kernel@vger.kernel.org>, <linux-fbdev@vger.kernel.org>,
        <davinci-linux-open-source@linux.davincidsp.com>
CC: <plagnioj@jcrosoft.com>, <nsekhar@ti.com>
Subject: Re: [PATCH] video: da8xx-fb: Use "SIMPLE_DEV_PM_OPS" macro
References: <1392693936-23862-1-git-send-email-badarkhe.manish@gmail.com>
In-Reply-To: <1392693936-23862-1-git-send-email-badarkhe.manish@gmail.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="FPL5MQL2wkCff31mNPEMtjt90mWCTsncJ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--FPL5MQL2wkCff31mNPEMtjt90mWCTsncJ
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 18/02/14 05:25, Manish Badarkhe wrote:
> Update driver to use SIMPLE_DEV_PM_OPS macro for power
> management suspend and resume operations.
>=20
> Signed-off-by: Manish Badarkhe <badarkhe.manish@gmail.com>

Thanks, queued for 3.15.

 Tomi



--FPL5MQL2wkCff31mNPEMtjt90mWCTsncJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJTEGJiAAoJEPo9qoy8lh71jH4P/jMO4gN7hvnElFaPyCwYXLQS
KYrUnAMU0KV/GP1ZRVu2R5JbHj84IF0kUC55Qv03z+qCN2zR9jbjBJ9uEAFGjO6F
O5FtyV7WQX0c1PAybOorRVFpBgm+nPbCdOdA0Od+ZMfQw77vOXYRc5RS+QcsNO5t
v9YVyTfVqNZFnWCxSSIvKw6atKBFYynNEhDvk1Q5saVdOhcioyvef1BwzvMxT5Xo
iYq3csPir0Re3aqGNiNfYfahuDu+C8agu4afhBNTqNZrdme6DWheoCy45af/dUth
tuly2fV9ADz+dZoojclFd9KvTmfVtAb+J8lCM5ndYUfVNvYLBz3yqFLUWyb5z8/m
10aJcxJXBg2oxGzFDh8+hduCw3XqW1I4ZKHGHQi0xM9WIw8bU9Q+aZ5Q2f/UhvJx
d2efNdbTURsqhCS2pb9Z8TMGqGFneOrtqVnr1PUHVjgC2AxYBO2Esw1k+Fpqhy1B
DwnL6nkZDcDdg13EaxE/q0xO2OH78C3+b7nP5Zo/WcslqhLmQtd9fzb9Rbop63cT
pD0L8ESz1KDCeLUOA/0OH8IVYvrUqqdGi0oopTJzHLhPzfPNULhQjyXSKuNqhqER
TzcqDloeWQvh9rScAzLRRkXoS5bbUsPUiZwORNMssQbjeZJVKcMAdS4t64Q+hYiC
UPq0DztU5Fmlxi6IpnMS
=Lr5Q
-----END PGP SIGNATURE-----

--FPL5MQL2wkCff31mNPEMtjt90mWCTsncJ--

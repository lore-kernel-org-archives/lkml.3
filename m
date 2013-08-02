Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757069Ab3HBHX2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 03:23:28 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:44967 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755784Ab3HBHX1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 03:23:27 -0400
Date: Fri, 2 Aug 2013 10:23:03 +0300
From: Felipe Balbi <balbi@ti.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Felipe Balbi <balbi@ti.com>, <linux-next@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Jingoo Han <jg1.han@samsung.com>,
        Greg KH <greg@kroah.com>, Tuomas Tynkkynen <ttynkkynen@nvidia.com>
Subject: Re: linux-next: manual merge of the usb-gadget tree with the usb tree
Message-ID: <20130802072303.GC24465@radagast>
Reply-To: <balbi@ti.com>
References: <20130802163818.e29c7e6d3472cf161703ae60@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7gGkHNMELEOhSGF6"
Content-Disposition: inline
In-Reply-To: <20130802163818.e29c7e6d3472cf161703ae60@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--7gGkHNMELEOhSGF6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Aug 02, 2013 at 04:38:18PM +1000, Stephen Rothwell wrote:
> Today's linux-next merge of the usb-gadget tree got a conflict in
> drivers/usb/host/ehci-tegra.c between commit d4f09e28d7bc ("USB: host:
> use dev_get_platdata()") from the usb tree and commit d50642794508 ("usb:
> tegra: host: Remove references to plat data") from the usb-gadget tree.
>=20
> I fixed it up (the latter just removed the code updated by the former, so
> I did that) and can carry the fix as necessary (no action is required).

Thank you

--=20
balbi

--7gGkHNMELEOhSGF6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJR+15XAAoJEIaOsuA1yqREonEQAIBeaXkRe4RddA478XSUUymp
5xQV8MojRTFMmjwDKkAzw7dLmwDJ/T+j8VgiZL7jONlkC7dr48yX7DKEylSPj5r0
JvfYBWINCoyMurH7/8I+BoCytuMB/H/CZlMO2PZvkTwWHYUtf4kDKLkvDADHeAbY
i0avslgsHn4MhrMozbVxsSzXoP9M+nevRVkLccjGX47g1xuJ2K60jGqFzRYfjGvk
B9Q5QS+2ix/d5Wi1L9bFLhuF0tpDTlKhulNZBoqJJYyb+FDimVsYX0mCISOWUqak
LMUTh+xrTtfRulGVv3Fb8HZoeU3ki0CwAyegx1FmP9nDm2amTEc/shw8hIaFxetq
IFLUcaG/qT0X2/GPgzzDPuNFvY5MaSiglFSoWqAg4/wUC54Tj8GXOn7RRritbKgh
VB4W9WJLCRd0GZLlGc3rCeja5eocoJUTMzEh6UPgIWiVa1+qJf9EXRevXj7qBHxK
pF7bHQGGZt6oolloVyxk2fZwin3BELLwqKtbnkj6fa0Xgwbm9eLUUkxcTgXDv1iK
rfmzjUvi5SrC3fnkH8mvta7fvLGvuLn4wolu6cYRNa5YrPqahFb2eTCr225LGe/h
9Hiq3ktFm1Or0OS1HJQQ3izqtktys6YvJ2vzhmeLzfQ6XThjMqa0+nBM4gI4icmq
dASzERUa7uWpStnGoJzU
=Q5PV
-----END PGP SIGNATURE-----

--7gGkHNMELEOhSGF6--

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756036AbbAHJfH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 04:35:07 -0500
Received: from down.free-electrons.com ([37.187.137.238]:58936 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752579AbbAHJfE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 04:35:04 -0500
Date: Thu, 8 Jan 2015 10:31:42 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Cc: LFBDEV <linux-fbdev@vger.kernel.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] fbdev: ssd1307fb: set default height if not found in
 DT node
Message-ID: <20150108093142.GM7853@lukather>
References: <1420705079-3741-1-git-send-email-prabhakar.csengg@gmail.com>
 <1420705079-3741-2-git-send-email-prabhakar.csengg@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="QyKdZyDmv5hkaBi2"
Content-Disposition: inline
In-Reply-To: <1420705079-3741-2-git-send-email-prabhakar.csengg@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--QyKdZyDmv5hkaBi2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 08, 2015 at 08:17:58AM +0000, Lad, Prabhakar wrote:
> this patch sets the default height if its not found in DT.
>=20
> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Acked-by: Maxime Ripard <maxime.ripard@free-electrons.com>

Thanks!
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--QyKdZyDmv5hkaBi2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUrk5+AAoJEBx+YmzsjxAg7yYQAI00jJv9PjU+X4UaYlZBIwK6
oqJy+PXI2S7PIoF4+Aq75yOYcNsfoSy5SDKhJB6s4B+uYHIEzXAxt07mL39B4PrY
umshUl0AitRXsLgO+dDdqm6N77wDjAMHNOt2chWHRhU2WDA87/zXJjWAbI6KWRHC
bKe6cGmRjDCR0mu91kxdacxjowEaqbQc9R63N1tJdgS08lnAAVgMJnZTfZhpHiH8
NkPF9nHLFFqHGQ6ImlEFfalSp5tQiqNENzEOIABKXniVDE8mTgEBLm8xCpvzXFdR
PoQ7YytPZiI8UAePdhPEPqx00CCza3S8pWGrJZWDzE0582YLRAxNNrRNc4IJGsQs
Ct5vqch0Shbc1+mwGG5634nSFMODP9JTy3lXQ8wtusN1jxawuhp2F3ci2QxhJ1nd
tVPufvGBZe35AC5AmlchRAA1S5AZgFKFUxWLz5K1Ez3hvBryeoS60xJsYlJjjibn
kdmP2khZ00rRtNt/Pazn/tO0C2aWEKdoqZrDXUKF/T6PgDqqkhWEZVdPuL+s3dnt
RcEMIVMan+jAc8wvq088jhKAOKmhqR8ud6IzxY/eMimC0tzxT0ZpJCBvGG0NKzpr
1wqx4psb1RZQjEXWARXb6RF7mVzur3Wo/GznvEzKhBOwMJS3hIfYUGSfKQuht6eV
BMAPy/RWNneBJMUHShVe
=fu5Y
-----END PGP SIGNATURE-----

--QyKdZyDmv5hkaBi2--

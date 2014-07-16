Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934931AbaGPSmF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 14:42:05 -0400
Received: from mail.kernel.org ([198.145.19.201]:60589 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934741AbaGPSmB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 14:42:01 -0400
Date: Wed, 16 Jul 2014 20:41:55 +0200
From: Sebastian Reichel <sre@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, Andrew Lunn <andrew@lunn.ch>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] power/reset: Fix GPL v2 license string typo
Message-ID: <20140716184154.GB6438@earth.universe>
References: <20140715232450.24076.25543.stgit@bhelgaas-glaptop.roam.corp.google.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="MW5yreqqjyrRcusr"
Content-Disposition: inline
In-Reply-To: <20140715232450.24076.25543.stgit@bhelgaas-glaptop.roam.corp.google.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--MW5yreqqjyrRcusr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 15, 2014 at 05:24:50PM -0600, Bjorn Helgaas wrote:
> Per license_is_gpl_compatible(), the MODULE_LICENSE() string for GPL v2 is
> "GPL v2", not "GPLv2".  Use "GPL v2" so this module doesn't taint the
> kernel.
>=20
> Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>

I put this into my dev branch on kernel.org, which I use to queue
patches until I get access to the battery.git repository:

https://git.kernel.org/cgit/linux/kernel/git/sre/linux-power-supply.git/com=
mit/?h=3Ddev&id=3D162c1a01825553e055ef3867f7598ca8dddb6c6e

-- Sebastian

--MW5yreqqjyrRcusr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJTxsdyAAoJENju1/PIO/qaUrkP/jUKt+JG1nVX+QF8LdO1o1C0
eW+XoaBmVTzf7u3qnk/mjErjYoShr/xsG58p/j617rKGDGOlo1M7I0ZOumbCkaFv
cnCLZWFyABuyzASvct0djpenm1kMdanP7cp6fC2vgC1oYuZZsMkFf5NPrf3szlp9
SdiTi2EAvchI3pjmsgV7VPkzy9vgcMkUtDD7Xa+eBQpH5DFL/d2U8NxlQZVk/OBh
qAbkBS2r6P8p65Vwo1gvdFnkhNRYiI9hjvoI3az1fW/KyKivwzrg8wdGxZ+qVmXJ
O0lIvQCMXFJj7/Z7rd/GM+/eesOs52wsYUOfzQiHwQq11AvBsdTo/LjrYp/deuKl
Eo5/tQbJ8TO8fLpvZDrt+nhT9yRmpQhQPFkCHKFJ2HifxR500R5/Qc/mdxOFl/nQ
CpaSgrgTjEtEZ2wrZmSTSfcVUJr/5GoDPl+mfcxN/WYr7zLdsTCM5KgqHx8y/prM
81fT1Mf6xWJlGAAj+7+bq0TpbAqoNUF3Zz9bS5A65tRudHVaU6/LwkXdAHFHQz0j
6bZ8QyUz9ciJ3ARTH6HBOrMURq+EpUBxcEDpWO7ha1+HkXq5uHSSgKADv+Nc78iR
AK0yEggyJPYC30xDOVgyKnqPvogcApvDJnD06/MNYZdBKY8s/q0xe7uJF1rX7N7O
FxWHJyYHJNN+t6TtmoVW
=58Jw
-----END PGP SIGNATURE-----

--MW5yreqqjyrRcusr--

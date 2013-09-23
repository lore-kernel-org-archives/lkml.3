Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753430Ab3IWHBq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 03:01:46 -0400
Received: from sauhun.de ([89.238.76.85]:48183 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752453Ab3IWHBp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 03:01:45 -0400
Date: Mon, 23 Sep 2013 09:01:42 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i2c: mv64xxx: Do not use writel_relaxed()
Message-ID: <20130923070142.GC3051@katana>
References: <1379508700-30400-1-git-send-email-treding@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XWOWbaMNXpFDWE00"
Content-Disposition: inline
In-Reply-To: <1379508700-30400-1-git-send-email-treding@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--XWOWbaMNXpFDWE00
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 18, 2013 at 02:51:40PM +0200, Thierry Reding wrote:
> The driver is used on PowerPC which don't provide writel_relaxed(). This
> breaks the c2k and prpmc2800 default configurations. To fix the build,
> turn the calls to writel_relaxed() into writel(). The impacts for ARM
> should be minimal.
>=20
> Signed-off-by: Thierry Reding <treding@nvidia.com>

Applied to for-current, thanks!


--XWOWbaMNXpFDWE00
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSP+dVAAoJEBQN5MwUoCm2zG8P/AnaINOMH59lZ3LSMjX5Wb8V
jRTYYc3KpY4aQsktLCbos72raqZ61hdsnI/EJZjvkvtk4pORyL6JejwpwOlbBLhL
bjkSyQxKKXK7UjYXAmXNuGYeS5euM2RDM9+nWbFqJxqc12u1ZwCrvxDXYTrS97FB
hj+xFHQcMkuX/iVPUxVrM5GAnmg10TErO111t51dvw28aD/XagZ1oDrRBE6D/3nx
9GVKnmTtiidcvSOGSesJP/4vC35CacxV/KM8i5ZyENPRl57WeKWIeBHkQDtOK9MP
Q3IVcHIZd5dvg0jVyH9yf8oKDtxHiSkRO+YRfHJiyrcVe/MubJ0zjbJPnF6n/KWZ
LcXpgbPkBhJAmRoAGpoBqZZSItrgE045+zzuMh954WtIgbld1Tu5HICmEhwF1vnu
cR4GZTV43+TOb78Y2mTIWgFpd8hIcvmUf49ac/30hkJF7TF+/PZpH42ulz+IkzDl
p7YPhH+hzs2pzuNNOIcmLnpXmOiKAUYRqF1QcfNa0S5sdkEUKUdv6OtFaV5Vy4Ji
G7oc1zpHjTVhpXTAX4g4lKz7c/VoWjeGIacE0pqAZqA4dKuBvUKnWvyDLso5yTQX
kVHnpznc7cAmA3PSY2g4T4hwwkh+zbKLl/3WMy8AG+vrKqaaleX21UAxZAozPHRI
1/Zwnrc60A8FohKiKMbg
=QmoL
-----END PGP SIGNATURE-----

--XWOWbaMNXpFDWE00--

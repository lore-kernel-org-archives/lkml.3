Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760626AbaGPRbK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 13:31:10 -0400
Received: from sauhun.de ([89.238.76.85]:58209 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758294AbaGPRax (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 13:30:53 -0400
Date: Wed, 16 Jul 2014 19:30:35 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Doug Anderson <dianders@chromium.org>
Cc: Kukjin Kim <kgene.kim@samsung.com>, Tomasz Figa <tomasz.figa@gmail.com>,
        javier.martinez@collabora.co.uk, ch.naveen@samsung.com,
        jg1.han@samsung.com, jdelvare@suse.de, sjg@google.com,
        paul.gortmaker@windriver.com, standby24x7@gmail.com,
        sachin.kamat@linaro.org, linux-i2c@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] i2c: exynos5: Properly use the "noirq" variants of
 suspend/resume
Message-ID: <20140716173035.GE2759@katana>
References: <1403714360-7581-1-git-send-email-dianders@chromium.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gMR3gsNFwZpnI/Ts"
Content-Disposition: inline
In-Reply-To: <1403714360-7581-1-git-send-email-dianders@chromium.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--gMR3gsNFwZpnI/Ts
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 25, 2014 at 09:39:20AM -0700, Doug Anderson wrote:
> The original code for the exynos i2c controller registered for the
> "noirq" variants.  However during review feedback it was moved to
> SIMPLE_DEV_PM_OPS without anyone noticing that it meant we were no
> longer actually "noirq" (despite functions named
> exynos5_i2c_suspend_noirq and exynos5_i2c_resume_noirq).
>=20
> i2c controllers that might have wakeup sources on them seem to need to
> resume at noirq time so that the individual drivers can actually read
> the i2c bus to handle their wakeup.
>=20
> NOTE: I took the original review feedback from Wolfram and added
> poweroff, thaw, freeze, restore.
>=20
> This patch has only been compile-tested since I don't have all the
> patches needed to make my machine using this i2c driver actually
> suspend/resume.
>=20
> Signed-off-by: Doug Anderson <dianders@chromium.org>
> Acked-by: Kukjin Kim <kgene.kim@samsung.com>

Applied to for-next, thanks!


--gMR3gsNFwZpnI/Ts
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTxra7AAoJEBQN5MwUoCm25cgP/3M4lXDX304klWnf2sddyq/+
wVtAHSkdsC2igVORMlOPSJftVdffbiFkbkmwvDChP1nGiYu8p5ukmnKjIDA7JOtH
XxsPj7XykOkt8K1UhP3Bt95ChPZxqFeM/JvxRy4yTfudr64vg3f8iX0PtsdPsTF5
vRJXb2R2MzOT5cFPPz4n2ScZqCdZUv5ssHrLZUeYX6m3AS2TYlfi7kOi3ov9ciyC
3mAbrPNmgB/YL6HPFYPcxqLQMuFjAehguyneuEcrKw9nyDZTkYUkHwDpx9QVgfCn
tEhYUVGx2PV1NQsou3dmMGTOs0dp3rCTVcH/Yn9lUMB7NDVs8sRyUuhfG+r4yDJU
DeyxLlyxSW5gzE8nZpr3+SurxyoIPP3w41paF6lx1WiLY4W7hXjRp2laesHdH/PB
xzaJrlyDtOaCigmnX39wk7JsR/CPwzReZJWiAcVJKGOpexJRURjuGwI9ooRtFdAL
Y+9ZqmyfcIG+ymFazlyXdYWhvdb5f8Ipj/849MZ2GG8k+b7mwGv/IWqhFVg3BuWw
evScYWJrO13JlFVpDxvYKBXr88jHlS3AVc6T8kXAJUBh3yPm49rXsijXkyfD0obi
HO7oUnPc3HD2RclFoOJDN0JNaLhxovtCFhuFhgWjvbAjPpec6B7ArdJ/kNpBI4iQ
3DNeXMR7HmHEekpnhIj6
=QDTt
-----END PGP SIGNATURE-----

--gMR3gsNFwZpnI/Ts--

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755690AbaBROUJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 09:20:09 -0500
Received: from top.free-electrons.com ([176.31.233.9]:45364 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755016AbaBROUE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 09:20:04 -0500
Date: Tue, 18 Feb 2014 15:17:05 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: David =?iso-8859-1?Q?Lanzend=F6rfer?= <david.lanzendoerfer@o2s.ch>
Cc: devicetree@vger.kernel.org, Ulf Hansson <ulf.hansson@linaro.org>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Mike Turquette <mturquette@linaro.org>,
        Simon Baatz <gmbnomis@gmail.com>, Hans de Goede <hdegoede@redhat.com>,
        Emilio =?iso-8859-1?Q?L=F3pez?= <emilio@elopez.com.ar>,
        linux-mmc@vger.kernel.org, Chris Ball <chris@printf.net>,
        linux-kernel@vger.kernel.org,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        linux-sunxi@googlegroups.com, Tejun Heo <tj@kernel.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v7 3/8] ARM: sunxi: clk: export
 clk_sunxi_mmc_phase_control
Message-ID: <20140218141705.GI3142@lukather>
References: <20140217095907.15040.81893.stgit@pagira.o2s.ch>
 <20140217100228.15040.32391.stgit@pagira.o2s.ch>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tctmm6wHVGT/P6vA"
Content-Disposition: inline
In-Reply-To: <20140217100228.15040.32391.stgit@pagira.o2s.ch>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--tctmm6wHVGT/P6vA
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 17, 2014 at 11:02:28AM +0100, David Lanzend=F6rfer wrote:
> From: Hans de Goede <hdegoede@redhat.com>
>=20
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>

Again, your SoB is missing, and that can be squashed with the previous
patch.

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--tctmm6wHVGT/P6vA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJTA2thAAoJEBx+YmzsjxAgQSgP/3QXfcYGS0oqcTD8sCyqf6CZ
C3ln6LBm2hYpYOiTXvTxix8LR8l3IIs8qWddBlHzcWzx+MDQ+l6JRWBKgCEt1kE3
it0q9W3NazVxjG/Z29ZlREiu7MNey3bwhEuvrLKOxJMU6NhsRFQlS2PhBOBaViai
f/MoHIXi/n5E5pOlfYol+z48XzXNOHRU3jAkdmyR1iHS/h86h3Zg7Crl1HldoUtr
T9WoHy5CCpvPkkmfILk5jFxMpNUbAXcHsAPqKPbeuksAqzUahBQjDTILX91HVAaa
o73qFgkzzkZxAcnssatnaEsz23GQNo99PCwY5J4H1nt0pKiPoDciWYzI/ROX5HKm
dm7BohSq73K85YvVoLwuxyjUo5q931Vf8JYiPhA4b/jwCAVLLWBZp1owBH0cAwqI
6pNwZMdeME2dTa1DswF4ylm7C6BdgFs+d1cCJ3gAVsvUaT76DMRCYF+7Hm8eCPa5
zmYODXZEK26XpRL8gDsSvxhf3bT+eqzKZau7cr+c0tZ6LQAhR125m8FMDps9UTsz
UTJ6J4ol0gZQ63IWKa2FKfqo+RvS59LqgZCEhPIXHmG0JR2khiqBt3I1mNvBBb6W
SbJSObjE6ACcSKI+HyQjd+ndk5FDXp6/upkeDFm53PtIrBDxST82QnqbCMG7QLDc
oEf+tv2aoWwG76wgkLtQ
=fAV1
-----END PGP SIGNATURE-----

--tctmm6wHVGT/P6vA--

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752824Ab3APLwd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 06:52:33 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:51013 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751055Ab3APLwb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 06:52:31 -0500
Date: Wed, 16 Jan 2013 12:52:25 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Arnd Bergmann <arnd@arndb.de>, Stephen Warren <swarren@wwwdotorg.org>,
        linux-tegra@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Murray <andrew.murray@arm.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH 05/14] lib: Add I/O map cache implementation
Message-ID: <20130116115225.GA15873@avionic-0098.adnet.avionic-design.de>
References: <20130109231758.GA27065@obsidianresearch.com>
 <20130110071937.GG15212@avionic-0098.adnet.avionic-design.de>
 <201301100917.19577.arnd@arndb.de>
 <20130110102544.GA5546@avionic-0098.adnet.avionic-design.de>
 <20130110182007.GA28004@obsidianresearch.com>
 <20130110185505.GA22944@avionic-0098.adnet.avionic-design.de>
 <20130110190327.GA23110@avionic-0098.adnet.avionic-design.de>
 <20130110192417.GA18478@obsidianresearch.com>
 <20130116101822.GA17706@avionic-0098.adnet.avionic-design.de>
 <20130116112556.GR23505@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="opJtzjQTFsWo+cga"
Content-Disposition: inline
In-Reply-To: <20130116112556.GR23505@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:14Skxtu5HLJ3hLT+cmJVNwtwTiS2UcWPfcJyNPTgHIk
 CSABt//IieRTjmM9qSm6bKk7OLRx5FPsd02jhbG9H7clpNfRqs
 JpqT292BrdGlVutWaNvtFtBwakf3VSWWQ25Y2mXLpofYuetQl1
 zY6lJNF/e2oCOy20coVr2LnkX5pqWsqFIyPbHkB4HZB54HwokL
 vw4xCp83v+Hxa/O0AzQZCkZF5ATjmzazSzp61cVQqk2nke82rm
 HkklnGkntvgoLvvi83G1ZBJt8ll4oIqJa9btEVPMw4BS60XQwr
 GyqFt23JNAyVYE1sa3TtKygfIjSIBU75F9A6WSLkyynjolRSgF
 a8kW1LststSaWM1sBgM6blXkhYp0ea4JN2vbUvZ9o5H6Kka0yi
 XgoB3f+AWpSbYIHe1E7uh1Fq237Ms2kAdwjJ73y0c+ZHpu5Ipd
 BFTwk
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--opJtzjQTFsWo+cga
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 16, 2013 at 11:25:56AM +0000, Russell King - ARM Linux wrote:
> On Wed, Jan 16, 2013 at 11:18:22AM +0100, Thierry Reding wrote:
> > 		err =3D ioremap_page_range(virt, virt + SZ_64K - 1, phys,
>=20
> Why -1 here?

Right, I forgot that end in these functions always means one byte after
the end. Removing the -1 seems to get past the remapping at least.
Reading the configuration space through the mapping doesn't though. I'll
investigate some more.

Thanks for pointing this out Russell.

Thierry

--opJtzjQTFsWo+cga
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQ9pR5AAoJEN0jrNd/PrOhFAwP/RJbvVzV80bNgHLrp+Cm89Bt
eWkJ0siumvDSyHm2o7GmgNN1AbgR2LlH7a5AVbBZo2HutMEWjMLe7dNNS4LPuhz/
w+GmY9J3qlSjNRrClJrOu2p6vhhIIDYKKTCQTj0YTRT2fCa5RzM5oo2LlPVvLJRW
vgUCDHBlA14NWPBGODjffpgyiH4Cv/jtV95o8rv2kCgce+Hr/VkhUxDtjdXN/WDL
IQs7xwS5lj8ZAPG4ylv/Sp5OLDDpF3nHOrkikEeuBCZZwy89buiHta32JBVeRWo4
Flz7/VGIOuaTdrVGbWqyN2PRsmeRco/c1R1ep0o8IVMykLx9DwzBRnOVpeh8gn7s
0USCfRIRhIEhhV0GQNNbOLoMs55nu0nreBChWqmDfpu16ORDrcWyiB/+eFx/Kwvl
yp+Y35n155CXmpWv5mpG/MxsS4nkJ0yAwpdtVDKykaN1wA14/Q0z0kj2Q4z9Vl+n
LPXgDBnvQe1XQfsu/gIUR5qmhpcPQMFIQ3NskjpqgrNIGWMotZXYhh2vLFiyQCn9
LVggn2ru7EE7erN6d4/HRxRpzYGfr1IDclGpbyHt6zfLlYjVWgE9wJQnji398NGZ
wePCQc2hWTdOGAfkQHiJrqjSFiaMYzfDFFwu/cN/WIK37geQTF5DLr/krdyxHxOx
3HvFjPjAwtgIeScXZXtj
=b3tU
-----END PGP SIGNATURE-----

--opJtzjQTFsWo+cga--

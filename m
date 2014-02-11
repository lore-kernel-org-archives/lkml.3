Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751563AbaBKOxb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 09:53:31 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:38668 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750743AbaBKOx3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 09:53:29 -0500
Message-ID: <52FA3961.9050208@ti.com>
Date: Tue, 11 Feb 2014 16:53:21 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Christoph Fritz <chf.fritz@googlemail.com>
CC: Tero Kristo <t-kristo@ti.com>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <pali.rohar@gmail.com>, <pavel@ucw.cz>,
        Nishanth Menon <nm@ti.com>
Subject: Re: OMAP: clock DT conversion issues with omap36xx
References: <52E697C0.6000202@gmail.com> <1390848104.4936.62.camel@mars>	 <52E772A3.4090401@ti.com> <1390901735.2963.8.camel@lovely>	 <52E77D03.8090001@ti.com>  <52E7B361.2030601@ti.com>	 <1390928565.4904.88.camel@mars> <1390994505.5023.32.camel@mars>	 <52F10C3D.7000507@ti.com> <1391767923.4937.110.camel@mars>	 <52F4E45B.1020107@ti.com> <1392065696.4898.163.camel@mars>
In-Reply-To: <1392065696.4898.163.camel@mars>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="87h4hNfMdUIlBa3GdIKxthCfREv82UGsC"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--87h4hNfMdUIlBa3GdIKxthCfREv82UGsC
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 10/02/14 22:54, Christoph Fritz wrote:

>> I wonder if I'm still missing some patch?
>=20
> Is beagle-xM using DSI? Because here the LILLY-A83X board is not. The
> clock registers are all fine now as before the dt clock conversion
> patches.

No, Beagle xM doesn't use DSI, plain DPI.

 Tomi




--87h4hNfMdUIlBa3GdIKxthCfREv82UGsC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJS+jlhAAoJEPo9qoy8lh71KREQAJlVa3O5Y4ERvRPfJuAw5SEx
Vknk084d9vUOFgVMFxWKT/oVMA6ohZ/6fvnJ1tSyzv4XbQhMMLUDMtZgf1Syhl1a
UIzf3K6MmKeVXBUutJnlXVSGf8Npf2AZ6f9aA5kA6KvMXDoYLPN2ce1sbt5MdByt
X2QAEDkd26xMIhyas5OBySplwQEhoH5o+0dn4WRL/qbWFcXTBcMCMVSDWvq0OZ7F
vqIq3zYKdU/CjyAwaidlDuAxIp+lmOR9naXoZ+LSypy0iIFbXAs9RMD3fiG31jyj
NPP41zFYuhUOcCCGjmlzoyj/pDgmPdvxoYUUlL53YJpL1ER+NShc1fVFpYLSqZ/N
CFIe3bcfronHwwRQTA2tEUCWsXU3A9DAG8rGKKb5sUUullg04BiCIr5d4Cdy9d1Y
luchkoOpmRz8WmBE8N+hjaNP6gK84fZhkkA9Xz6mZehVYyAKtGu/F0Olali04ocN
Scfym/tHteVcTBrMStykVBq14RfdNRF0G3Z9rOw+CJ3wNZaDrczbVwf00JdLNI5X
ud0I0WLWJqkN/NmaxKNkSj7FfaKpm5/JAgeZ2a7246lT2NDvvO40LHPZV15vzPtX
r3BfjRlF1b/0ZUo3HZhAYk7KADqGjIsHuvcOnWjTHysYhdsPizQ21Fl7jRsi3wGI
2zTTGYwZhLo2oV8Lgdiy
=RTJm
-----END PGP SIGNATURE-----

--87h4hNfMdUIlBa3GdIKxthCfREv82UGsC--

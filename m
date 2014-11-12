Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752207AbaKLJCb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 04:02:31 -0500
Received: from hqemgate16.nvidia.com ([216.228.121.65]:3396 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751514AbaKLJC1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 04:02:27 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 12 Nov 2014 01:02:41 -0800
Date: Wed, 12 Nov 2014 10:02:17 +0100
From: Thierry Reding <treding@nvidia.com>
To: bpqw <bpqw@micron.com>
CC: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        "Mark Rutland" <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Jason Cooper <jason@lakedaemon.net>,
        "Mark Brown" <broonie@kernel.org>, Heiko Stuebner <heiko@sntech.de>,
        "Florian Vaussard" <florian.vaussard@epfl.ch>,
        Andrew Lunn <andrew@lunn.ch>, Silvio F <silvio.fricke@gmail.com>,
        Hayato Suzuki <hytszk@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1 V2] devicetree: bindings: Add vendor prefix for
 Micron Technology Co., Ltd.
Message-ID: <20141112090215.GA29664@ulmo.nvidia.com>
References: <A765B125120D1346A63912DDE6D8B6315EB0ED@NTXXIAMBX02.xacn.micron.com>
MIME-Version: 1.0
In-Reply-To: <A765B125120D1346A63912DDE6D8B6315EB0ED@NTXXIAMBX02.xacn.micron.com>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Originating-IP: [10.2.68.108]
X-ClientProxiedBy: UKMAIL102.nvidia.com (10.26.138.15) To
 UKMAIL101.nvidia.com (10.26.138.13)
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="AqsLC8rIMeq19msA"
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--AqsLC8rIMeq19msA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 12, 2014 at 01:26:58AM +0000, bpqw wrote:
> >Signed-off-by: bean huo <beanhuo@micron.com>
> >Signed-off-by: bpqw <bpqw@micron.com>
> >---
> >V2:
>  > - Add signed-off-by
>  > - Modify commit logs that wrapped to less than 80 columns
>=20
> Dear maintainers:
>=20
> Please give some tips,if this patch is OK?thanks!

Patch looks okay to me content-wise, but you might want to use proper
names and capitalization for the From: and Signed-off-by: lines. bpqw
doesn't look like a real name to me, and "bean huo" should probably
be "Bean Huo".

Thierry

--AqsLC8rIMeq19msA
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUYyIXAAoJEN0jrNd/PrOhO/EP/juUDVqscA4O+XpTsaq3pekP
IrTzP9gLmCtl8aGZLGkKCmqAKs23H2h8ceJJt5X0LEPvGuYR8r7dt6o/DK8fCnio
HexEBZ2v3G5p+QEELhjC5uxg5KnpR1vHy5mLx/dIJkwpuvtI42RmA3e4KWIAsZZ9
ZDA6I3+9Yl0Zlc42RjvXL89au5WziiB6mWzHP8HdR9dJHHk1tHn/SEB2FgraNrw3
LW6QIlTFfc8xHjxm1hAtCv/FQiIPE4tEpeDivL0UeV0LB0x74kB/MUbONyXnPFUb
xgek4aHE8ixMGV7AYFAlDZaIdggRvKcq6t00moiJTPEWGjhNBtndnQQ0zrkKmeHX
SchRVDjTbeDpDBNCaYB9wHWoezQQt2gcP80R2+zToqVzdT+kbtMV8t6DaTX4RZu9
Dc8HWGLqAaqbkipMkTE6k+JNQlq3qXAQ9gKCgqUfPSyaW3uMi1x1uJQS7++MVnL2
B1QWEpjjmUDPG1Ws56iGo5ALllHNtoYYNlRN9ziElUK4ds3Wr4/amsB1wOG22mH5
2Hk75P3ea9TTET6LywhiUatkKUPd4iLdEG16d2TqxUpWbLe0bYH1vnNI81mEPiQq
DXsm5QbSyAAyjczEb1Yd5hbWWcejdXkObj02fJs/D+3VPWq8xPaSpsbTNcMRzeEP
KjKxwoxC3wtcmVCpgzjv
=TjLE
-----END PGP SIGNATURE-----

--AqsLC8rIMeq19msA--

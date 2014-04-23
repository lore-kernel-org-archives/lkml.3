Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755044AbaDWRQk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 13:16:40 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42301 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751709AbaDWRQi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 13:16:38 -0400
Message-ID: <1398273387.4222.19.camel@fourier>
Subject: [ANNOUNCE] Linux 3.13.y.z extended stable support
From: Kamal Mostafa <kamal@canonical.com>
To: stable@vger.kernel.org, kernel-team <kernel-team@lists.ubuntu.com>
Cc: linux-kernel@vger.kernel.org, gregkh <gregkh@linuxfoundation.org>,
        lwn@lwn.net
Date: Wed, 23 Apr 2014 10:16:27 -0700
In-Reply-To: <20140423000635.GA32144@kroah.com>
References: <20140423000635.GA32144@kroah.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-v9Xjam2WYjVAE7I9eF/K"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-v9Xjam2WYjVAE7I9eF/K
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2014-04-22 at 17:06 -0700, Greg KH wrote:
> NOTE
>=20
> This is the LAST 3.13.y release.  It is now end-of-life.  [...]


The Ubuntu kernel team will pick up stable maintenance where Greg KH
left off with v3.13.11 (thanks, Greg!)...


The Ubuntu kernel team is pleased to announce that we will be providing
extended stable support for the Linux 3.13 kernel until April 2016 as a
third party effort maintained on our infrastructure.

Our linux-3.13.y{-queue,-review} stable branches will fork from v3.13.11
and will be published here:

    git://kernel.ubuntu.com/ubuntu/linux.git

We will use the same stable request/review workflow and follow the
standard upstream stable kernel rules.  More details are available at
http://wiki.ubuntu.com/Kernel/Dev/ExtendedStable

We welcome any feedback and contribution to this effort.  We will be
posting the first review cycle patch set in a week or two.

 -Kamal Mostafa
  Ubuntu Kernel Team, Canonical Ltd.

--=-v9Xjam2WYjVAE7I9eF/K
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAABCAAGBQJTV/VrAAoJEHqwmdxYrXhZ+kAP/RpgpaVhmgcMZgtoDgN09Yqw
E0FRVimUE7YOyGH+olQMd6wsVVpkhobRYcqP9uV5crGDg0C2wWu49X7/5qdCU2wi
ZcZ6dMgIWyu/9TQberkL7HfWlcUo8gATUo96Sg99YSSpau9RZjKSkSqxgvnDOOUD
/zp4wLh35yDlOR+fuJ7QPFZV+jIvGLEBLP4c9KLdAofnj1Mi1gcUvI/IMIwp0VEO
6/CR2D4rFUGtcA0t8IDlNZwwjaVICtjq7EcHWMDhX/l2gCMuAsAN4AK52KD7iUov
QLJBBleVSdPRY+QYDA58fNOIXN2nfzY1rr8hHyhvTlDPMtsqwv0yrsAKmes1uTuB
Om2+Qg73h/bJMKtviOXKwe4aPB8c3rJuXzWhkhwX8ilQTar9O4bd9vsisxMzf8H0
xzlpLQSFbIU1BHOQZQbEAhQ9FZJylCtqrlmbfbCbD3u9ltkWYRqTRguXgytT5VNk
fquQgwbE8PYGkoAmHduvQzXELQPP3Si9NA4FNzmPHjLu7DtqwnNc7Ko8ZHTSBt7t
/eGCpQuIDO49lvh29XvE0G5b7NJNH6bYtnabRtSzsdRr7yxoeyC0DGQSB6SBP17L
f2uvd8KoP26XrEMoBCD+E2AsN7jrKPYRQrsKAdA4YUuhuM/v0N5YE+sgKN1rRW3Y
UrNts/wEFomw6iDhfFA9
=3B6q
-----END PGP SIGNATURE-----

--=-v9Xjam2WYjVAE7I9eF/K--


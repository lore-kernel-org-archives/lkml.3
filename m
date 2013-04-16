Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934877Ab3DPAHV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 20:07:21 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:60878 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753874Ab3DPAHT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 20:07:19 -0400
Date: Tue, 16 Apr 2013 10:07:15 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: "Tivy, Robert" <rtivy@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        linux-arm <linux-arm-kernel@lists.infradead.org>
Subject: Re: adding rpmsg.git to linux next
Message-Id: <20130416100715.cd726b96944237ef975ebe7d@canb.auug.org.au>
In-Reply-To: <CAK=WgbY=4rosYr2g3fYYk6WrqXjN7f=5Dk5+D-h3cWrOtVmNag@mail.gmail.com>
References: <CAK=WgbY=4rosYr2g3fYYk6WrqXjN7f=5Dk5+D-h3cWrOtVmNag@mail.gmail.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__16_Apr_2013_10_07_15_+1000_qumq2kZEKiI0nh3B"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__16_Apr_2013_10_07_15_+1000_qumq2kZEKiI0nh3B
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Ohad,

On Mon, 15 Apr 2013 09:28:17 +0300 Ohad Ben-Cohen <ohad@wizery.com> wrote:
>
> Could you please add:
>=20
> git://git.kernel.org/pub/scm/linux/kernel/git/ohad/rpmsg.git#for-next
>=20
> to linux-next to include new stuff coming from Rob?

Well, you could tell me something about it.  Like what is in it and how
it will be merged up to Linus.  Does this have anything to do with the
remoteproc tree I already include?  Who is the official maintainer (there
is no mention of drivers/rpmsg in the MAINTAINERS file).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__16_Apr_2013_10_07_15_+1000_qumq2kZEKiI0nh3B
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRbJYzAAoJEECxmPOUX5FEnf4P/A+lnN80cb/n+rxJdbK5SttF
w9wHcfonMUIbs6+QfCAap6/Q/d3hmRcROXQyl/7QDY5WDSw+drk2dDFdU/WhMdX/
WEmz2pU6z8zH2ctC1+JQhs0UeMus7wcn1bC5GHjZrsuPM8rSoyarr1AMfWhsavmr
9VT339uEWpxEdemFWqYrtk1fBzHM8wyFIujCnWD/jb0EIWjbvbsXyQieiRpq9cqY
9JEV7EaW1e3zwy33Y9UiZ9bRTFmQvstQ8t8klr6AZLT1lyaDA0ky9w4i4fqvrp3Z
3HrLCqHV7mUwOAUlAfgmrHq+Y8lDA5hzp8NT9HFVBom9vXCIxS+9iHXdIdzhPJ/6
Ur2Igep5u4xKfACBr+vuFbYxySr42uyvb9MyohEozh5+y56ULB4ryXYHB8f7Qr/m
+3pEcqDykPd9cfUtUp6iR4MlCIIurgqHzZ6KWYi4GE+JbEWBuh+y2/BMY/gt7W+d
PD40n4kVpC5q1RsKRS7rDua7n4ATJ25tK6Duze6c6H5eThB5nPsgtzw8uApT/NmN
E/n+JoLT+H/XAA+rTDf0xTyw0dtXd8q0Z4cqEX/+Q3xnvny0Xuzw9mMwV3+vgmXY
W4VEm+pqYnCut73SjUCYUwaotrKinFeGYYSn7I8TiDDN5SFx7zJUxZ0BGi7huCiR
87FAO0k9jlQycquMZA+p
=NaRd
-----END PGP SIGNATURE-----

--Signature=_Tue__16_Apr_2013_10_07_15_+1000_qumq2kZEKiI0nh3B--

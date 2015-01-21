Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754851AbbAUCqi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 21:46:38 -0500
Received: from mail.kernel.org ([198.145.29.136]:37336 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752827AbbAUCqg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 21:46:36 -0500
Date: Wed, 21 Jan 2015 03:46:27 +0100
From: Sebastian Reichel <sre@kernel.org>
To: Pawel Moll <pawel.moll@arm.com>
Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Liviu Dudau <liviu.dudau@arm.com>, Sudeep Holla <sudeep.holla@arm.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        linux-pm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] power/reset: vexpress: Remove non-DT code
Message-ID: <20150121024626.GA28669@earth.universe>
References: <1421774642-29843-1-git-send-email-pawel.moll@arm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="IS0zKkzwUGydFO0o"
Content-Disposition: inline
In-Reply-To: <1421774642-29843-1-git-send-email-pawel.moll@arm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--IS0zKkzwUGydFO0o
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Jan 20, 2015 at 05:24:02PM +0000, Pawel Moll wrote:
> Now, as all VE platforms have to be booted with DT,
> the code handling non-DT case can be removed.
>=20
> Signed-off-by: Pawel Moll <pawel.moll@arm.com>

Thanks, applied.

-- Sebastian

--IS0zKkzwUGydFO0o
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJUvxL/AAoJENju1/PIO/qaM0kP+QENC4g1acuuxuJ6jEgPaIE5
sF3ePq+3Ply4KX7/J+WgPcH44CS3XqySsGxMrUGmygETeyH0FtYT62UoVvauVYeC
A41F4O1fH/dSRUHj/oUL9NFIRv/CmIYEikSJy0MqtAo4c5U4uvNbrdd0I8M+lp9V
kxZNob1J2Ecx73GNUBc4SL+a/up5Y51cDgLH7Pi6kAfxikQ+RrSMiPSOl2DbHubj
m8EfS3o4mnibv+4/3zwPZ0EbLxYUB/zTwf49Nsrc3vUsWdsxlvsJR70E1uwy7R7T
XQ4l5JD8lqjgqFwzfWxWZmo9qd1HaY0jYKxZnGC+CG6r7FWvSTiSxq47F3DUCHLr
eK1g0XjVlUDoC7iiz4buAEky24LdZGFZyk/t1yMkqp66abVDJvjVSpLCZc6ccbrh
tIHXesBU9V9gsflQwOQKzwZ19jsjqWEMtwgFF/hqMMom9Go0tioRIf90RZ1jlRpz
xwbo6HIvuacYceGN9Iiz18bBqpoTp6gykO8jIEAKr3kRYyWl4FQGeaDKZQhAZ+TS
ta1XJ+0mnKKFVQnxAxyVUNCFT9weV6VfPLDVNkERZ27UHKHZkfZK6U6CECvfvFWH
FAnYTRD3X4E/nAsPH5EBLRuIa5868I45LcPeSylis4ioOgTIoAkZx6hC8hgCLv6p
aGyVL+douIbEFALU67EY
=o/0+
-----END PGP SIGNATURE-----

--IS0zKkzwUGydFO0o--

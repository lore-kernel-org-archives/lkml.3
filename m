Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753050AbaBJNK5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 08:10:57 -0500
Received: from mail-ee0-f47.google.com ([74.125.83.47]:62767 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752831AbaBJNKz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 08:10:55 -0500
Date: Mon, 10 Feb 2014 14:10:51 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Erik Faye-Lund <kusmabite@gmail.com>
Cc: linux-tegra@vger.kernel.org, tbergstrom@nvidia.com,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] gpu: host1x: do not check previously handled gathers
Message-ID: <20140210131050.GH20143@ulmo.nvidia.com>
References: <1389124986-32501-1-git-send-email-kusmabite@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="aF3LVLvitz/VQU3c"
Content-Disposition: inline
In-Reply-To: <1389124986-32501-1-git-send-email-kusmabite@gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--aF3LVLvitz/VQU3c
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 07, 2014 at 09:03:06PM +0100, Erik Faye-Lund wrote:
> When patching gathers, we don't need to check against
> gathers with lower indices than the current one, as
> they are guaranteed to already have been handled.
>=20
> Signed-off-by: Erik Faye-Lund <kusmabite@gmail.com>
> ---
>=20
> Here's a trivial optimization I have been running with for a while.
>=20
>  drivers/gpu/host1x/job.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Applied, thanks!

Thierry

--aF3LVLvitz/VQU3c
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS+M/aAAoJEN0jrNd/PrOhCyUP/R8c2UA/zcFQ0Z7iR8PhtP1G
enatundvbaD2Iq11BxeUSLa5/tlJJxN4CcVXjshQI9rH/ntsd8K83LtgC19QZ3Pn
HNWGZKkBFDe3DXVt+aK2lVYtBNzeOjZYpnUXGQ3YaQjo3rOy9MjQ4cOi+nXEH6Uy
BYhNd1eIDWUbmWssz636JeYvtI0yXMY96a4IfWvY3kBUGufShoeTVA1GXpoJMyUA
xU+JRd6YkoZL/+11HKB3x4vHwdKLzmCES8Q9eSEAvTZ1dVaHZ+j8dcn07sYUkQlD
1Th4oGhmcS5oIh8FTpyckLrCviTzrVguqz5MhUKmamNqqwYKtHpFFvCqeTs7SH8O
CGSkbFwMXgFFU7LF+RbGkTRpRsz4CYD1SE7Kn6h7jn0jpYRZi/AD3xn0O9VMDuuJ
ddWa/vpgI0p1IqQIeQ6ol0H+0hgNhC1/QC1L0PFkjcp95uFTQeH+4ng/BAjmo8dE
M/+kDisJ1dl6Xwk3qmTcTO7mVC9LHlgkd4Ur5zmbSSj20y5bvJbyhTUxtM84SgcE
iQf6TK/wRSNptpRM60Ep1C9YOgVvw6MBlVAZ6dnUKfA5eOc/xuFFkBzPmr+p4Xt+
MICvzyu+mLnE++IzpJanS8bhntYDxPqpoBw5ZWmEAJfemb6wQO9U9z6W30k2ShDS
UmPskyR+I0eypxli1QN2
=tVjA
-----END PGP SIGNATURE-----

--aF3LVLvitz/VQU3c--

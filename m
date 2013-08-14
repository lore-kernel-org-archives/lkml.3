Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758477Ab3HNJnx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 05:43:53 -0400
Received: from mail-bk0-f44.google.com ([209.85.214.44]:56496 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751507Ab3HNJnv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 05:43:51 -0400
Date: Wed, 14 Aug 2013 11:43:47 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: linux-kernel@vger.kernel.org, linux-pwm@vger.kernel.org
Subject: Re: [PATCH 15/27] drivers/pwm: don't check resource with
 devm_ioremap_resource
Message-ID: <20130814094345.GC2084@ulmo>
References: <1374602524-3398-1-git-send-email-wsa@the-dreams.de>
 <1374602524-3398-16-git-send-email-wsa@the-dreams.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/e2eDi0V/xtL+Mc8"
Content-Disposition: inline
In-Reply-To: <1374602524-3398-16-git-send-email-wsa@the-dreams.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/e2eDi0V/xtL+Mc8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 23, 2013 at 08:01:48PM +0200, Wolfram Sang wrote:
> devm_ioremap_resource does sanity checks on the given resource. No need to
> duplicate this in the driver.
>=20
> Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
> ---
> Please apply via the subsystem-tree.
>=20
>  drivers/pwm/pwm-lpc32xx.c     |    3 ---
>  drivers/pwm/pwm-renesas-tpu.c |    5 -----
>  2 files changed, 8 deletions(-)

Hi Wolfram,

Julia Lawall just sent a more complete version of this which includes an
additional change to the pwm-spear driver. I've applied her version, I
hope you don't mind.

Thierry

--/e2eDi0V/xtL+Mc8
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJSC1FRAAoJEN0jrNd/PrOhEtAP/2IT55gM+Ak1uuUIIyv+UqVM
i8Qaj0qt85rYKBDGHEPyJ6GXMh9ftHmARpTlU2hp3T299lGVg6s02eeUCKEQhaYO
yeuC5Ifg999sCbW8GNvuMKEGnSjRfgCsBbgQjezBNyVUcTvgRQ5mJlTP0p/W8LC5
93aYmlwZbB8UAoOhoB3heQYInJi8HWmxg1hv3XGq3R7Vv+HpZnXy5TKSevNvjLIO
nQWJb7IM1PDnq9AlRRgsyav3o3YHNu7Ym54as99x6r85YzaDi2Nw4arXcJF9SHGa
r4cjpuTZ36Cigxz2WeQFrdZA39TXoEh4Q1sOAQSvt6o0BZNAhSdB69ygxea4fI4m
NhjT+0sk76gLT2fIX43XctNeH7CNuBllNKBqW3D3FG1MNf4SpZNWZ5Sirepgd0xP
0TYwfpqjchi+M9iwRKf9Cl/50UYbEUXimrnZFmxnaKkfp7xDjHxKWvNsv7nkLPgi
KIE5+WHx1f95qbfGnDNwcgTxyixDD+lxaT7JElwQ6JAbK7zR5VyD1gtNN1VGwqgp
4o8AQ1Pa8RrBuxVOraP/sS8CL0FDYouoEKo6USflNroIXtXe5k1pe3X4UrV99eI0
SyHNIrWccyShx7mFwcK5PxwNPTtk/q/I6UdMW97YY18aBWRQV/Yq5aULNCp6aS0/
tN/cqXCov/wzdm3ya1lM
=mUQk
-----END PGP SIGNATURE-----

--/e2eDi0V/xtL+Mc8--

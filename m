Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750883AbaLOVqi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 16:46:38 -0500
Received: from libra.uberspace.de ([95.143.172.171]:37856 "EHLO
	libra.uberspace.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738AbaLOVqg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 16:46:36 -0500
Date: Mon, 15 Dec 2014 22:46:30 +0100
From: Matthias Beyer <mail@beyermatthias.de>
To: Jack Wilson <jackwilson128@gmail.com>
Cc: gregkh@linuxfoundation.org, davej@redhat.com, ebru.akagunduz@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: bcm: fix spaces before commas in Bcmchar.c
Message-ID: <20141215214630.GA3151@fu>
Reply-To: Matthias Beyer <mail@beyermatthias.de>
References: <1418671349-4014-1-git-send-email-jackwilson128@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="xHFwDpU9dbj6ez1V"
Content-Disposition: inline
In-Reply-To: <1418671349-4014-1-git-send-email-jackwilson128@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--xHFwDpU9dbj6ez1V
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jack,

bcm is removed from the linux kernel. You are working against the
wrong tree!

Please work against staging-next of gregkh for staging drivers!

Ask me if you do not understand what the problem is!
Feel free to ask me other questions as well!

On 15-12-2014 11:22:29, Jack Wilson wrote:
> This is a patch to the Bcmchar.c file that fixes a space before comma war=
ning found by checkpatch.pl.
> Signed-off-by: Jack Wilson <jackwilson128@gmail.com>

--=20
Mit freundlichen Gr=FC=DFen,
Kind regards,
Matthias Beyer

Proudly sent with mutt.
Happily signed with gnupg.

--xHFwDpU9dbj6ez1V
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUj1a2AAoJEJi+S08gyg+UNycP/2aze2zbzs+idTi35/rPqzIu
Ph7kLJLdqRmmIxAkM5DZdFRHeq3JQQtbucFIZ63GScaEM8CQkULaAyADGYEc133p
Y+qp9Pp+nZKd6eJFS2KHEHjrp9Z/+WWtXUNDc5Fge0XaQkbNuTi3ZHxnnr+rMQBs
HjqebG0l5yBrA3xVVmNTzJiFYr0ls4u/Hn2YblI3dUXf7lSxUAu+NaYMssyoqVlW
ij7fIYl6T/RUCODzh9DMGUjPf9/5l84OaUEgs5CyuJ9blWOSbxh9AhNRZNO3Y1/T
dp1hFgcp8OpX68bZQNHLmrruplVBzjNpggV2CUG7uEbApeUGWlWNAP7oP3mdqFQb
aPABMi/BfB3fIgRANv4C51hlncBQx5Q3Cp1VGqBafnDd2pxlSLI7xLaeI5m7JOP0
membrwnPzMN2TEjpvsD1NheB2U/frr0/9YNKedx68TEc8wi0p6j+PfMdixJd3M9d
jj2l3SP/3vJGlHPgur2jc5OlxkBtoMw9u1WataW9Mv8b4tMEppUEIQ2ZAz1zjzJA
UpLj6hRpNu4AjsC6dSizYwfP5lp2r5694ZkYLI17UZHw/XNYJS+iair8kJJLzqY1
ypQ02sG/FpnXs1+ypw4kmlILI0EQABghTfS765vhKytq8RiJCCeqNZLx7FR9JXWN
GyWHDiykRkgL968ZphCM
=dvYL
-----END PGP SIGNATURE-----

--xHFwDpU9dbj6ez1V--

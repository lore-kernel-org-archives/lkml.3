Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753278AbbAUUpH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 15:45:07 -0500
Received: from mail.kernel.org ([198.145.29.136]:35136 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751526AbbAUUo6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 15:44:58 -0500
Date: Wed, 21 Jan 2015 21:44:47 +0100
From: Sebastian Reichel <sre@kernel.org>
To: Jonghwa Lee <jonghwa3.lee@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        dbaryshkov@gmail.com, dwmw2@infradead.org, anton@enomsg.org,
        pavel@ucw.cz, myungjoo.ham@samsung.com, cw00.choi@samsung.com
Subject: Re: [PATCH V3 01/11] power: charger-manager: Use alarmtimer for
 battery monitoring in suspend.
Message-ID: <20150121204446.GH13715@earth.universe>
References: <1418979323-7188-1-git-send-email-jonghwa3.lee@samsung.com>
 <1418979323-7188-2-git-send-email-jonghwa3.lee@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="xQmOcGOVkeO43v2v"
Content-Disposition: inline
In-Reply-To: <1418979323-7188-2-git-send-email-jonghwa3.lee@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--xQmOcGOVkeO43v2v
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Dec 19, 2014 at 05:55:13PM +0900, Jonghwa Lee wrote:
> To guerantee proper charing and managing batteries even in suspend,
> charger-manager has used rtc device with rtc framework interface.
> However, it is better to use alarmtimer for cleaner and more appropriate
> operation.
> This patch makes driver to use alamtimer for polling work in suspend and
> removes all deprecated codes related with using rtc interface.
>=20
> Signed-off-by: Jonghwa Lee <jonghwa3.lee@samsung.com>

Thanks, applied.

-- Sebastian

--xQmOcGOVkeO43v2v
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJUwA+7AAoJENju1/PIO/qao0IP/37jVEZrzL/TcxlHZTpk3Zbl
7jey7+yb18ER0Eb2dziYyWDnGSDZLIheOgwLebr6QAYcYcS7tKamFJugS6L377zt
GkDcWkSeR2ybVRVMiKTNFVqkLEq1xGrPad11r7g+WlSckdUtfQlPcCpu/42jRwL/
ijKT4KU6NMfZlFZpSihc023dHTwYIKlukEvFY8v/NbqHLUz+mG1T3LrasQ0ori5h
xCKvjRmQl8cM6nb4PaSF/eKpdUV39mofSUklUIk6BN8iKlvO8YKR6HDGcGw9lPi0
OHbBLA+VPZpPQr6LBOsjDhOUVZr9eEQybJFP7zPvAkJrriWCORqu0z3frgUO0+o2
OesN5lQCzG0piMQGcG0bJe5ED/S3wdasEdAcbcaFBr3JkIjy6ATSpCyILWBB1Kvk
tn8kLHW5FpyD8qjA+/IY1qs3YNo8hKxn6EpGO4iR4AuVkoCKdBZNR1553LooKyWi
MtBbyawTYy3+roGCFXfgP87xxPCx9F2obLyacGfj2EEidCvatuWKAi3kqJJWQGh8
oasjK4quoKKTGMhxBG5vOdAyniiFNAaEdvZspMHVHR8CYuKOdCGOUCNUUyX4TyLW
YVKizgLvbwONXQoFm+KwW0v7FhlrIUDLXK81Spofuyl26NEURjXWpP2wRtEmTGh7
qR2LQTCbo6o4F6a23U+d
=bwgb
-----END PGP SIGNATURE-----

--xQmOcGOVkeO43v2v--

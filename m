Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753640Ab3KGCsF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 21:48:05 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:56526 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753336Ab3KGCsC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 21:48:02 -0500
Date: Wed, 6 Nov 2013 20:47:44 -0600
From: Felipe Balbi <balbi@ti.com>
To: Jisheng Zhang <jszhang@marvell.com>
CC: <balbi@ti.com>, <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <shawn.guo@linaro.org>
Subject: Re: [PATCH] usb: phy: phy-mxs-usb: set the correct platform drvdata
Message-ID: <20131107024744.GA11057@saruman.home>
Reply-To: <balbi@ti.com>
References: <1383791180-3579-1-git-send-email-jszhang@marvell.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IS0zKkzwUGydFO0o"
Content-Disposition: inline
In-Reply-To: <1383791180-3579-1-git-send-email-jszhang@marvell.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--IS0zKkzwUGydFO0o
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 07, 2013 at 10:26:20AM +0800, Jisheng Zhang wrote:
> We need to set mxs_phy rather as the platform drvdata so that we can get
> the correct mxs_phy in mxs_phy_remove().
>=20
> Change-Id: I6e1753cc978e2ed3fbb3d1865be0c54031d337d2

please strip Gerrit-specific tags from commit log.

--=20
balbi

--IS0zKkzwUGydFO0o
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJSev9QAAoJEIaOsuA1yqREyp0P/RuTZkqH6MVidJX16x5q0rXw
/YgcGBMcdqodf1XKstqBgrGW7O0Da5BKxCQYe3McYKkBZkXyadfDQ61IhhGcBSXy
gX3q2egLFER50Ul1KP4fJEClRrinJA1RFMdQbz2eMsHU66iRXF9VwHqqisdupYUY
Ng2sg3kLkWpiQibX0gtu5BfXU4O73fAPXRAtzAZxevlMOd2TjOCeNN9oup7pMuxC
xt+WMv6eCrn2LA4jyXOqR3SaozFMW9LDU4xx4+WOJGT3JKm9KA0zLt8H5I6MW3yY
7E1DWw6gc9/slOC0lBGUhyfTJibjJ+xGpZ2HbUaEB/dIqDMtEisfKHvMESdhMz5B
/OPP9RrmbRPxDk/S/tcNbOBh54nGR3VX4djsB+uKvg/mBoHrTw6TKgjq0bZxm1qw
1Lo/UUGKYwuQ9gGI5Ey4WJQefObCgFuXoMjMyEKi1Iqaytn0093oFdhDJxYN5ZAT
TdAgfi96BFvCgdN42ASOoy1CnTxT3Cct9F7H4hUal48WoNw50+x6AhbqjfTB+jO7
FhpmO7Av+qeX7MBRo913D0NOUOH7OeDjrqlTciA8DAKnIU8iN9UfrvE5FOsnmTnU
pt/AYozH82GPT1kzrwFjzLH2zEHKHRA/bpcOuwt4y/bD8FSSy1XzsSEwj5TUHLl7
MJR+Wy8FU78/v/1EfG/H
=YrZT
-----END PGP SIGNATURE-----

--IS0zKkzwUGydFO0o--

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754826Ab3DOQWL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 12:22:11 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50035 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752573Ab3DOQWJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 12:22:09 -0400
Date: Mon, 15 Apr 2013 17:22:04 +0100
From: Mark Brown <broonie@kernel.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: MyungJoo Ham <myungjoo.ham@smasung.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: max8997: Test pdata by NULL checking instead
 of IS_ERR_OR_NULL
Message-ID: <20130415162204.GI15837@opensource.wolfsonmicro.com>
References: <1365861943.3814.3.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LYw3s/afESlflPpp"
Content-Disposition: inline
In-Reply-To: <1365861943.3814.3.camel@phoenix>
X-Cookie: Be careful!  Is it classified?
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--LYw3s/afESlflPpp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Apr 13, 2013 at 10:05:43PM +0800, Axel Lin wrote:
> pdata is either a valid pointer or NULL, use NULL checking rather than
> IS_ERR_OR_NULL macro.

Applied, thanks.

--LYw3s/afESlflPpp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRbCkTAAoJELSic+t+oim93J8P/RpArN9U2VQV36Wc/OWMZRej
tzpldo6C9TODNAISD6QnyTkAwZNAoBkJz4nBRXCyox4b9dS46MWStQkbWNUlf6ij
r7RzyPpQqaCbJvO3koJzHH1rVTqZ45iGsWr39bvNv34D0hx2ujAWwDCV7bcdPPAc
+xM6skNZD6Bnpl8xl1Z4DSFaODWBYkpUmtRLCQNlUR6fPdR94J2aidEja8Rhuzgd
do6QBW2QRiqP2+wYm9qLqBfD2Kn5LDZYhCzrbdh8yzx5+IN7RyHsFIH1C+DfDoPD
J8pvgyPxsvgvMA+BkBaBKJVcnTWz2OuBhM0DkGz40AdNYnLJOyhxX3KuS0k7uhcm
HvdjQUjDaJc/vFPXT3kH6p458NCxrVQ5BNYffI92LBIfoP+GRDRSCoMe9nwlME2S
ho6TEyfOSdzw3d+wSf7ZGJtKjiEUHgYvLJM1adFop8dUcY1UHWVmblgB+S9WAvvr
upP4N46wfh4sVI012xNc+2ZX8Jv1rBLGN6UBp0DWP1ebYgHHseWfzKJS5ZYgQCC2
GJ5vUEsi94B76h06KMCYZBl6vzY8g660ISYMxLu7XuAiv7KcNVOqCxWl/YPLcVQ7
8/NAsBdiObcpZcOR1NqMpf7V0KSV3ISK/krIYK8/+VUS7aKUeKc+hA/kHKmKqUPk
frfcODa18lRD9awb5awr
=oEe5
-----END PGP SIGNATURE-----

--LYw3s/afESlflPpp--

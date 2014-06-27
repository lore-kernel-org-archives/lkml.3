Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753633AbaF0LvN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 07:51:13 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:32885 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752779AbaF0LvM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 07:51:12 -0400
Date: Fri, 27 Jun 2014 12:50:48 +0100
From: Mark Brown <broonie@kernel.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Nishanth Menon <nm@ti.com>, Aaro Koskinen <aaro.koskinen@iki.fi>,
        Rajendra Nayak <rnayak@ti.com>, Liam Girdwood <lgirdwood@gmail.com>,
        linux-kernel@vger.kernel.org
Message-ID: <20140627115048.GK23300@sirena.org.uk>
References: <1402883060.4707.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Umuxdmn6ztF4e1GK"
Content-Disposition: inline
In-Reply-To: <1402883060.4707.1.camel@phoenix>
X-Cookie: But it does move!
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: twl: Convert to use devm_kmemdup()
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Umuxdmn6ztF4e1GK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 16, 2014 at 09:44:20AM +0800, Axel Lin wrote:
> Signed-off-by: Axel Lin <axel.lin@ingics.com>

Applied, thanks.

--Umuxdmn6ztF4e1GK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTrVqVAAoJELSic+t+oim9OtkQAIWc2l+P6Ys5oUQoNT7dT5V/
0N+FystFEEIO2x9MzcTQaLrKGrj8EjQOFYjSxQ7hTpxrdOzbqPVyn6F3Iym2D9Er
kXZ6w17yVX9kbIzRm7nPqBxJ96LPmncfK+pCvKnyenKDUSipamYanwbjZHEELsZk
LWXzwc8IYnHANvep/Q+/1Syao9ERkxF7cUKpnhNlK812HUUzRgi9ZGq7PrtCNELN
rZbNkRSjWbgyddRPw9hgh/t8r/ybk1+dXBkKFRM4ZaaZyPYEjkiYLNcvoVG/y/mF
54LgVy/zEzYPPCzgH0mmvRu9E4WT+vf1LhlowqksZcn6L4fwM4l0OV6WWhy9wX3Z
csvjAY/Kx1pXLqkPw0jKY1ah7DV8qWvowpnk8quLY0+ThoEQWN05NMWndgieuomN
mecho/vTEIlXYLDgB0ntNKbW+8COmji1aMrdOxDFCc2/egf7JE2zyBVX3h49zAzx
UFa+DzwsPRSAqQZ5NnyA3BeGVHd5wzHLvWcl4XorFFQerf6p9uFCIvVAOiZPoB6A
+dzs2a53i7zu7wBWs9dascBBd8vWqauCvpMEAcoNly6LfEYSYBr3LldUSAhBcji8
r7dADFYVC/7h3Tv4xVQJzeFFPHE/WVkm4RxClKHuFWIj4eW4KTYg4F77EdscLJys
6xEmUPK853lqyAGAXxpi
=o0LW
-----END PGP SIGNATURE-----

--Umuxdmn6ztF4e1GK--

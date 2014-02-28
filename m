Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751228AbaB1Dwu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 22:52:50 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:53431 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750742AbaB1Dwt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 22:52:49 -0500
Date: Fri, 28 Feb 2014 12:52:45 +0900
From: Mark Brown <broonie@kernel.org>
To: Xiubo Li <Li.Xiubo@freescale.com>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        shawn.guo@linaro.org
Message-ID: <20140228035244.GJ9383@sirena.org.uk>
References: <1393494593-26310-1-git-send-email-Li.Xiubo@freescale.com>
 <1393494593-26310-3-git-send-email-Li.Xiubo@freescale.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qX4XtzAfKSOolMWY"
Content-Disposition: inline
In-Reply-To: <1393494593-26310-3-git-send-email-Li.Xiubo@freescale.com>
X-Cookie: Q:	Are we not men?
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 175.126.181.153
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/3] ASoC: core: Set the default I/O up try regmap.
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qX4XtzAfKSOolMWY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Feb 27, 2014 at 05:49:52PM +0800, Xiubo Li wrote:
> For most CODEC drivers which the REGMAP is used, the soc_probe_codec()
> will do the stuff work of snd_soc_codec_set_cache_io(), which the CODEC
> drivers' ASoC probe will do too, and almost at the same time.

Applied, thanks.  I did a check of the drivers and it looks like they'll
all be fine with this.

--qX4XtzAfKSOolMWY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTEAgJAAoJELSic+t+oim9GW8P/iM1Bj5AYtYOMVNvj60H5dih
by5bZwjJt0gWLdZdmFp/WmVvtQoxD0AweSTDTPLcgq3GkTsofZiNEXLjAmmw9aas
BVtNvzwe6RjvdSoHsy+IFpU/U/JPfvZlmifnye+UVnxBvtsmHWrl4kcb+G/emKXD
RDqB8cGYyYPjd1+CoPheDpWCGuZxHMMCzBvWxtXNe+9RBJ2BTctiKuIANo4GhK3/
51LTmu71cmB9ppdWspxVzMxZjfRnuIJU+8NII9DHhtUsKHM7wLGQJnzpOJZWRJ4K
RPTxY4x2ZTMBswitiMCMxAKSgnhWZeu6bgzMiHCY+9+HVuhMExsoCXCwdc6xSXo9
D4Ti13oRn3gVWoS1ta+km3pXcQe1LDCxklSCPaqXdXjjL5k16VxEZdR8L9626Q2u
InIcPfRhWMH7bealuOR1MtNayswHsQx7+3F76t7W0fBmBSNsaiv5VViqxRTp0igs
K7w1wmL8DsTroD2LQMJvafsm0cz8TcCSCFciSLH0VHzupkzkHdvFbMdekjvTxyuR
Ux++3JIEBKsnyg3iVsQUa64fe/5Dq5wEiT8hZpF/J3UbLR0M86nivOwACH5OzYnM
0qK9FX4WK9MMHhOIVXmH9qhCG572sVH+8zoKkN7p1nhHD076jGBcVWVQ7Qp/Wi6Q
YzxZYV6RXCK7SPQUnILc
=A21A
-----END PGP SIGNATURE-----

--qX4XtzAfKSOolMWY--

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753860Ab3JRNFL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 09:05:11 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:59403 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751883Ab3JRNFJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 09:05:09 -0400
Date: Fri, 18 Oct 2013 14:05:02 +0100
From: Mark Brown <broonie@kernel.org>
To: Fabio Porcedda <fabio.porcedda@gmail.com>,
        =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>,
        "David S. Miller" <davem@davemloft.net>,
        Enrico Mioso <mrkiko.rs@gmail.com>,
        Antonella Pellizzari <anto.pellizzari83@gmail.com>
Cc: Thierry Reding <thierry.reding@gmail.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-ID: <20131018130502.GM2443@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="QEr+vra0hNKo+jz/"
Content-Disposition: inline
X-Cookie: Time and tide wait for no man.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: linux-next: manual merge of the net-next tree
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--QEr+vra0hNKo+jz/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Today's linux-next merge of the next-next tree got a conflict in
drivers/net/usb/qmi_wwan.c between ce97fef4 (net: qmi_wwan: Olivetti
Olicard 200 support) in the net tree and 905468fa (net: qmi_wwan: add
Telit LE920 newer firmware support) in the net-next tree.

I've fixed up as below and can carry.

diff --cc drivers/net/usb/qmi_wwan.c
index 818ce90,d03b6b6..0000000
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@@ -714,7 -729,7 +729,8 @@@ static const struct usb_device_id produ
  	{QMI_FIXED_INTF(0x2357, 0x0201, 4)},	/* TP-LINK HSUPA Modem MA180 */
  	{QMI_FIXED_INTF(0x2357, 0x9000, 4)},	/* TP-LINK MA260 */
  	{QMI_FIXED_INTF(0x1bc7, 0x1200, 5)},	/* Telit LE920 */
+ 	{QMI_FIXED_INTF(0x1bc7, 0x1201, 2)},	/* Telit LE920 */
 +	{QMI_FIXED_INTF(0x0b3c, 0xc005, 6)},    /* Olivetti Olicard 200 */
  	{QMI_FIXED_INTF(0x1e2d, 0x0060, 4)},	/* Cinterion PLxx */
 =20
  	/* 4. Gobi 1000 devices */

--QEr+vra0hNKo+jz/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSYTH7AAoJELSic+t+oim9hAYP/RkuyuxmDdliMbQAgq2WmV4w
qmKrg537XxM5yqf4ov4b4vnin5OLa+12ZqKxm/dS+MrosUV8f64owM+nuh5sHX+m
kNKRXWHhqdCGU/30+5ypGds1lkjM4dTSUjAB97+jXTVvDRlgoMHYF9fEiUB0HWUx
NGJcLNS8txpJAcxk2J1hWrxP5aQE0nyWWSK0oUQphSAY+vS3hRL359o58gt0e8K0
oeWp1nUxdJ7jY8KezIyZkfa7UKkO59Eu4oup3oPzkiG6cq9RHphrNtbop2hg6Jyu
Cee8NIwHSFKbU9r/Ua+GDzZbWBCCKoPVaycvtPRRYFDqVEO84cv+j97mAZYZssAF
0JUmzAZBRMHYNdNXJL6bZH3yQgCJ8udmI1ehmgCAeYn+42qQli4ZtF05f4dEBiWI
Hxtl01Ln5Wrq4fRZLiZawn44jLHSLAAoKHQ/UvTv8h11YZV2UHySxvL/ZxhHkyUE
qp8cEA9QgKVfdkeq1sQKRSh02DgAnyc7/67KfzIXxC9oaSnM09kyrQr9IOMIVRa2
kuSVXfdmM+gzxJZlkyA1p1TrwXMpe9XVh7qKFbIGMXdTL6lEd0SBPuBwNGIJkGcx
xUMsrsdPRnNj1ucOjxnGwtRaAZB4MsoSZnUC/Ch1NKJeVJbYEylv02DYilboQhkr
CuR7B1V3BraDrDdQ273S
=YxNQ
-----END PGP SIGNATURE-----

--QEr+vra0hNKo+jz/--

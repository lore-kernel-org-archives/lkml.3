Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756155Ab3GYOdH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 10:33:07 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:52661 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755882Ab3GYOdD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 10:33:03 -0400
Date: Thu, 25 Jul 2013 17:32:53 +0300
From: Felipe Balbi <balbi@ti.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
CC: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <balbi@ti.com>, <george.cherian@ti.com>
Subject: Re: [PATCH 01/16] usb: musb: dsps: init / shutdown the phy
Message-ID: <20130725143253.GJ16106@radagast>
Reply-To: <balbi@ti.com>
References: <1374516607-2705-1-git-send-email-bigeasy@linutronix.de>
 <1374516607-2705-2-git-send-email-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vzUQzca511KWT6Hk"
Content-Disposition: inline
In-Reply-To: <1374516607-2705-2-git-send-email-bigeasy@linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--vzUQzca511KWT6Hk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 22, 2013 at 08:09:52PM +0200, Sebastian Andrzej Siewior wrote:
> If the init / shutdown function of the phy moves out of dsps into the
> phy driver, then dsps needs to call the callbacks of the phy driver to
> ensure that this happens.
>=20
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

cool, eventually we should move these calls to musb_core.c though.

--=20
balbi

--vzUQzca511KWT6Hk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJR8TcUAAoJEIaOsuA1yqRE8iEP/RtyYdIJaf9m+iKDs5j1cACp
1cuxVKv1YMMDy/c6W9UYQX67N4+/UW2ahCPbExghdetiQIXyShWa59JhQRoc5goH
iC5AwrWgGxX14BVKI6tPaw3I+SDxA9c0q0aiUXY2iEaxaDXCNKEQO/B5z3DLuQXo
T8R9GxsLF0pc3g/lN9x5pRAgQ1oIuh4s4gDQKBy1E6fCIiYMa2cessnKyYgE+rIB
ygybhddAeTBXTRhLUgDYDAqBBrjUXKekSl+RX9kcGp5bFWNRMfAiq3K9ec/VvMNV
CIuVUEi2pmCrXfaLa3uzZyzFs7+wTMma05TfqaIRR/IkVcQBPo7Z9OyKpS+G8Dby
iqXddbpDt8ywBPtF8BsLyBJ9kQaoilFWHir+i7iRcJekbN1nyUX/dmnrMfGSUDVo
1xUnL2/YQb+I1usvF/L2aZxdX6aDRCvidT3Vzg3SoYgKU8tiGFC1czakdzvbr5zq
NNJNXN3hvrAu55FgUH3XPuITj/to5s1JmAboH8FvRX9Zub8POI3lcFIJ8qM3SGRw
C1xGwfec2yayCJ4abLtdC4R7bVSGAPniX2Gl+2e+s3VCasHnVRYKfyR8hHLU0PQq
MOLoC2k6kkeeuiNOEP+Abx4Jnj/cSNV/W35vH3K9tE2TCsC1Ifr9+673VlertZFb
iYF5Kpbup34Veoe/TY3E
=Fani
-----END PGP SIGNATURE-----

--vzUQzca511KWT6Hk--

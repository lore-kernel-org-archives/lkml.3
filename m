Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753347AbaKRHMb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 02:12:31 -0500
Received: from ozlabs.org ([103.22.144.67]:51962 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750977AbaKRHM3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 02:12:29 -0500
Date: Tue, 18 Nov 2014 18:12:22 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Felipe Balbi <balbi@ti.com>, Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wolfram Sang <wsa@the-dreams.de>,
        Dinh Nguyen <dinguyen@opensource.altera.com>
Subject: linux-next: manual merge of the usb-gadget tree with the
 driver-core tree
Message-ID: <20141118181222.451b84d1@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/fvqEJoylb+fRgxq1lRTEgdO"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/fvqEJoylb+fRgxq1lRTEgdO
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Felipe,

Today's linux-next merge of the usb-gadget tree got a conflict in
drivers/usb/dwc2/gadget.c between commit 7c3e90537b74 ("usb: dwc2: drop
owner assignment from platform_drivers") from the driver-core tree and
commit 117777b2c3bb ("usb: dwc2: Move gadget probe function into
platform code") from the usb-gadget tree.

I fixed it up (the latter removed the code changed by the former, so I
did that) and can carry the fix as necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/fvqEJoylb+fRgxq1lRTEgdO
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUavFaAAoJEMDTa8Ir7ZwVB5oP/jbHkEHldbv+/xXndTPS7c7+
zpfF0QJXqv8MMGQiKRquGcZTUuOdWMVNknkFqiR8ToIbbrySxc/+Hznj625iOB21
vKoqRfo8sZJ08aMqE2M2dOFkW2II5deNMqyNSi+y7mmSPD8YVvUJIttjalI3/p4s
/KnHqD8GhVBKkcP06Vzjky+bk+44pW2W+5wgFiDQfVF+sWw+6oi1E73g2j9CW4Jn
1lLrCpyE0Av8ZtrPMoGkpOAPRUL+XuBj9YQhF5GqNgh19ETgW2C1H78S6vER4QNL
A9+nxQnvSddZYnqXXA66E0c+vatWcUTd5RC2XCCRHXTYa1RLhhNAMyusa8VQ8yOG
WZ4C8nQDoVNgA4w7LvkoIarSUWJ28lLPFNZWErIwlYHeGmGYSELbnPNtkvfOmJ8b
0xKz/7jkI0dQH/YivDll8UeZZ3ANwZoeJpguCf3/UaAoni31e33RUFTGl6t2/cCK
x+2Rgd6InHUb8lyWG32T1bGifi2KoG7JV/FjiUUo+iZQEAGlngH2gY4sOxu3OcVQ
+HhUM4cIltmmhuYpiQrVneJzuXmkWkYsD7VdlQRWxazO3/c1Az4uBF5IW0kSfpBG
++w+asuM8MJ/SN33WNU9+KooqYrxBMiBGLgcrqPUNtMPW7EX+mkeblv6cXXzJgdK
dJQIP51dHl1WvHYzDneo
=uxCK
-----END PGP SIGNATURE-----

--Sig_/fvqEJoylb+fRgxq1lRTEgdO--

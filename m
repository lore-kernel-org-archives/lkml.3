Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751891AbaHJX6j (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2014 19:58:39 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:49796 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751407AbaHJX6i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2014 19:58:38 -0400
Message-ID: <1407715088.3017.73.camel@deadeye.wl.decadent.org.uk>
Subject: Re: Bug#757733: RTS2557 SD card reader does not work
From: Ben Hutchings <ben@decadent.org.uk>
To: Wei WANG <wei_wang@realsil.com.cn>
Cc: Philipp Hagemeister <phihag@phihag.de>, 757733@bugs.debian.org,
        LKML <linux-kernel@vger.kernel.org>
Date: Mon, 11 Aug 2014 00:58:08 +0100
In-Reply-To: <20140810225012.3425.19201.reportbug@t4.home.phihag.de>
References: <20140810225012.3425.19201.reportbug@t4.home.phihag.de>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-ZItdZSXCxIr7iBMJh1Qd"
X-Mailer: Evolution 3.12.2-1+b1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-ZItdZSXCxIr7iBMJh1Qd
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2014-08-11 at 00:50 +0200, Philipp Hagemeister wrote:
> Package: src:linux
> Version: 3.16-1~exp1
> Severity: normal
>=20
> Dear Maintainer,
>=20
> I have a Lenovo Thinkpad T440s with an included SD card reader for which
> /dev/mmc* devices do not show up. It seems to be an RTS 2557:
>=20
> $ lspci -v | grep RTS
> 02:00.0 Unassigned class [ff00]: Realtek Semiconductor Co., Ltd. RTS5227 =
PCI
> Express Card Reader (rev 01)
>=20
> With linux-image-3.14-2-amd64 (unstable) as well as 3.16-trunk-
> amd64(experimental), there are no /dev/mmc* devices (or in fact, any new
> devices) after inserting an SD card (which works fine on another reader).=
 dmesg
> shows this error:
>=20
> $ dmesg  | grep rtsx_pci
> [    0.881602] rtsx_pci 0000:02:00.0: irq 57 for MSI/MSI-X
> [    0.881619] rtsx_pci 0000:02:00.0: rtsx_pci_acquire_irq: pcr->msi_en =
=3D 1,
> pci->irq =3D 57
> [    0.980400] rtsx_pci: probe of 0000:02:00.0 failed with error -110
>=20
> This error shows up at boot time. There are no new dmesg (or syslog) outp=
uts
> upon inserting the SD card.

A web search shows some similar reports (e.g.
<https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1329566>,
<http://askubuntu.com/questions/473848/ubuntu-14-04-realtek-semiconductor-c=
o-ltd-rts5227-pci-express-card-reader-isn>).
But in that last one, it turns out that the out-of-tree driver does
work.

Is there anything Philipp can do (e.g. debugging options) to help get
this fixed?

Ben.

--=20
Ben Hutchings
Humans are not rational beings; they are rationalising beings.

--=-ZItdZSXCxIr7iBMJh1Qd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUAU+gHIee/yOyVhhEJAQrC7RAAlnJpJGxuzwIye5wvAFadflC+zA5jLZ9j
P0Wk4UEUmq4/43umcOlfZpNy/ieYmaltV13SNFvY1lp4zmFgBGMsIzggYFXGBMl6
xtzC7R0HNzFuzhFY/GRA23fH3KGHDFupgP6os/BsQVU3JyPugXaRynLJFy86zly0
MWBuBJJsQ5DEE+qoi5mh815j0SiF6vHEvltOrsSPwr4uIehzsPAtMyMIzoy+G+x3
1m9ssKBtKx7gEQgQz3ouGRdDBIMJEDRhMG5E4BeaulH8VEFQZfu4FHEGl17/2aSm
eGv5jaugyF6wPtRYHmKzQEPLbSeeQCl63HIle5hlzzeOFU9YSlYpnqw12lFCyb4v
xqfYKmr9DHw1rQs1n/idHgxzVDy2QUDsNeuGpCK7iZE7J0J8XIhitcIOsiIGffez
qbLs6EBN9BGTLLH2ZZTFJIoHtkDHJ3mLGuls4PKfsDByQKjVtmXUS7ecvRt7cYXj
dh9Sy9qeDIiDyRpL67hQCAJVrG7NzmD9q280W3BuZFy6+giGcX+d/CSWVMrRWk+A
t8ZfNQKmW/kTByYtSu/3kcNdlvpVnQ/WSvqC+OfeM0gP8P0Y9SaPOQDm8jtauw9H
3ZmWMujSd1Key6kOxW9BZDTqowORZAH3EzvRGQYI8q44fAoP/hnOT2MaBAl+3nJn
b/XexrjS6lQ=
=vXQf
-----END PGP SIGNATURE-----

--=-ZItdZSXCxIr7iBMJh1Qd--

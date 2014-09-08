Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752866AbaIHHCX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 03:02:23 -0400
Received: from ozlabs.org ([103.22.144.67]:50247 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751424AbaIHHCW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 03:02:22 -0400
Date: Mon, 8 Sep 2014 17:02:12 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Felipe Balbi <balbi@ti.com>, Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Chen <peter.chen@freescale.com>, Stefan Agner <stefan@agner.ch>
Subject: linux-next: manual merge of the usb-gadget tree with the
 usb.current tree
Message-ID: <20140908170212.133cb6e0@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/Sf2_//T5eV/7Szq077FJb.m"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/Sf2_//T5eV/7Szq077FJb.m
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Felipe,

Today's linux-next merge of the usb-gadget tree got a conflict in
Documentation/devicetree/bindings/usb/mxs-phy.txt between commit
36687e305651 ("doc: dt: mxs-phy: add compatible string for
imx6sx-usbphy") from the usb.current tree and commit d0ee68b59e6a
("usb: phy: mxs: Add VF610 USB PHY support") from the usb-gadget tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc Documentation/devicetree/bindings/usb/mxs-phy.txt
index 96681c93b86d,fe3eed89e4c3..000000000000
--- a/Documentation/devicetree/bindings/usb/mxs-phy.txt
+++ b/Documentation/devicetree/bindings/usb/mxs-phy.txt
@@@ -5,7 -5,7 +5,8 @@@ Required properties
  	* "fsl,imx23-usbphy" for imx23 and imx28
  	* "fsl,imx6q-usbphy" for imx6dq and imx6dl
  	* "fsl,imx6sl-usbphy" for imx6sl
 +	* "fsl,imx6sx-usbphy" for imx6sx
+ 	* "fsl,vf610-usbphy" for Vybrid vf610
    "fsl,imx23-usbphy" is still a fallback for other strings
  - reg: Should contain registers location and length
  - interrupts: Should contain phy interrupt

--Sig_/Sf2_//T5eV/7Szq077FJb.m
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUDVR5AAoJEMDTa8Ir7ZwVBLEP/RxrPysRucC+MG6/sEmIxPa/
hOMMelYvRH/Fsnn87Fdaca1alEqv3G7a/Y2CioqbytUoACfrU+0Flol9vmdhysme
D3vBJsIgOCRB4RalEAn7I8jkDn20QrBeA1SCLbHyLkPkXbcEiq5SP4b+0XTrw+Rl
PVAnBXfQgOd1szaA/s1R+m9nAng9lmz9LG8tpGnIlMYTK+R/fI7+xAX+CYZEvKQu
7Y6Zd9rkocap8/2MFmr8ORPDbKD8AXtBxMwB0S1CvO3EZyWeV71zz72XeqS+TeoJ
98eU7nGTFSnSNOQ1vYxVk6I/cRGth+jmgnVYpN4hnE9fSN33saV6or15j6ig/Z/o
5LHApAmbsxcLl/Iq9KFRVPs70anxUxxhP//En1v7K8LgzqbZyZCfUADj6cRkDPJ8
xYcnKkklSQ+3hsWHS0NZMtSyWIxAps8qwmDVy4JmENs1nzfLb99PuFBwS4guvBO3
r3fZJp0l45NGJUw3pPCb9GkT9o2XFu76fnJj/dkOTnkUoP8bo6MmUGuRLOSTY+E+
8l1KP0r2V3Ysc7XR/S/OJFZ0I8Jolcfk8sdDJfJEGTyanGK4G0byIJhJZft+EeUs
15QsV9Yw64/rXj+kGG2vRebDMcj4ler/MeOOPUAEHKtHb2cbZZ0gWg2STxWa6fuV
+pZ/9LeNR78fmKjs7CLd
=PwqZ
-----END PGP SIGNATURE-----

--Sig_/Sf2_//T5eV/7Szq077FJb.m--

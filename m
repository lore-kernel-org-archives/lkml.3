Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752656Ab3FRGMv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 02:12:51 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:57809 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752165Ab3FRGMu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 02:12:50 -0400
Date: Tue, 18 Jun 2013 16:12:39 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tushar Behera <tushar.behera@linaro.org>, Greg KH <greg@kroah.com>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Subject: linux-next: manual merge of the arm-soc tree with the usb tree
Message-Id: <20130618161239.5ce92432180d9418831d2514@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.18; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__18_Jun_2013_16_12_39_+1000_Sj5w0UsGeWh=SraL"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__18_Jun_2013_16_12_39_+1000_Sj5w0UsGeWh=SraL
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got a conflict in
drivers/usb/phy/phy-rcar-usb.c between commit 56a9a6de2a87 ("usb: phy:
rcar-usb: Fix comment w.r.t. devm_ioremap_resource") from the usb tree
and commit 725bf9dcafe1 ("phy-rcar-usb: correct base address") from the
arm-soc tree.

I fixed it up (The latter removed the comment corrected by the former)
and can carry the fix as necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__18_Jun_2013_16_12_39_+1000_Sj5w0UsGeWh=SraL
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJRv/pcAAoJEECxmPOUX5FEIZoP/RMe+ZEtb3M8K/ITjKHlySWZ
UBdNQ2aVPhVWerTWWwuVO5S+lDnp3jUchiYFSIyQXgh5rY5kTcWBXHnI8s/psne3
XIx5fro6UF9a0QqaPeGa4Glqq8+TnNrR5TFq6tiNhPB/dpjhxinPb7vJO91LyD2C
cAKzd4a8aM52NLasKW8lG5S5P1mse+JatNWb/8rH5HVctaEv6ZObPaTpkMqoJcj1
+0S4LXQ8k+KTh5sLbiYSsNtPx8T9rz0X99xm/J1l+Sa8E+hcHTuS0e3MJjaNdxlD
7JZVF+pc2C1InFqcFspzJQBMzaj0sIX8/zPsZLPiCinEpUnpO3YGyOt2oGKSCETr
QuqVt6BSGoDxewVtL8m3m3CPxCNZNb7s0ieow7BRuapMUaIFEi7ApbRH1W7QDKJC
uNy0a55u62zjYnlfZcXpBCXsEiQ040pQXG96h6SsEIulbgrkibNivw13UbJ44cW3
n/aAx2nZriPiTOi/oSyZbR9JwLA5fPJIXyd8JZlZJVPcs8CzLHxQaWvJyd132wfN
xQ/vSGIANWLZh1Y0vC6+HwGtgyje+Rf5LHoAsABB6BS5WPr8ZH1j1llSlX5jJDwV
slz5RTbNLSNu8Sj+39tEBSdxwF5hPdrsKR3n3gFVk87BJbq9v1J1Dupau4EOUcJ1
KuNnlzUOMOQyCpVpw0TN
=z4B9
-----END PGP SIGNATURE-----

--Signature=_Tue__18_Jun_2013_16_12_39_+1000_Sj5w0UsGeWh=SraL--

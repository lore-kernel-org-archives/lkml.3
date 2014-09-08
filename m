Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752969AbaIHHNV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 03:13:21 -0400
Received: from ozlabs.org ([103.22.144.67]:45940 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751404AbaIHHNU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 03:13:20 -0400
Date: Mon, 8 Sep 2014 17:13:11 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Felipe Balbi <balbi@ti.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Jingoo Han <jg1.han@samsung.com>
Subject: linux-next: manual merge of the usb-gadget tree with Linus' tree
Message-ID: <20140908171311.414b05d2@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/TPOxAYe.RyoFrSbSMf70jVy"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/TPOxAYe.RyoFrSbSMf70jVy
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Felipe,

Today's linux-next merge of the usb-gadget tree got a conflict in
drivers/usb/phy/phy-samsung-usb.h between commit bbc66e140bab ("usb:
phy: samsung: Fix wrong bit mask for PHYPARAM1_PCS_TXDEEMPH") from
Linus' tree and commit ea2fdf842365 ("usb: phy: samsung: remove old
common USB PHY code") from the usb-gadget tree.

I fixed it up (the latter just removed the file, so I did that) and can
carry the fix as necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/TPOxAYe.RyoFrSbSMf70jVy
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUDVcMAAoJEMDTa8Ir7ZwVH28P/1LhqM+dXyisnGdyPeAtBpEq
GohGWyhCB+M8S7stFtfQoF3XkCqfNfy2Xwvwu0Dm4QmCjrZvgeHCzzfovpjxqHh6
HlRHUpH6dGNAD/FXwOcqbwCJqRTsz02EQv7GyonpsDm2A2tMXFv9FXpAxykUEPmR
JwSksRD0+wFMDFwD64t9dy4C0GdH61uF0/E/RvdKw/IOUzRZxfOF9bW7OBYPr9kx
USK3qprd50xGCMKNK6HeI0AcW9BHAwMbqq+U+tPWDjjKtDnRtCM/owU2Yp7sjJh3
dSK1z8OO55ErA5cVXzXLcY0yubPI8fI0fju8gfmGV35g8mmNh5FwsnrPaic9oqNT
QMvn/6a+R0yidlRV+AfGsCc1XKNVeiAzSYngg5ePeJJ527uD0u5bSS/42m9qtNqm
6mggq1DbQBRJFN5HTv70rypc073lWFxBpbsShN9nPu/k/5suPaDbL4+UAC0LPmgQ
k+LpbVaQPrwbrE1/l195JOWZpMhIdrTVvcdLEgze1Uwn2k9ilCySaMBTvbVpu5zf
JhBTLJw+cVVgPmUQ/RgPzT0Fqyk/iBbL8Md36E49hCBHKRqs2p9La+jNJnXwZuct
4MwhG/4oaCB/o+1eyKV5TBwV6CVUj1QJo4v0DhPRCJa85qAs3+PlpUb2n7rcALF6
L/u/QBTLTc2uz5JwE+pf
=tgp7
-----END PGP SIGNATURE-----

--Sig_/TPOxAYe.RyoFrSbSMf70jVy--

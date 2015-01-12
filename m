Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753804AbbALQPl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 11:15:41 -0500
Received: from hqemgate16.nvidia.com ([216.228.121.65]:13358 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752913AbbALQPj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 11:15:39 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 12 Jan 2015 08:07:38 -0800
Date: Mon, 12 Jan 2015 17:15:27 +0100
From: Thierry Reding <treding@nvidia.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Felipe Balbi <balbi@ti.com>, Greg KH <greg@kroah.com>,
        <linux-next@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: Re: linux-next: manual merge of the usb-gadget-fixes tree with the
 usb.current tree
Message-ID: <20150112161526.GD16118@ulmo.nvidia.com>
References: <20150112111339.591e766e@canb.auug.org.au>
MIME-Version: 1.0
In-Reply-To: <20150112111339.591e766e@canb.auug.org.au>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Originating-IP: [10.2.68.64]
X-ClientProxiedBy: UKMAIL101.nvidia.com (10.26.138.13) To
 UKMAIL101.nvidia.com (10.26.138.13)
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ieNMXl1Fr3cevapt"
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--ieNMXl1Fr3cevapt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 12, 2015 at 11:13:39AM +1100, Stephen Rothwell wrote:
> * PGP Signed by an unknown key
>=20
> Hi Felipe,
>=20
> Today's linux-next merge of the usb-gadget-fixes tree got a conflict in
> drivers/usb/phy/phy.c between commit 9c9d82492b73 ("usb: phy: Fix
> deferred probing") from the usb.current tree and commit c818a94c77a9
> ("usb: phy: Restore deferred probing path") from the usb-gadget-fixes
> tree.
>=20
> These seem to try to fix the same problem (from reading their commit mess=
ages).
>=20
> I fixed it up (I used the version from the usb-gadget-fixes tree) and
> can carry the fix as necessary (no action is required).

Sounds good to me. There was a discussion on the mailing lists and
c818a94c77a9 was what we settled on as being the better fix.

Thierry

--ieNMXl1Fr3cevapt
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUs/MeAAoJEN0jrNd/PrOhWaQP/3OiBiDmSG+O2ZDTEvRTXePF
1LI4ZBqjP8mJdK85vMEdNasAnoceFf39Jz9y0s8Lp1H6i2Irmjl9vepS7kyZJI05
ThAqWRcwEReUO1Df3E4ppXVfTZk1hE4ZTUAgYGsnMFm6su19YNe0CSg4WW/JTvFh
hYNA3f3bN/tEhfdCKYgbDAPWFpfGy6WJoNrHQkBvHB3Vnn2RNPRcEhKhnRhkARO/
PR0cfW7Ab3qxTiTxfY3kfnk6XPQcRBufts+lNt5YOt9wKT+gWxoOg6+WLs5eX/O/
ezC1rz2CwqdLEC/iKgJx2OP7c0nqdyF9OtmSElAlbLTGJrwszSlPmbkcLbSAcors
3HjDfgXMBgHXaSDGHtkWYhSAEUUYMiRfYW+xSO5N2CrovRdrqqpwidNcXCoh4kEZ
EXAs+9Kli3eRB+MKkF5qVlzJqkhW62em19kpbL/7cvjowVocRF45IVAX+dJ9cnKu
hk4a23SPe7mHl2kprJtcqc5DqKCwSvEqAsefCT6xFkeCCkGKWgky8/JpsNhvCyX3
ypky8xTVJGvIVvst4j0RFGtdKHcBNsi/vNODnhO88uIbFLjSaPo2C6BvUrFNuzQ6
FLjRGALoNOhkhW4nQedbzR5B4HpABm3BGsBjT0txKl+pGIxsfB8Om5qk1FigoeZ4
73Uw2zYzWviz0vvVeYrq
=+Qii
-----END PGP SIGNATURE-----

--ieNMXl1Fr3cevapt--

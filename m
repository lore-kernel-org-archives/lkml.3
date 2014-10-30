Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760442AbaJ3QdX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 12:33:23 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:36944 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758498AbaJ3QdV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 12:33:21 -0400
Date: Thu, 30 Oct 2014 11:32:48 -0500
From: Felipe Balbi <balbi@ti.com>
To: Antoine Tenart <antoine.tenart@free-electrons.com>
CC: <balbi@ti.com>, <gregkh@linuxfoundation.org>, <Peter.Chen@freescale.com>,
        <kishon@ti.com>, <stern@rowland.harvard.edu>,
        <alexandre.belloni@free-electrons.com>,
        <thomas.petazzoni@free-electrons.com>, <zmxu@marvell.com>,
        <jszhang@marvell.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v7 0/7] usb: add support for the generic PHY framework
Message-ID: <20141030163248.GH10130@saruman>
Reply-To: <balbi@ti.com>
References: <1414514141-31767-1-git-send-email-antoine.tenart@free-electrons.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="nO3oAMapP4dBpMZi"
Content-Disposition: inline
In-Reply-To: <1414514141-31767-1-git-send-email-antoine.tenart@free-electrons.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nO3oAMapP4dBpMZi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Oct 28, 2014 at 05:35:34PM +0100, Antoine Tenart wrote:
> The series can be found at:
> git://git.free-electrons.com:users/antoine-tenart/linux.git usb-phy
>=20
> Changes since v6:
> 	- rebased on top of v3.18-rc2
>=20
> Changes since v5:
>         - rebased on the latest version of Sergei's series[1]
>         - fixed one modifiaction made in the wrong patch
>=20
> Changes since v4:
>         - reworked the PHY handling in ci_hdrc_probe()
>         - fixed a rebase error
>=20
> Changes since v3:
>         - moved phy_exit() after phy_power_on()
>         - fixed the PHY handling in ci_hdrc_probe()
>         - some little fixes
>=20
> Changes since v2:
>         - rebased the series on top of v3.17-rc1
>         - switched to devm_phy_get() to handle non DT cases
>         - moved usb_otg into the ci_hdrc structure
>=20
> Changes since v1:
>         - rebased the series on top of [2] (generic PHY support for HCD)
>         - split s/phy/usb_phy/ renaming and generic PHY support in separa=
te
>           patches
>=20
> [1] https://www.mail-archive.com/linux-usb%40vger.kernel.org/msg48068.html
>=20
> Antoine Tenart (7):
>   usb: move the OTG state from the USB PHY to the OTG structure
>   usb: rename phy to usb_phy in OTG
>   usb: add support to the generic PHY framework in OTG
>   usb: allow to supply the PHY in the drivers when using HCD
>   usb: rename transceiver and phy to usb_phy in ChipIdea
>   usb: chipidea: move usb_otg into struct ci_hdrc
>   usb: chipidea: add support to the generic PHY framework in ChipIdea

quick question, who do you guys want this patchset to go through ? If
it's me, I can take them no problem.

--=20
balbi

--nO3oAMapP4dBpMZi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUUmgwAAoJEIaOsuA1yqREuO0P/0nMPOD0x0k/No4X/dVVEt6/
/v0Rqfa6azZ83DqsIwBCcnlaRj2dpPebTszwOV1sHYq2D90CAkjEtcNl9OBpo7kF
+7jepjNs6Ln6npjJUS/rH6iPifZ0nGECfKc7bfznRcPQZjhyWuArQVppRtTyAjNS
7lJjVEI087qxjYxU37elJ0OFp+AcFl6fJkH/j+TQaB4YWaaG/6rVofp43iFl5MXd
nwTbTUIZPInqEQOYUju0I6eqE0QDriao3v+nQzYvMsQervCK0z+9BcAwfy2Y1mpb
Aa3+Ul9H0wl4Qt+3J88N6OxOlpPgDbal//ghKPisdcC2cgjWvEMAkxKThOCBHFOt
6SzLzBJsEgzL/ZpleR+gmG3b/IDZaz+Bn5uzMCw6/tbeT9/b0MSDdJPNlEvmNerR
Wli6pmij87XnsCvG8soc16X6Ao/jIjOhoVytpSVuJN4hypOz1sYinu3g+w4bzAIg
ojdmfNlTp+CzM7iBay2RnUtTokcXqxurRww1BK9isOqE28OxfU8hMaoE+Ue1KDrU
HlP4sjnzxvsIJh5r6wcrP1Ltm06gwqU4n8GK2fuOsz4I+QkZ8e5zYclC0Diad7hh
Ld090mo0Oa0rVeY6MZOkBu7abUVFJpG1dTDGbukVZjENY++D2letnViCRZae3RH0
eK8yLLMru6hp9z7wQT9L
=p1Od
-----END PGP SIGNATURE-----

--nO3oAMapP4dBpMZi--

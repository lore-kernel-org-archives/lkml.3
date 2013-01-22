Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753127Ab3AVLJI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 06:09:08 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:35684 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752279Ab3AVLJG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 06:09:06 -0500
Date: Tue, 22 Jan 2013 13:08:56 +0200
From: Felipe Balbi <balbi@ti.com>
To: Venu Byravarasu <vbyravarasu@nvidia.com>
CC: <balbi@ti.com>, <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Kishon Vijay Abraham I <kishon@ti.com>
Subject: Re: [PATCH v2] usb: phy: moving all PHY API definitions to usb/phy
 directory
Message-ID: <20130122110856.GB685@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1358852471-28260-1-git-send-email-vbyravarasu@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jho1yZJdad60DJr+"
Content-Disposition: inline
In-Reply-To: <1358852471-28260-1-git-send-email-vbyravarasu@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--jho1yZJdad60DJr+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Jan 22, 2013 at 04:31:11PM +0530, Venu Byravarasu wrote:
> As drivers/usb/otg/otg.c contains most of the PHY related APIs
> which are not OTG specific, moving them to more logical place
> under driver/usb/phy.
>=20
> Signed-off-by: Venu Byravarasu <vbyravarasu@nvidia.com>
> ---
> delta from v1:
> Missed adding newly created file usb_phy.c with previous patch.
> hence sending v2, after adding that.
>=20
>  drivers/usb/otg/otg.c                    |  184 ------------------------=
------
>  drivers/usb/phy/Makefile                 |    1 +
>  drivers/usb/{otg/otg.c =3D> phy/usb_phy.c} |   45 +-------

let's call this file phy.c or phy-core.c.

--=20
balbi

--jho1yZJdad60DJr+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQ/nNIAAoJEIaOsuA1yqRED0YQAKd7TVrUXi7jxJEwRJXHNfpY
AbnCtux+K0fUIJkvJftrpzo9KLfxOH/4G1MPJs7SUEdb7HPg5Uaks6B2uqBXTx1e
HXNIAp+oKjRwAWkqoARyrOjsXcjDgD+MAFv2q1wgYSGbfNj/X2dc3nzGrnm1YBSx
VvwG2kkFY2jB/JacxeyQs0+5ZytPbqI7sZloo/26T663w9I+VXJd1bP3Oh7QC8JV
eh+5GQ6VsWHJN1CyjTXxW8IqTcjETaDIsOyr+J1GtKOOJeHeg8Q0JLJc7qqlkIxb
sqIb/KwU3o4J2FFs9Tdlz8WpSBVUSYJenL/FsIeKCmLLkaaY8cRXiFX1vcZVd23f
ct/Q7o+b53pwR72jBk26XJk+Fxtr7+u0OLAVbtNkylwpQC7eLWRKbpahQU9qOqo7
fgx8IZPKtbQaQx2WOmt5rEFoPyVEXa2SWfua9FUL51knndv89VlEoqYTC/lNYsT5
sPVNdLR++HgRBsv3LyoFFhXpSeAIUB/4fRkE467fFshhUYw2jL/DCBlwMumqv1FF
mo8JNgFTuBSXDc/lBGue84c6V45106tFLD1cWyrk/bcFlA6RS24+PjQbpykLLSSk
M7/c1nB+8DpZmEAZGYgrJslnax5P0o5hB5nkVqrd3yiiYFfCyTL0k/pq7CbQh7gD
w68R6b/O8xFo5KdhwEvo
=+iyz
-----END PGP SIGNATURE-----

--jho1yZJdad60DJr+--

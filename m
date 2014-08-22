Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752036AbaHVUs6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 16:48:58 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:51063 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751809AbaHVUs4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 16:48:56 -0400
Date: Fri, 22 Aug 2014 15:48:41 -0500
From: Felipe Balbi <balbi@ti.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Felipe Balbi <balbi@ti.com>, <linux-next@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Jingoo Han <jg1.han@samsung.com>
Subject: Re: linux-next: manual merge of the usb-gadget tree with the
 usb-gadget-fixes tree
Message-ID: <20140822204841.GK27616@saruman.home>
Reply-To: <balbi@ti.com>
References: <20140823055723.1bbfe099@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="73fGQZLCrFzENemP"
Content-Disposition: inline
In-Reply-To: <20140823055723.1bbfe099@canb.auug.org.au>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--73fGQZLCrFzENemP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Aug 23, 2014 at 05:57:23AM +1000, Stephen Rothwell wrote:
> Hi Felipe,
>=20
> Today's linux-next merge of the usb-gadget tree got a conflict in
> drivers/usb/phy/phy-samsung-usb.h between commit bbc66e140bab ("usb:
> phy: samsung: Fix wrong bit mask for PHYPARAM1_PCS_TXDEEMPH") from the
> usb-gadget-fixes tree and commit 0dafc3d94596 ("usb: phy: samsung:
> Remove unnecessary lines of register bit definitions") from the
> usb-gadget tree.
>=20
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).

Thank you, I'll fix it up the same way once my fixes branch is merged
upstream :-)

--=20
balbi

--73fGQZLCrFzENemP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJT96ypAAoJEIaOsuA1yqREFFwP/2fq8sm5yDmmrra+YseEi6kQ
ZvPJlJwb6RWsZc/uXbUUIXYd9kUZZTSW2k2Vb49RmLkTjE6k6JCcMrpL4nMXc472
Mx3k3qx6e22CrRtdsVf1NLx77g1H8kxkkCc6NaXb7yvVw7bOx6sSRzdrHLKC8oGa
gPClEeLL/LneYbjGnu1CEhecMT1nleElbmgSwaoLZTl6t2xEq/zkMZNWrEfeL77L
b4XsIMedz9Fw6ux9pydQHS8+qhlcIePR4UL6fu8+1pwCGBzhhpal/oSRpKu77Oeh
jA0cEcM5kRgfCYNGVoboQogwMtjj1fy+caTifeK5v7BlbcLi+9ogENRHlfXK5v4Q
0ftrw9LS4mXZouz2GEbQdEqRoyS8nr6Dp3HyB1FyO0LLtDYrraTmCapEn77uPhL+
9wZshWKRxdY8lWbSG5ealY35GA7qEOzm1uAaTyOEmgJmis5UXpOm2KeUOOKmP3iZ
E9SKaRApJzYTG1mpNyijvFfcIkYSyEs9XYvTXougS2PelT70FhakbqXuRjxI8jr4
DgHL8Fir4G34hgXFfw+lXaBJX75TRKI8zrq8o0LQE+2sB72MPD2w+GUfjCfXFxST
UkXichwuf1q0xcf2JRXzj0come7IOFoQ/fORzV4oE+Ea66dWMzIf90SZHhvt0Gsu
FR/ShkNzRy32a9lcgm+T
=9FJy
-----END PGP SIGNATURE-----

--73fGQZLCrFzENemP--

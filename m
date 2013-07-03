Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932355Ab3GCOLr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 10:11:47 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:51381 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751438Ab3GCOLp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 10:11:45 -0400
Date: Wed, 3 Jul 2013 17:11:10 +0300
From: Felipe Balbi <balbi@ti.com>
To: Luciano Coelho <coelho@ti.com>
CC: <linux-wireless@vger.kernel.org>, <tony@atomide.com>, <nsekhar@ti.com>,
        <mturquette@linaro.org>, <mark.rutland@arm.com>, <balbi@ti.com>,
        <grant.likely@linaro.org>, <rob.herring@calxeda.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <nm@ti.com>
Subject: Re: [PATCH v3 1/8] wl1251: split wl251 platform data to a separate
 structure
Message-ID: <20130703141110.GN15056@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1372860209-3504-1-git-send-email-coelho@ti.com>
 <1372860209-3504-2-git-send-email-coelho@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WoqaC9TUMqqIOlla"
Content-Disposition: inline
In-Reply-To: <1372860209-3504-2-git-send-email-coelho@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--WoqaC9TUMqqIOlla
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 03, 2013 at 05:03:22PM +0300, Luciano Coelho wrote:
> Move the wl1251 part of the wl12xx platform data structure into a new
> structure specifically for wl1251.  Change the platform data built-in
> block and board files accordingly.
>=20
> Cc: Tony Lindgren <tony@atomide.com>
> Signed-off-by: Luciano Coelho <coelho@ti.com>
> Acked-by: Tony Lindgren <tony@atomide.com>

Reviewed-by: Felipe Balbi <balbi@ti.com>

--=20
balbi

--WoqaC9TUMqqIOlla
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJR1DD+AAoJEIaOsuA1yqREIJMP/RA0CfQRUhy5hOI3QpiRmPI2
nWFFZNqVf0VCQvU87FrTXinUS0/XBUYRLSwDMMo6fFB+jfLsLHfi+hfIbElvhBNM
D01clGzn93P6jxSTqyFKJ8IUsKsP7hTZA5zENbcxVzyB/I4SF062REgAFm2+tnrm
vDZm7BbmmnsUO6WoH5wy2ZQYz5HWyk9wzTKNQ2VQOlGc25PReR9NFzK7IH+dhjyB
sZX4B0PJybY3zlIOJSN2AlcXhsXMz4FtocyE5Dk8kfIV2mFut8JQalNHeq8e2NYx
xdJY2BkSd8qREQwm7Wwcjj1Z0+MDTu21+VjYltWPJxaf7SKedjgr6GXGv8dZ0wVW
2ddwxxJfsI4KnFA6BCeFXjAEkFUrV6IOp0NvyZPEZvNfvrMdxqxlvMoumzdUThyL
9I41PSbnNxk8GU8972Sn7SuKpk6Y0WNc8KjCpVOa3TxQYi/zBaGqTueTv8unp1LY
EC6AJup95nhRBieqq7iEC4olwsUw3bBUfhvIDiX62mh5YLvTc6PYApriOpKo+lW8
7lTkmNgE5p0uF6afXowiRgy5gyz7UptQm+irO9afVgCD27UEwL06oZwkOLt9TFOP
BkfdQnVn0/LdWYbM2EOe60ttKBXNuzPasTHvoCYHEuXEVMRuufoVxgxGz72h9cyV
8zcbVlMiUaPMeQxdOtzP
=nSuo
-----END PGP SIGNATURE-----

--WoqaC9TUMqqIOlla--

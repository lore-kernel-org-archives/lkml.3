Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752291Ab3DWTb0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 15:31:26 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:32903 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750955Ab3DWTbY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 15:31:24 -0400
Date: Tue, 23 Apr 2013 22:30:46 +0300
From: Felipe Balbi <balbi@ti.com>
To: Arnd Bergmann <arnd@arndb.de>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>, Felipe Balbi <balbi@ti.com>,
        <linux-usb@vger.kernel.org>
Subject: Re: [PATCH v2] usb: phy: don't mark usb_bind_phy as __init
Message-ID: <20130423193046.GC13453@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1366734653-488286-1-git-send-email-arnd@arndb.de>
 <1366734653-488286-20-git-send-email-arnd@arndb.de>
 <20130423171734.GA31432@kroah.com>
 <201304232107.22084.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9Ek0hoCL9XbhcSqy"
Content-Disposition: inline
In-Reply-To: <201304232107.22084.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--9Ek0hoCL9XbhcSqy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 23, 2013 at 09:07:21PM +0200, Arnd Bergmann wrote:
> It makes no sense for a symbol to be both exported and marked __init,
> because any users in modules would be calling this function after
> it gets discarded. Further, this patch revolves a section mismatch
> warning from usbhs_init_phys(), which is intentionally not marked
> __init:
>=20
> WARNING: vmlinux.o(.text+0x413f8): Section mismatch in reference from
> the function usbhs_init_phys() to the function .init.text:usb_bind_phy()
>=20
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Alan Stern <stern@rowland.harvard.edu>
> Cc: Felipe Balbi <balbi@ti.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: linux-usb@vger.kernel.org
> ---
>=20
> v2: rebased on linux-next

not needed, Greg already has a patch doing exactly this in usb-next.

--=20
balbi

--9Ek0hoCL9XbhcSqy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRduFmAAoJEIaOsuA1yqRENy4QAIAJI5SQIF0a9Em8e20UVyPD
oPLxn3/B35LBRWGaa/+BJI2hthC9IxANUd3N/Ejd1LWr6Bk1muN2bnZMvdAd5dbG
7BM3rROebRIQPL89iZ1G+CD5ddC0TrK2Bmq5Q+pIBEpv9hJTGDqja65vQ8qVkSLU
ryWHoeyGcaCqucq3FZXcdu8DMTox1bf//qCghubX7wKBFiSqTDNoT3sUQcv72Kma
CPlKGKtw27Bxbk7lvQ4ONdWPP4OuEN3Od0bdoeBzWQluvXqr9J2DSJQO3Yq2AQ1E
NpZCqHwz6pHBOHjfaUKCJv1yaffhhi0LDd4VHR+JVRNc2krumN8khadiYKqPN6Ur
Y4PQXuZtXSV1X/BjGqH9vEXjo1+nhfv5rnOOA5IiMCpvJZ94RR1YD8nAKvsBTDTP
8QzxMRJfOaWQpwWSE6XTwG2dFQBL6I3d6WLHaiFmAUkziynY326oYVQiiqvozUVm
eDf7udbp82oStGftOFM1nvuRA/kj+BAj35E6LohWC8gX8+E1+V6so+XFfbpVuUzz
lOr6Z5gcie7x2FhiBsuQLiFa2kWB4tGdMVZplPorzjLnn3qNZNy5w7QPytTN7cnw
SSAg+bAuytD4R62C6W+YtzjTdMcjFpK7IwjgYqamvxE38o2xgOR9HIMfnijnYSi/
FEol+bGmbV+UBPAPoJ2A
=0O3t
-----END PGP SIGNATURE-----

--9Ek0hoCL9XbhcSqy--

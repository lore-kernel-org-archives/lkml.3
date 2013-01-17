Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759595Ab3AQKka (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 05:40:30 -0500
Received: from mga02.intel.com ([134.134.136.20]:49826 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759527Ab3AQKk2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 05:40:28 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,484,1355126400"; 
   d="asc'?scan'208";a="248244206"
Message-ID: <1358419318.2731.218.camel@sauron.fi.intel.com>
Subject: Re: [PATCH] mtd: m25p80: Flash protection support for STmicro chips
From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Reply-To: artem.bityutskiy@linux.intel.com
To: Austin Boyle <Austin.Boyle@aviatnet.com>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date: Thu, 17 Jan 2013 12:41:58 +0200
In-Reply-To: <1357257748.31023.12.camel@pc786-ubu.GNET.GLOBAL.VPN>
References: <1357257748.31023.12.camel@pc786-ubu.GNET.GLOBAL.VPN>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-WpyN74ceTYkPetSLAioR"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-WpyN74ceTYkPetSLAioR
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2013-01-04 at 13:02 +1300, Austin Boyle wrote:
> This patch adds generic support for flash protection on STmicro chips.
> On chips with less than 3 protection bits, the unused bits are don't care=
s
> and so can be written anyway. The lock function will only change the
> protection bits if it would not unlock other areas. Similarly, the unlock
> function will not lock currently unlocked areas. Tested on the m25p64.
>=20
> From: Austin Boyle <Austin.Boyle@aviatnet.com>
> Signed-off-by: Austin Boyle <Austin.Boyle@aviatnet.com>

Pushed to l2-mtd.git, thanks!

--=20
Best Regards,
Artem Bityutskiy

--=-WpyN74ceTYkPetSLAioR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJQ99V2AAoJECmIfjd9wqK0H2cP/1Qg0pPTCCqdHB80lTJqZ6iL
/iMPqbH27lCSvgYxBHuz/8TIxfqksHacIE62lFGC7Aptau7wKIpy9Lw+SZZ7jVFl
YBDx+MW6j633FKdUWvpZHQuyd006aFCsYAl/HUFHm1mkm0q5kGJXGU3zAjRsrHr6
2paZ2NCqUZtojcDcBsLabCW908YccN1Lv8f6aST2OtCRmqsGsVVAYXRsoQe8gfsX
8XvWhhtYk8gUbma61s6t2r42XsKsNuBN789qNyFvoVguAfdOpz05D08cWw+I2Cve
OFZxyn58OcV+Gc5guV7r5AP7XbIWZ3+lf51Rf7KmbL5f0ayxXo0ASS+J239yr1gU
vteGsYmuF7Cjlm6o5JDwcf5UQBi0tUqoJLe924rmZhmPgSpCx67WwkNuLobpU3Gi
NW17eBZXIa5xRlMrbJN8NLCyel3TBjSBa5PYCqAmVPJkEfH1V/eHpA9CgPE9bQJL
uVVELnGdQtDCngcdc1LdlbLGmCso5l61rlYcv8AKIeG9Y/yUPmcno3nAEW06lxHu
bO0MBK15rvlDbIuBW0KRr3vAnC8eVrXrLYsg+jPY6APvcstgXwgfhUHNAU0WAVJm
uZ07w7aHMtLudBfduNrE7fB79RLBFfK3Pa6ECGsrdZ/ugAYdCxO6TPztmEJcJ0Et
xF4TzdwkDHWcUAecJSsW
=hKcS
-----END PGP SIGNATURE-----

--=-WpyN74ceTYkPetSLAioR--


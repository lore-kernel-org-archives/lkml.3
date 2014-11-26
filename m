Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752449AbaKZIQb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 03:16:31 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:55186 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751764AbaKZIQa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 03:16:30 -0500
Message-ID: <54758C48.6050106@ti.com>
Date: Wed, 26 Nov 2014 10:16:08 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Hans de Goede <hdegoede@redhat.com>,
        David Herrmann <dh.herrmann@gmail.com>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Luc Verhaegen <libv@skynet.be>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Grant Likely <grant.likely@linaro.org>
Subject: Re: linux-next: build failure after merge of the omap_dss2 tree
References: <20141117190905.4e96294a@canb.auug.org.au>	<546B5D5A.8020304@ti.com>	<CANq1E4SMLHmezfXSENSQ8xUaXptwA8YKQ9Nne=sDCB0gPkPLmA@mail.gmail.com>	<5474615F.20407@ti.com>	<5474660B.8070507@redhat.com>	<5474720F.5030106@ti.com> <20141126090737.2860d33c@canb.auug.org.au>
In-Reply-To: <20141126090737.2860d33c@canb.auug.org.au>
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="BQ7gv6XAjFv2fqLG94nKpO6AD25bNLtBv"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--BQ7gv6XAjFv2fqLG94nKpO6AD25bNLtBv
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 26/11/14 00:07, Stephen Rothwell wrote:

>>> So we need both CONFIG_OF and CONFIG_COMMON_CLK, the attached patch
>>> should fix this.
>>
>> Thanks, applied.
>=20
> But not pushed out, yet?  Just checking that you haven't pushed on
> purpose.

Not yet. I'll be pushing today.

 Tomi



--BQ7gv6XAjFv2fqLG94nKpO6AD25bNLtBv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUdYxIAAoJEPo9qoy8lh71FEUP/RexykoJPA9KpaVqhCgIdNRJ
llpQqzdXbjKRE2nuq9Yv+X/JsRN4nIiK8NWggm6aduQkqGhRknDY8xVi6aFrnXze
RkrLPAIEnhtroPjMWBhRSTQdtbdO79ipCj6pyuAI0G07I6vUGxPGNpn/nViEgehO
g9LXUWblCtrO7xJfWWeNbSQdDRL78ejlnJidZ1ROaZWxKVtErbBXq/tJQSrNdoWV
xrgfTLkkBpdoNjlfM4dLBRfgZuogDThsN4+t/iUdhCyYebUpgbV7LhIIEBRUaeqO
yWcBW+19PVd9RGC+cl5sQFuZxA3hVrtQDz6pMpRoT6rgyxI1uVLXAJoXnzxd0cYU
RcKXO7kP9lZlYPwh+Hen+H5dc2Ngj/2qGDn87/u6zJ0TY682m3UC/4gf86USSuJ9
CxYstKDI06QCamF5TRJlPHTkGDrXlnRiIgjKsIcGW8EJb68HkDGUQ2ik7AqjJimT
jOA8KsR+ETW/RyTO8yRLRe9yR1ynKZvlgUmrCQ6q9grb6D0qddUrIZTG7DFOATzW
pOxlCxJ8pwSA4MzOxjQTe1GAAvrZ8h8mjcAPX2fHCU7s7pYCNeizYXaRqNydxtvs
ZdKge4YWKuKaNVu57aCBzfE5yR4ivSLnbnCj2sOtdtbZY8HQiSgM2UmSHJIJlztD
luiOJTTAZ42Ed7dCS6ir
=EyIB
-----END PGP SIGNATURE-----

--BQ7gv6XAjFv2fqLG94nKpO6AD25bNLtBv--

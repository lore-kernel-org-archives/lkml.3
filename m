Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932453Ab3GBVcp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 17:32:45 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:33895 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753510Ab3GBVcm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 17:32:42 -0400
Date: Wed, 3 Jul 2013 00:32:08 +0300
From: Felipe Balbi <balbi@ti.com>
To: Luciano Coelho <coelho@ti.com>
CC: <balbi@ti.com>, <linux-wireless@vger.kernel.org>, <tony@atomide.com>,
        <nsekhar@ti.com>, <mturquette@linaro.org>, <mark.rutland@arm.com>,
        <grant.likely@linaro.org>, <rob.herring@calxeda.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 8/9] wlcore: sdio: get clocks from device tree
Message-ID: <20130702213208.GC10388@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1372776948-24840-1-git-send-email-coelho@ti.com>
 <1372776948-24840-9-git-send-email-coelho@ti.com>
 <20130702153526.GI7013@arwen.pp.htv.fi>
 <1372796394.21065.89.camel@cumari.coelho.fi>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wxDdMuZNg1r63Hyj"
Content-Disposition: inline
In-Reply-To: <1372796394.21065.89.camel@cumari.coelho.fi>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--wxDdMuZNg1r63Hyj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 02, 2013 at 11:19:54PM +0300, Luciano Coelho wrote:
> On Tue, 2013-07-02 at 18:35 +0300, Felipe Balbi wrote:
> > Hi,
> >=20
> > On Tue, Jul 02, 2013 at 05:55:47PM +0300, Luciano Coelho wrote:
> > > @@ -294,6 +316,8 @@ static int wl1271_probe(struct sdio_func *func,
> > >  	/* Use block mode for transferring over one block size of data */
> > >  	func->card->quirks |=3D MMC_QUIRK_BLKSZ_FOR_BYTE_MODE;
> > > =20
> > > +	sdio_set_drvdata(func, glue);
> >=20
> > is this move really necessary ?
>=20
> It is, because I use the glue in wlcore_get_pdata_from_of(), so I need
> to call sdio_set_drvdata() earlier.  I reckoned it wouldn't hurt to move
> this, so I wouldn't have to pass the glue in the
> wlcore_get_pdata_from_of() call.

that's alright, it does look like it deserves a mention in changelog
though. Other than that:

Reviewed-by: Felipe Balbi <balbi@ti.com>

--=20
balbi

--wxDdMuZNg1r63Hyj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJR00bYAAoJEIaOsuA1yqREdrcQAK39ZF0YWQ9FjfsQW94IUFlH
PqzbZ2SVYnXzgdd1zQHIcptjJKJSjykDDnQ4j3lXwjdyf6LbO1xIOgD/pLtG39sK
2oJqBKl9UrwaIdTtZFSDJbO4s80nFBqfb2yfubn2TQ35d7FTCpcg2J9gTLCGD2lk
bOMh49zGhwNlj3PKpUmXfE/lv2WBvSLdWK8+gLpIKJpMpTiLvM0eLsIDDBEkc9iW
a5s/QF2YgmvXdic+OF0cCOKPpoJ/A1N8Obnw/6+6vVpKrLuHOaIooX7ZfIy6aZhv
B8Jep1jN8hb/DmtQShPtzs7nWnxc8cWxl6rA+2QDufbWlcYjz6aAhqQ6pHaWFJuc
00UKMY6lyg7TCEm7Gvd/5zM2BrHWWxhOifIW++/wVY3nUQVA3CpLxfxnihowwuEZ
wagtL7gXvMMS8cm9CzCbWg9e4ppCPJ90decCPdhE3jnrWqwKNHAvSKqTLt4L+bEg
3ZF4jzEASzwBeAG6Mwb3AgghSVcv3rH/VV3BVlB9tuKcO5TjsA6hv6ykBfyrx2HT
gRCj4C9+MR41w3JKcfXEjQzgOOhWOk8IPZ4D1Cw3QBlKuYmJiI1GRMU83qcXGLrA
pEh/jXbpnuD2ESqQ7wUcvAnLqW9eBU1s69Ny1Ez6rDWtAiiCr+nKiZT78aJ+MXul
r4LB/ROug5M1VuLwfvbH
=2z4V
-----END PGP SIGNATURE-----

--wxDdMuZNg1r63Hyj--

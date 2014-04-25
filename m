Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753571AbaDYSgP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 14:36:15 -0400
Received: from mail.kernel.org ([198.145.19.201]:59246 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750992AbaDYSgM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 14:36:12 -0400
Date: Fri, 25 Apr 2014 20:36:05 +0200
From: Sebastian Reichel <sre@kernel.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Shubhrajyoti Datta <omaplinuxkernel@gmail.com>,
        Carlos Chinea <cch.devel@gmail.com>, Tony Lindgren <tony@atomide.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>, Kumar Gala <galak@codeaurora.org>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        =?utf-8?B?0JjQstCw0LnQu9C+INCU0LjQvNC40YLRgNC+0LI=?= 
	<freemangordon@abv.bg>,
        Joni Lapilainen <joni.lapilainen@gmail.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Carlos Chinea <carlos.chinea@nokia.com>
Subject: Re: [PATCHv3 08/14] HSI: Introduce OMAP SSI driver
Message-ID: <20140425183604.GD22721@earth.universe>
References: <1396053110-21639-1-git-send-email-sre@kernel.org>
 <1396053110-21639-9-git-send-email-sre@kernel.org>
 <20140419193050.GH5148@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="n/aVsWSeQ4JHkrmm"
Content-Disposition: inline
In-Reply-To: <20140419193050.GH5148@amd.pavel.ucw.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--n/aVsWSeQ4JHkrmm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Apr 19, 2014 at 09:30:51PM +0200, Pavel Machek wrote:
> > Add OMAP SSI driver to the HSI subsystem.
> >=20
> > The Synchronous Serial Interface (SSI) is a legacy version
> > of HSI. As in the case of HSI, it is mainly used to connect
> > Application engines (APE) with cellular modem engines (CMT)
> > in cellular handsets.
> >=20
> > It provides a multichannel, full-duplex, multi-core communication
> > with no reference clock. The OMAP SSI block is capable of reaching
> > speeds of 110 Mbit/s.
> >=20
> > Signed-off-by: Carlos Chinea <carlos.chinea@nokia.com>
> > Signed-off-by: Sebastian Reichel <sre@kernel.org>
>=20
> > +	bool			wktest:1; /* FIXME: HACK to be removed */
> > +	bool			wkin_cken:1; /* Workaround */
>=20
> There is more thanone FIXME in the code. It may be better to fix after
> merge...

I would prefer to keep them in there and have a look after the
merge. Most FIXMEs in the code are for the wakeline test and some
concern the timings. Since the current code works I would prefer
to add it to the mainline kernel and tackle this afterwards.

> > +DEFINE_SIMPLE_ATTRIBUTE(ssi_sst_div_fops, ssi_div_get, ssi_div_set, "%=
llu\n");
> > +
> > +static int __init ssi_debug_add_port(struct omap_ssi_port *omap_port,
> > +							struct dentry *dir)
> > +{
>=20
> A little strange indentation. Is it intentional?
>
> [...] (more ugly indentation cases)

Fixed in v4.

-- Sebastian

--n/aVsWSeQ4JHkrmm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJTWqsUAAoJENju1/PIO/qafbEQAIWovOVXSwiNOeKwa6F9qtU3
xkLB2zQePMGabDicRZjL3r19c0mCFDmDfcpsyK3NZ9ig9kXdk+daV/W6SAh1Ve9A
LcTahmgl1RSQoud7Rcb/y1RJMtWlu+rDtXiEJ77GC69/rTxHNAHsB8++iCH7+xhD
wzDokHQeV0JSiYQ6x0P5sYVaZJHatGd6kNpie6Fw4lVfv/0Y6kw2NIw81pNq04UD
E3c3P8WnWDVB72odTxaiwRDsN7fquZODKMnbnWXPneG9UsZpngOQa4qvzEViu4Hj
vDbyUpHLXfMG0q19HoSPqEm0yKA2eu6JFj2Nd0facgmOJunai7YNYtdi0E/xzu5d
h+Gz4z9C5B2JAy1n4PLltAsK+qIn1AO9BOLJnf+eotCltrK1FcXMsOCI9uwD/6Hg
TucfPRTiqsjSddaMPbmBRkHnkjUwG0y4gQwhgEgaJFOQj+bLx1GOiA2o8zMV2QXT
9h0edib86J8ypgvuLEXhFCRfKezoC+tBtzG5k5N7NKgPeYAASA1MUlBTCFKhcSFi
DJia4Dgww8BT+klgCzPLRsBf1sLSoM8wMs6t0PqJm7EUmeN2Nw+b/yjP+V9FztsI
n+rmw5OZvd5iNCASZr41+XdquzZq0VfJxYJObQNBA5rHn6tAAstCkNfadIKcLGTs
2YFUMtaWzh4im2mthVpt
=gbdb
-----END PGP SIGNATURE-----

--n/aVsWSeQ4JHkrmm--

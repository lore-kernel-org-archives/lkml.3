Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752617Ab3IRQuN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 12:50:13 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:51617 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751355Ab3IRQuL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 12:50:11 -0400
Date: Wed, 18 Sep 2013 11:48:17 -0500
From: Felipe Balbi <balbi@ti.com>
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
CC: <balbi@ti.com>, Javier Martinez Canillas <martinez.javier@gmail.com>,
        Pavel Machek <pavel@ucw.cz>, Tony Lindgren <tony@atomide.com>,
        Anton Vorontsov <anton@enomsg.org>,
        Russell King <linux@arm.linux.org.uk>,
        David Woodhouse <dwmw2@infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <freemangordon@abv.bg>, Aaro Koskinen <aaro.koskinen@iki.fi>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>
Subject: Re: [PATCH 1/4] usb: musb: Call atomic_notifier_call_chain when
 status is changed
Message-ID: <20130918164816.GN21559@radagast>
Reply-To: <balbi@ti.com>
References: <1378630239-10006-1-git-send-email-pali.rohar@gmail.com>
 <201309181756.12782@pali>
 <20130918163649.GL21559@radagast>
 <201309181843.49850@pali>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8MZM6zh5Bb05FW+3"
Content-Disposition: inline
In-Reply-To: <201309181843.49850@pali>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--8MZM6zh5Bb05FW+3
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 18, 2013 at 06:43:49PM +0200, Pali Roh=E1r wrote:
> On Wednesday 18 September 2013 18:36:49 Felipe Balbi wrote:
> > On Wed, Sep 18, 2013 at 05:56:12PM +0200, Pali Roh=E1r wrote:
> > > On Wednesday 18 September 2013 15:57:13 Javier Martinez
> > > Canillas
> > >=20
> > > wrote:
> > > > to split the patch in two since the patch was solving
> > > > two separate issues
> > >=20
> > > My patch does not solving *two* issues. It is *one*
> > > regression and both parts of patch are needed for fixing
> > > it. Read commit message again. It does not make sense to
> > > split patch fixing kernel regression into more one line
> > > patches - or please clarify why.
> >=20
> > issue 1) twl4030-usb.c doesn't initialize atomic notifier head
> > issue 2) musb doesn't call notifier chain
> >=20
> > do you need a drawing ?
>=20
> Regression 1) power supply drivers not working since v3.5
>=20
> Look at firsts emails.
>=20
>=20
> Do you really have problem to do what *you* need with 1 line=20
> patch which I sent? Or what what you want?

if you had already resent patches the way I requested, they'd already be
applied. Instead you chose to troll the people who are trying to helping
out.

You have two issues being fixed in the same patch and that's not
acceptable.

--=20
balbi

--8MZM6zh5Bb05FW+3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSOdlQAAoJEIaOsuA1yqREBoYP/jr6CZf3RUxBSdKk6C7PYJ1m
p9dlSJNRmxSJnKePIZotLIXIHR3xz/Ut7omIv+9h2aUrKUQ571ljAR6IEmHG+KCz
D1ZJSMEC8OU/1Mx8Xdr3RgGS2NqeEbv6WjmRHHRjg5y1XLuTpmMK0kNnhgLSvGfK
WA/2CIeS1nSPpS2HRPW0RPOuSOaXWkq+ZIrCQDZezyLX+ev2k+b0vv0PvH6jhlVP
hdPSQm8ZOxb1Q22mEtddLZYBVtEWoeJhCp/NludJjkHdYk2BIM7801p6Qy331BIG
SodctAb/pGm+RfePzoygUVv4eenSRKPFEG8/xq3q+n2jTLMuJ4hq2tfMnppafxdh
lGxbfAoj6vuNhSO1vEeLzADVlneldBjQkIsnlOcSe7BtBECIZvQ2MkklhY7P6RzY
RsBFQy+EvlfVgUajQm6Asiz5jkC+u3eZE3uKv8oMdWz0ugrTTeDijwH9Bze4zJ0s
h/CdtF5GfTKMp3aozbXxc5Kxvtq9oq9Hfe7V9IXrJnUTmpfU2Vcqhl1E0ekhc9e/
1sVePt+7wr5cHcXCrZkexJhnqIUZaAgASTPNXupCBk9FXisoEaME6jnHYSBSukMJ
9c3QMhaCnXkOja10ktPaRs87xEktwVfNDOkv3TYCcrxFlEgxbvKYIRO1FjY6NVYg
lcUHY5ZohMxuOB2C3NEZ
=xsEM
-----END PGP SIGNATURE-----

--8MZM6zh5Bb05FW+3--

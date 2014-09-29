Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754684AbaI2Sxp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 14:53:45 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:41706 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753878AbaI2Sxn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 14:53:43 -0400
Date: Mon, 29 Sep 2014 13:53:25 -0500
From: Felipe Balbi <balbi@ti.com>
To: Michael Welling <mwelling@ieee.org>
CC: Felipe Balbi <balbi@ti.com>, Andrew Morton <akpm@linux-foundation.org>,
        Jonathan Cameron <jic23@kernel.org>, <linux-iio@vger.kernel.org>,
        <pmeerw@pmeerw.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RESEND PATCH] iio: light: add support for TI's opt3001 light
 sensor
Message-ID: <20140929185325.GA1939@saruman>
Reply-To: <balbi@ti.com>
References: <20140917150041.GA6903@saruman.home>
 <20140918133631.GA24847@saruman.home>
 <20140919162129.GE26946@saruman.home>
 <20140922140914.GC25620@saruman>
 <20140923140924.GA28592@saruman>
 <20140924143610.GA17997@saruman>
 <20140925221619.GA10644@saruman>
 <20140927041959.GA28445@saruman>
 <20140929140227.GD32403@saruman>
 <20140929183856.GA11871@sysresccd>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZGiS0Q5IWpPtfppv"
Content-Disposition: inline
In-Reply-To: <20140929183856.GA11871@sysresccd>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--ZGiS0Q5IWpPtfppv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Sep 29, 2014 at 01:38:56PM -0500, Michael Welling wrote:
> On Mon, Sep 29, 2014 at 09:02:27AM -0500, Felipe Balbi wrote:
> > Alright, this is already ridiculous. Andrew, if I resend the patch can
> > you apply it since maintainer has been ignoring this thread anyway ?
> >=20
>=20
> Do you reall think this is the best way to approach this?

when maintainer doesn't respond for weeks, yeah! Sure it is.

> Perhaps it would be better to explain what each field of the
> configuration register does and then we can move on.

perhaps Jonathan could tell me exactly what he wants because I can't
handle back-and-forth anymore. Specially when he complains about stuff
he asked me to modify himself.

> In particular the OPT3001_CONFIGURATION_L field needs to be explained
> such that the ABI can be properly applied.
>=20
> Looking at the docs for the Windows demo program the field is associated
> with a latch configuration. What does this bit field actually do?
>=20
> Either have TI release the documentation or add comments to each of the
> fields of each of the registers such that we can understand what exactly
> they are doing.

TI will release the documentation when that's all cleared up with Legal.
You can't expect it to be any earlier than that.

--=20
balbi

--ZGiS0Q5IWpPtfppv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUKaqlAAoJEIaOsuA1yqRE4CsQAJnSxZF5t7C+HHXrBXxgr255
tttHUW7Uy7PBQ7zmeWt5NuPDUFLXi+xhbW/sqgYL3gdCAazpjbONkn4vdvYBQpBL
yO81xxmRhjwuPhlDpir+VZmWOrmUbaoNFxY7T96yyu6rq53UHKXMGwhShlrspkAZ
YBeBz9gKt6qtgfLa7vwGV/kMI8+2KAdwHnUXGFdNk6sAY5CpimLRoalew040yR7o
02RUw8FioSXvACPHheo27Hpk1pk8v+WqgOD4gWa7Lc9Wa938d3b/JtDYnE9OqIpX
KeG9WSZIEKd1PTpUWBBgBN3lP7HiVrmgbTb9bmheFy2h5FnRuudebrlUbqMfdbGl
4K1GdwG/ejnbPl/nO1mEieizaEYRrYFIqtRH5fa7eHfrRo14stZAoonX1bYgkKuZ
Y1J90C1Od+2Mt38p66SWU9a4NssCae8T1Wp+Ddl2NtFVSVHONQFxQLvy/AqTP+jv
oE/7EJO4pDBrMozCrEI0Iu59S/4RFj+HWysBAp9kc8Vq8NoZ5uBB79WfooNd0z20
Wolvk8fvljFXi0TgWL5hUw3uymhCSNlgtlUabIui1pCQAclW/xnYr2CqAncbQQAz
xby9MEimCQN9Oa3J9eOZMGxd+fuj/tuxKTe3X6kiPR5/UaboLF0GdMfycu/f1MdH
Itw5vGw/XbYofA1h1QCH
=GFlW
-----END PGP SIGNATURE-----

--ZGiS0Q5IWpPtfppv--

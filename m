Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752912AbaJ0PDQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 11:03:16 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:51255 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751362AbaJ0PDN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 11:03:13 -0400
Date: Mon, 27 Oct 2014 15:01:47 +0000
From: Mark Brown <broonie@kernel.org>
To: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
Cc: atull@opensource.altera.com, jgunthorpe@obsidianresearch.com,
        hpa@zytor.com, monstr@monstr.eu, michal.simek@xilinx.com,
        rdunlap@infradead.org, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        robh+dt@kernel.org, grant.likely@linaro.org, iws@ovro.caltech.edu,
        linux-doc@vger.kernel.org, pavel@denx.de, philip@balister.org,
        rubini@gnudd.com, s.trumtrar@pengutronix.de, jason@lakedaemon.net,
        kyle.teske@ni.com, nico@linaro.org, balbi@ti.com, m.chehab@samsung.com,
        davidb@codeaurora.org, rob@landley.net, davem@davemloft.net,
        cesarb@cesarb.net, sameo@linux.intel.com, akpm@linux-foundation.org,
        linus.walleij@linaro.org, mgerlach@opensource.altera.com,
        delicious.quinoa@gmail.com, dinguyen@opensource.altera.com,
        yvanderv@opensource.altera.com
Message-ID: <20141027150147.GX18557@sirena.org.uk>
References: <1414108267-22058-1-git-send-email-atull@opensource.altera.com>
 <1414108267-22058-3-git-send-email-atull@opensource.altera.com>
 <CCE2D027-AA89-41C4-B9AA-2B92AA62129B@konsulko.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="V/5pStbHlGfNIMG1"
Content-Disposition: inline
In-Reply-To: <CCE2D027-AA89-41C4-B9AA-2B92AA62129B@konsulko.com>
X-Cookie: FORCE YOURSELF TO RELAX!
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 2/3] ARM: dts: socfpga: fpga bridges bindings docs
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--V/5pStbHlGfNIMG1
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 27, 2014 at 01:48:02PM +0200, Pantelis Antoniou wrote:
> > On Oct 24, 2014, at 02:51 , atull@opensource.altera.com wrote:

> > + - init-val         : 0 if driver should disable bridge at startup
> > +                      1 if driver should enable bridge at startup
> > +                      driver leaves bridge in current state if propert=
y not
> > +		      specified.

> Isn=E2=80=99t init-val a boolean property? It=E2=80=99s not named very we=
ll.

It's not boolean, it's tristate - turn on, turn off or don't touch.

> Along with the label, is kinda hard to defend as configuration in DT.

Yeah...  presumably this decision would fall out of the users?

--V/5pStbHlGfNIMG1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUTl5bAAoJECTWi3JdVIfQdOQH/A0uKA5iWcgJH2O34Ik3b3Tf
i0m/eFLhwGrilMUKuV7Lmvn7R/WMjLxBmwkLXuUjuaX7+/qXWHOxFsT9P+SanVcA
WGfPPY+TWTUd65T6waOKiVSLpD31sjP9StbABP4iuXFI7g0N9IfyebG8XfZrCkbN
yg++mP+qOz1e6ogmV9uk4ULHNXIH9mJR88EYvaoUXQImJnnBeldZJipY2fMWN9Op
q5YRutuo32YnwTC/CkCUp7XkwgkEBvJebEk57TnHGPYfdd1CUm6d4dsGZVu6aA1E
oIOBnF73g7WT0Oe2v7uX6yNCN6COBup44J4vtnbEXxX+9NEuOzpoD/AYVzsNGb8=
=n11m
-----END PGP SIGNATURE-----

--V/5pStbHlGfNIMG1--

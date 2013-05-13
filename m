Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753507Ab3EMFWF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 01:22:05 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:42550 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753247Ab3EMFWC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 01:22:02 -0400
Date: Mon, 13 May 2013 09:21:35 +0400
From: Mark Brown <broonie@kernel.org>
To: =?iso-8859-1?Q?S=F6ren?= Brinkmann <soren.brinkmann@xilinx.com>
Cc: Mike Turquette <mturquette@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Message-ID: <20130513052135.GD6836@sirena.org.uk>
References: <1368207091-32538-1-git-send-email-soren.brinkmann@xilinx.com>
 <1368207091-32538-2-git-send-email-soren.brinkmann@xilinx.com>
 <20130510212422.GY3200@sirena.org.uk>
 <7e18bed3-ae6b-4aa0-bf23-b6c61ba8b85b@CO9EHSMHS030.ehs.local>
 <20130512143344.GC3200@sirena.org.uk>
 <9e55c552-ce34-4663-9a57-bf2c626d7d58@TX2EHSMHS008.ehs.local>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="T7mxYSe680VjQnyC"
Content-Disposition: inline
In-Reply-To: <9e55c552-ce34-4663-9a57-bf2c626d7d58@TX2EHSMHS008.ehs.local>
X-Cookie: Be different: conform.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.247.243.210
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH RFC] clk: Introduce userspace clock driver
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--T7mxYSe680VjQnyC
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, May 12, 2013 at 12:05:04PM -0700, S=F6ren Brinkmann wrote:
> On Sun, May 12, 2013 at 06:33:44PM +0400, Mark Brown wrote:

> > No, there's no confusion here - the clocks that are being exposed to
> > userspace are the clocks which enter the FPGA.  The driver or whatever
> > that understands the FPGA can do what is needed to control them,
> > including routing them on to subdevices it instantiates or exposing them
> > to userspace.

> Such a driver does not exist in general.
> For some IP cores, Linux drivers do exist and then
> they are supposed to directly use the CCF, IMHO, no need to expose
> things to userspace in that case.
> I'm trying to cover cases, in which there is no driver available/needed f=
or
> the FPGA design, other than some simple clock controls.

You're not understanding the point here.  If you've got a
reprogrammmable FPGA you at least need some way to get the FPGA image in
there.  This driver is presumably responsible for instantiating whatever
is needed to control what is on the FPGA, that could include punting the
clocks to userspace if that's sane.

--T7mxYSe680VjQnyC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRkHhcAAoJELSic+t+oim9VBoP/38f3+yCiu8wNskRghOJXpHe
MwXh6mVSxtFtglsqtcpITmSxcYpTFEtynusGI/177dcAk8IcP4TuQQffnQFEDapf
fhvc11iPO9AITqsw85Sl7BrzwCu/bfbXYe3oYeRSH/k4/IwYn+1lw9a7z2sdxhmV
q9D6KpFsHGye6IiNmQkCO9J1hBJAaRAbwfSk1wT9U9+h2CtT9yNwxtUZDw58LwNH
MxBm+TIm2ITxA2hWkbpvNzF0FhbvrduBoxghdLW5oioBL3dtwJmYnjmgbDUa7A1n
WDEqoaNuFkAZgdZ0c9/RjoKsE5LyW3T5qo9qQxmMyl44l6CqpL9Pu3oEydUd0KVQ
XirERtCKsd2x9gZuhtcgQrnfjYDCCNxTJ5Q9IFn4sXderby5+L6BDjyuu4ItUHiH
unULgllU33F7UXhfJqoV8IrQgylN+NfxhQq3vsx02m5GqBtHA+cSXiIOQXOgnMsc
yF4CCZyNshK8mkteOudmNFdGlkY+EI/xzf0JA5GQHoxGA+d2b7GG80gbKXrl44XA
6/be4TYpBThRR9nEtdcCSCUu63+MO4nUo0Vqe44dGnwwvVtK6YjoVEyA+ifF/bec
RqdDmx8nTgGGxBcoNk1ItV8+hnh4twpGrYqPhR0AC8zYNK9tY+UNjcyaXGuqE8vW
/FwB/fYd1beO4eBRWY/f
=7G09
-----END PGP SIGNATURE-----

--T7mxYSe680VjQnyC--

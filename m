Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751743AbaHRNpf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 09:45:35 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:47096 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750807AbaHRNpd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 09:45:33 -0400
Date: Mon, 18 Aug 2014 08:45:08 -0500
From: Felipe Balbi <balbi@ti.com>
To: Frans Klaver <frans.klaver@xsens.com>
CC: <linux-serial@vger.kernel.org>, Rob Herring <robh+dt@kernel.org>,
        "Pawel Moll" <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 0/3] omap-serial high-speed fixes/improvements
Message-ID: <20140818134507.GC9662@saruman.home>
Reply-To: <balbi@ti.com>
References: <1406645577-18620-1-git-send-email-frans.klaver@xsens.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qjNfmADvan18RZcF"
Content-Disposition: inline
In-Reply-To: <1406645577-18620-1-git-send-email-frans.klaver@xsens.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--qjNfmADvan18RZcF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Jul 29, 2014 at 04:52:54PM +0200, Frans Klaver wrote:
> Hi,
>=20
> Here's a couple of patches that should improve the behavior of the omap s=
erial
> driver at high data rates and baud rates.
>=20
> I was actually surprised to see that proper dma support isn't there yet, =
but
> there you go. Anyone got news on that, by the way?

please resend these patches and make sure you get the right Cc list.

You're missing linux-omap, Tony Lingren, linux-arm-kernel...
scripts/get_maintainer.pl would give you a more exaustive list of
people to Cc.

cheers

--=20
balbi

--qjNfmADvan18RZcF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJT8gNjAAoJEIaOsuA1yqREXOkP/1Ntc/AGvt3iY4eiBRwfeTSs
+0n8iYZoO71BbenarsCVFZWE8Ri2NnACskVJ9LtOuAbNAr8pkbjuMnUSRoZZUTNf
3kM3CSnPFEYfUan6imURF9vbsivsjE99gej3AvQe0CsYKe1CXQ6DgkCrvOvPtHnA
QC9Utdo8j+J+gDyqvEOzXR8GI8aePdd+gbvmpDhLTB30+gteNZMVTx48VFu5wuYp
kzTeioeCNoieyvSkpTj2/rx0q7w5CwoPtKKUwCYG6IFR4u4R8Paanl8/i4kkYStS
QpHMZzgC1lNka7fA1/nZxEDBlR68YLoPbCgSsw7SFSVlo9XEWJm0LDJ1qZZZG9hB
f6MUiwjHR3Ze1nEObthzlDpZqHOAo6pTLEdFINwufvlzUGQPrb1rtA3w0I5orW6i
2FSjc8ANHZ4DQzUaexEDifmx/cOlI5euPsl3D1nZ5BwdRk5NLexmMGyY5K1WVP1Z
yrjo+vKqedb6YkEFZ7YMt+ghnocqiSAQgZqdkn1CzulBTs//FShrl6aRYl+tJMm2
nvgmZE6hQt3eOvEl5TqSNr8hWGW90ELvFmNfKHCfDn0dQNIR+msBLDXcmjONAzyC
xYT4X7X3aTC2XK0P7ZQ+JV75Et5nCbmQa0G4SK2xv7OiT1a/c0Tu5BoHC6fSABs6
/OkPhiVzPaGJtkw6bkFr
=rHAe
-----END PGP SIGNATURE-----

--qjNfmADvan18RZcF--

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751874AbaBXGAM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 01:00:12 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:50626 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720AbaBXGAK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 01:00:10 -0500
Date: Mon, 24 Feb 2014 15:00:05 +0900
From: Mark Brown <broonie@kernel.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Axel Lin <axel.lin@ingics.com>, "Ivan T. Ivanov" <iivanov@mm-sol.com>
Message-ID: <20140224060005.GC25940@sirena.org.uk>
References: <20140224144529.1d3b9f3e974b6364298182cc@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0CHKT3anvf6u5QiQ"
Content-Disposition: inline
In-Reply-To: <20140224144529.1d3b9f3e974b6364298182cc@canb.auug.org.au>
X-Cookie: You're at the end of the road again.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 121.174.50.227
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: linux-next: build failure after merge of the spi tree
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--0CHKT3anvf6u5QiQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Feb 24, 2014 at 02:45:29PM +1100, Stephen Rothwell wrote:

> compilation with COMPILE_TEST").  Please at least test building on x86
> before allowing a build with COMPILE_TEST.

Yeah, I tend to rely on the zero day tester to get that when travelling
since it's normally quicker to get a result from that than it is for me
to build on my laptop.  That doesn't seem to have worked out though...

Like I said in reply to Axel's patch it's not exactly sane that things
like this are an issue in the first place.

--0CHKT3anvf6u5QiQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTCt/iAAoJELSic+t+oim91R8P/3ysnTjMUpQkJnEkzw4jfoJh
tpUUF+3meY3nxVi2GWCsTwRipU8HiuBKE/30dHEeK0nKlUWYHghV56CR0rLRIpTu
nOe7C2uJLclzzAHst4396TL72H2dn2qImmDMsJrHN3hPvYJWseMH81xJxM4P36nl
61U+eeveZWLsMK32ezXhBMzl7yb8UcLVxHQSYMhPeRvehL9SIsl5ahk5VXiRdvxF
NPeIagvZXL0C80pL5cqhTRmW/VVmwfJM8q02a3Z1Kgu+4NFPpDeab+HOCigqc9+A
NKvYtj5+Nc+Gmp04QRILiIEEyjA/WE7lYlnD5ha52Qzmuv6vf+BWA9o+42GlK1RG
7rrukYNkhzLueywWkz2p0H0SzN2ql2kZTHFNmApc7Gdw2eZ5ZOIpoRLwms4KboG9
zN1msnsdERqeW3j/Z3YkfudMiP01IlWB+d4ukSw61lxyiMxibCLo3bdVuV+LzUix
tqTswDYI33cRA9XmMR0A3wxeGpAtQZdaXcRgVsm/IjBuX3YqBvmO6y95W67KB2Uk
cU/DJ7PuE9xFPJ9W3nebMqQei8s81M95SS2ztE7Ck2vaZAHS06ebmbhQdZR7zpLJ
Bu73myWI5XPGeBOjCKQw5r+M003sQ5yNiDBCJTSZ/WNZrybdCqgh2fj2GofQALru
rYWb1yaDe8h4L8qqArBF
=t0v9
-----END PGP SIGNATURE-----

--0CHKT3anvf6u5QiQ--

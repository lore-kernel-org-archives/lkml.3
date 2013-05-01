Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761566Ab3EAQOg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 12:14:36 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:45261 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754011Ab3EAQO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 12:14:29 -0400
Date: Wed, 1 May 2013 17:13:50 +0100
From: Mark Brown <broonie@kernel.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: David Brown <davidb@codeaurora.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nicolas Pitre <nico@fluxnic.net>, Richard Kuo <rkuo@codeaurora.org>,
        linux-hexagon@vger.kernel.org
Message-ID: <20130501161350.GS26160@sirena.org.uk>
References: <20130429162115.GA6893@kroah.com>
 <CA+55aFzefpRz2Y8oW9q0ArrR=XW0POBhy8NSNJ3DrCh9EowLqg@mail.gmail.com>
 <8yafvy92gfs.fsf@huya.qualcomm.com>
 <201304292316.28464.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="daC8KDjlMyCcZyAo"
Content-Disposition: inline
In-Reply-To: <201304292316.28464.arnd@arndb.de>
X-Cookie: Be different: conform.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 212.183.132.78
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [GIT PATCH] char/misc patches for 3.10-rc1
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--daC8KDjlMyCcZyAo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Apr 29, 2013 at 11:16:28PM +0200, Arnd Bergmann wrote:

> Well, the only reason I see against putting it into drivers/mfd is that
> this place is becoming a dumping ground for stuff that doesn't have a
> real home anywhere else. On the other hand, this one would fit better
> than a lot of drivers that are already there, and it would actually remove
> the need for a global include/linux/*.h header file as the interface.

Well, this device should have a bunch of function drivers hanging off it
shouldn't it?  That's pretty much the definition of a MFD.

--daC8KDjlMyCcZyAo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRgT87AAoJELSic+t+oim98lsP/2S+EDGnTCn3MUbg5XUXpelC
GKe0eFoV4O8R0QRWYjTYcClm6vXWaryNUNHlg6rZnzLcUQahUqBfLGum+44M2vyX
J6txbHOT8nwW8JvHXDFN7R2j9b1vi4gigNlhP4+4jWSslgq7w8Ust58xFWil7vt0
1IZKKSaIy3kh7NI+oXGZy6MqEg/YLxdWEPp9ZMo3Gg0rvwszmKDN4cT1+nFmYRxh
aJXZuzUVlQnxLpcSblwStzn14VzUwymgZsTYizRTBF9PHzIWUUmaj6BjUf+Vjrvw
pfmCAHDUUTtfeG5f3K81sdn8AdUeyQzSKBYOEEGI2PUomVO4Ixt+wRMnTjtotnpf
mw9ShfRRTMDsY1v/7iD+lc+WWOGyTs3xXRTxIidBAnGI7kAeaZI8y7LAvCUhWYMc
7wtvIwrlzBTI86vLpGiKpUeYi1CMpxp2hFU/3RzG+tm9RLQ5tMODg3nOC9gNZJf/
8mgTOpYBD0xvGvmjYSim1iWaLo79Pcr2JlpKRdBW/jHHj+s5THvmXvoiQtniEm/H
0Ap4h7hYqtxSWm9cr56u4H+Ir95h4f496jnVfMym5L5OQJziUJTeZukUhPCPXE5l
fjmZC97SI0Eq2mclo1WgCT5EnmIPvWssbxfG0sR/8PcnGpUrUGDvM/SHEwKiQ6mY
1U1HYmXmaTgzjntgpkU+
=wgs6
-----END PGP SIGNATURE-----

--daC8KDjlMyCcZyAo--

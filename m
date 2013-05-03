Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762752Ab3ECIHV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 04:07:21 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:41034 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750843Ab3ECIHN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 04:07:13 -0400
Date: Fri, 3 May 2013 09:06:32 +0100
From: Mark Brown <broonie@kernel.org>
To: David Brown <davidb@codeaurora.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nicolas Pitre <nico@fluxnic.net>, Richard Kuo <rkuo@codeaurora.org>,
        linux-hexagon@vger.kernel.org
Message-ID: <20130503080632.GC4945@sirena.org.uk>
References: <20130429162115.GA6893@kroah.com>
 <CA+55aFzefpRz2Y8oW9q0ArrR=XW0POBhy8NSNJ3DrCh9EowLqg@mail.gmail.com>
 <8yafvy92gfs.fsf@huya.qualcomm.com>
 <201304292316.28464.arnd@arndb.de>
 <20130501161350.GS26160@sirena.org.uk>
 <8yay5bxums0.fsf@huya.qualcomm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TiqCXmo5T1hvSQQg"
Content-Disposition: inline
In-Reply-To: <8yay5bxums0.fsf@huya.qualcomm.com>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 212.183.132.20
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [GIT PATCH] char/misc patches for 3.10-rc1
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--TiqCXmo5T1hvSQQg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, May 02, 2013 at 01:53:03PM -0700, David Brown wrote:
> Mark Brown <broonie@kernel.org> writes:

> > Well, this device should have a bunch of function drivers hanging off it
> > shouldn't it?  That's pretty much the definition of a MFD.

> Perhaps it's better to think of it as the library that other mfd devices
> use to talk to their device.  ssbi is not itself an MFD device, it is
> part of the other drivers.

Yes, quite.

--TiqCXmo5T1hvSQQg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRg2//AAoJELSic+t+oim9nVsP/2DH7VplN6NdnANVzwu+fGXz
R2Fk/5gD2R/uvp1btnw9NTCzVKBVQADPEnfifmcDQY/1CABjFd4k81tCMg1gRpzN
RjlQs+wnwUJQaVG+R8XsnWTsUDLY8Wly/MM6Um2+w7F6iOJmRgDUNCA57hyxgzL+
XEY/uFFLV8cd43ykPiBrBjOHOVDLk8MtU3Vcbt7/v4Fz9xi4XUkh8zYq2SSUBwYX
PFebfHJm2LcjgQy72NmvcGjmgqv9KHTfdhJxlv+r3qBq4OAzDkqA8yt72GwNR4f+
zu1a1IC5baaRhoVAcDBuw6jiyuldtzx7HXPtPlY9GbX550RkI77J5fOSgTf7Cy/z
/ktuDrnlhwtKLZsDVIGf0lXX5pISsTD/dtazhXYLFhlPejNd2MRmneVkGS6VbF1B
IGeJYO/kXpn9iuLYgpqXlhga+OlIiHuJ2eaaDWg5j21pI5+bU3idot/UPEjIWO0l
eXgepzPhmtqaNiVCjVOpDz0fKm/Jrb4mTJr3ZEUiUGCOriILmsJVPRNL8aPIwB4e
a47zgjSDVFQYXoajbVukcmgoj6/g7h8jGWB+HhkZd9GlkLcXWoN8Wuy9xDR8k8M8
+Cy8nHJNnXWHzbZ6cOzxfq4OZY9rQuKz2gv/c63f69pmqotD26BUkPl+H+LGCgXv
ditvCcOiZ8fJBJepxpj6
=GBny
-----END PGP SIGNATURE-----

--TiqCXmo5T1hvSQQg--

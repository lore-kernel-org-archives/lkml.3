Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752536AbaAXMDd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 07:03:33 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:58897 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752265AbaAXMDb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 07:03:31 -0500
Date: Fri, 24 Jan 2014 12:03:09 +0000
From: Mark Brown <broonie@kernel.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Tomasz Figa <t.figa@samsung.com>, Tushar Behera <tushar.behera@linaro.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-serial <linux-serial@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        jslaby <jslaby@suse.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ben Dooks <ben.dooks@codethink.co.uk>
Message-ID: <20140124120309.GU11727@sirena.org.uk>
References: <1390208555-27770-2-git-send-email-tushar.behera@linaro.org>
 <20140120100530.GY15937@n2100.arm.linux.org.uk>
 <CAHbNUh3m=uNybv=3yxmr2on=Cc0UuGrYP8zf3GMR-9RQZ394dg@mail.gmail.com>
 <20140123180423.1a62611a@www.etchedpixels.co.uk>
 <20140123184022.GC11727@sirena.org.uk>
 <52E163DC.1090002@samsung.com>
 <20140123193633.GG11727@sirena.org.uk>
 <20140123195144.2d3aa44d@www.etchedpixels.co.uk>
 <20140123200509.GO11727@sirena.org.uk>
 <20140123213321.372ce82b@www.etchedpixels.co.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gn1ylXQ+YRNuZICZ"
Content-Disposition: inline
In-Reply-To: <20140123213321.372ce82b@www.etchedpixels.co.uk>
X-Cookie: Please ignore previous fortune.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/2] serial: samsung: Move uart_register_driver call to
 device probe
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--gn1ylXQ+YRNuZICZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jan 23, 2014 at 09:33:21PM +0000, Alan Cox wrote:
> Mark Brown <broonie@kernel.org> wrote:

> > I don't see how we can meaningfully test this on a platform - the kernel
> > would have to be pretty demented to care, it's userspace that cares and
> > that's not really tied to individual serial drivers but is where we
> > mainly need coverage.

> Which is why I think we want to enable it gradually and platform by
> platform as that platform or arch maintainer judges it appropriate given
> their knowledge of their platform(s).

I don't see how that follows?  For the most part architecture
maintainers aren't going to be able to say too much about which
userspaces are being run on their platforms if the architecture
has any kind of widespread use.

--gn1ylXQ+YRNuZICZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS4lZ6AAoJELSic+t+oim9OPUQAJG4Z+j/lirrJAWlmFxJXBHZ
bmzofKXrOShsBFBOFUDrIKYZ6FNlr8YuU+5Pggr9IT52fc7gGUeU3j9U075nQMgx
9Bx8rOBSh4WxNiGFDkf6PK5S3PkaXTvrNtrnx5TA57LtqzueEhErD8KsofaKdp1G
51Z5fr+DRiceauRBnRAN8ozN1fjJnHUMyXwZoKZYFh1vHlRc0OJBxuUsmTkZvoj7
6ZfDUa/Sl5Z6d7GXyQDZlZLwJY8Sfm/oO9FzLqMlAkn6rzWnkw6suvqXxBUuqrBr
eKzeDAZCd7zf8M4r/KWBmFS6mwkGjDdY8+eoP+JOLG7BpUQmBdvMrzUXbcouEqEz
unsCFxJ0SqQgMehq7jK8uccqguzN0odc5pcLL3dlOaAbKROGL8tYsDoex72yqm2I
dCZBNiqLbLmz7/kl8FoMcbAPZUH/B246XunYtg9O1oaFXlTH0Wamm9hXbhGrcj5p
C/GzxErdLM8ZaCWwLStU4InTQzK2vmJPbqT5fkvKGdX2Wx80DHixVkvX6pFFuFX1
aTgGtXbB04M4IJGk4j0wQ1uBWTHVWpcAjN3wHJej34P6g73h+82GHAd/cqEi4RGv
MhJBtCuHkhPHJJlJf0Hx/nee6KDDlR672QRULlKKag7Zpz1YzUCnKxDciSw6PFjU
P5QLeU5DIwmMpXnJNgvi
=+gPQ
-----END PGP SIGNATURE-----

--gn1ylXQ+YRNuZICZ--

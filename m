Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753354AbaA0APZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jan 2014 19:15:25 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:59838 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753121AbaA0APX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jan 2014 19:15:23 -0500
Date: Mon, 27 Jan 2014 00:15:00 +0000
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
Message-ID: <20140127001500.GS11727@sirena.org.uk>
References: <CAHbNUh3m=uNybv=3yxmr2on=Cc0UuGrYP8zf3GMR-9RQZ394dg@mail.gmail.com>
 <20140123180423.1a62611a@www.etchedpixels.co.uk>
 <20140123184022.GC11727@sirena.org.uk>
 <52E163DC.1090002@samsung.com>
 <20140123193633.GG11727@sirena.org.uk>
 <20140123195144.2d3aa44d@www.etchedpixels.co.uk>
 <20140123200509.GO11727@sirena.org.uk>
 <20140123213321.372ce82b@www.etchedpixels.co.uk>
 <20140124120309.GU11727@sirena.org.uk>
 <20140124143859.70e0e610@www.etchedpixels.co.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HKLejDDV6gCqJAZ/"
Content-Disposition: inline
In-Reply-To: <20140124143859.70e0e610@www.etchedpixels.co.uk>
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


--HKLejDDV6gCqJAZ/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jan 24, 2014 at 02:38:59PM +0000, Alan Cox wrote:
> Mark Brown <broonie@kernel.org> wrote:

> > I don't see how that follows?  For the most part architecture
> > maintainers aren't going to be able to say too much about which
> > userspaces are being run on their platforms if the architecture
> > has any kind of widespread use.

> For most architectures I suspect that they do have a pretty good idea.
> ARM is a bit different but I imagine the various platform specific
> maintainers are the ones who have that knowledge

I'm still not entirely sure how you expect people to answer this unless
the answer is something along the lines of "all the systems are on my
desk".  This definitely does need to be selectable, I'm just not clear
that making it depend on the architecture is going to help.

--HKLejDDV6gCqJAZ/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS5aUBAAoJELSic+t+oim9LZQP/327MKh7ksk2UkW5RqKdmC0a
5KZPf82dTjKfycVVe6Lh0xqR04zGk8RwnT/AFOpfEn2uWOm7tJmFsnrFz1qVtTb3
VnsIP6OInA1AQlck4oDhK62Y/PPuMSF4nsvXSVOMjXoqYNgzSjDJZr/vQLiRlFHU
1E60xKUWxDffRug24ccG5t9Tgh/E3WGKZ8kN2+aYYsrncCjKF7K6kR/6kDnSHhb6
sskV7NCdCAZEd0ZEkYOr44sNVyKUDfPEmfdBnnGLA3z3RaYbW3dEoQ3AaCNWCJtV
KwOGqQVXnYd412sYwTgrgzcm7f8XSOs9WcvjK1C6rCBf7JxAqu2hIjmbMmq3o8P/
8ShFR34KGqXKze3B+dkEZPx+4awTE4Sa9MOFq2Qzyh6FsV2dUCJYLIlNenZzloG7
YEcy27iVOumCImFF3ViI1cKuDYRnZcPFDjO7WzR9cbmyfWr6IXYUHFciVh3t++Wq
PCNn64Soyawxt0jxsk8VISkKcbxKUkHtVrWL5Z0WbVBT45daNUan26BG3XwH+12X
ztSeyZt+9ESb8XSBQTS+Znf2x9idnKknWPf2qHt/yIXF6TzufNJLG7xdhZqARsLA
/58ofSJjG1leOwNMiM1QxeIkSaoOVbPTa3zrUNaNKaCmxTzADIW6pkSndKWAlLTR
yH09AG1jrrsoGim+bQRx
=vaNi
-----END PGP SIGNATURE-----

--HKLejDDV6gCqJAZ/--

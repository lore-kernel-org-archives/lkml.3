Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754365AbaBSPz3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 10:55:29 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:58599 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753654AbaBSPxv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 10:53:51 -0500
Date: Thu, 20 Feb 2014 00:53:25 +0900
From: Mark Brown <broonie@kernel.org>
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Greg KH <gregkh@linuxfoundation.org>,
        Tushar Behera <tushar.behera@linaro.org>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        jslaby@suse.cz, ben.dooks@codethink.co.uk
Message-ID: <20140219155325.GJ2669@sirena.org.uk>
References: <20140213184249.GC30257@n2100.arm.linux.org.uk>
 <20140213232606.GA27372@kroah.com>
 <20140214000717.GG30257@n2100.arm.linux.org.uk>
 <20140214001436.GA16287@kroah.com>
 <20140214003834.GH30257@n2100.arm.linux.org.uk>
 <20140217153518.30891455@alan.etchedpixels.co.uk>
 <20140217235013.GD2669@sirena.org.uk>
 <20140218100943.34f2e186@alan.etchedpixels.co.uk>
 <20140219135751.GX2669@sirena.org.uk>
 <20140219144751.75f7fb70@alan.etchedpixels.co.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="o9omvSfeMYbm0Ozc"
Content-Disposition: inline
In-Reply-To: <20140219144751.75f7fb70@alan.etchedpixels.co.uk>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 106.188.144.10
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/2] serial: pl011: Move uart_register_driver call to
 device probe
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--o9omvSfeMYbm0Ozc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Feb 19, 2014 at 02:47:51PM +0000, One Thousand Gnomes wrote:

> > anything to complain that people are following the recommendations of
> > the maintainer or to demand that this somehow gets hacked around in
> > arch/ when we're trying to convince all the architectures to get their
> > drivers merged into subsystem trees so they're reviewed by the subsystem
> > maintainers.

> It's not a case of hacking around it in arch. It's a case of fixing up
> problems where they belong, which btw is what Greg has in his tree -
> specifically ef2889f7ffee67f0aed49e854c72be63f1466759 and
> 6f134c3c770355b7e930d3ffc558864668f13055 which keep the handling of the
> minor clash cock-up in the drivers affected.

That's more reasonable, what you were saying was to do things in the ARM
tree which reads like you want changes in arch/arm - those changes are
in the serial code.

> > you're doing here is making disparaging remarks and telling people to
> > adopt bad practices because someone else made a mistake a decade ago.

> I'm not telling anyone to adopt bad practices - at least its news to me
> that "stopping the merge of buggy crap" is now a bad practice.

Like I say, it's the "do it in the ARM tree" bit that's bad practice.

> > > And the proposed change set is buggy as hell - because we register things
> > > like 8250 devices at least four ways on the same x86 machine all of which
> > > could in theory occur in parallel.

> > Then you need to convince Greg of that.  The most recent set of patches
> > are exactly what he asked for.

> No there's an assumption that when someone asks for patches the proposed
> changes actually *work*. As Russell has demonstrated - the general
> deferral patches for the uart/tty layer are broken. The driver specific
> fixups in -next on the other hand appear to be fine providing the amba
> bus probe remains serialized (and trivially fixed if it doesn't).

So like I say discuss that with Greg, it's entirely reasonable for a
submitter to trust the maintainer on something like this so it's not
helpful to yell at them (or other people who happen to be working on
the same architecture for that matter).

--o9omvSfeMYbm0Ozc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTBNNyAAoJELSic+t+oim9URUP/0y0iTP9SUL77Pn5Uah2rZ6h
J/AMEkmUC0JXdrpMexYuHp1lLEeM94zrAof8ATgYewIdD5GABUhoH5dhhyeyLecA
TD8YDPFJaKaUXqpp5GuK025DP3WJUKWC91bSHmB6aM+p23OW/yce3e+mkW21T2SM
xGcSzFv4p53SRlwB9et/OFWIVmgL4MALylTRpg0VeUGiaXpAbS25OKbulVLOisou
5r7NqQxIXSXhaMpMk04nP1DOSD20aakGDlOu5a2cLgC2Pt0MfpE0wO0nd2YWvTSQ
2CDjna3PX6zxPl3rMnHIZUS7Rqpknu5lXlqibaSG73MNsn67JAeA/6z91icIbva0
s+0G6U2V4/zDM1BnY22ncZiD9PBuCtz5nPq/JWobaJej4ahc2WUiY0KXh+peOTok
dugkLb02BjwqtQWAD+CC4qCUDYHPEkcsKkre8RoiXGcNrXTeaFnMf5FIMZ0R8qv9
TGQY8UZHLjV4uQiMsos0IjZc/qUlyM59Z5SM5pyayKePUVE5R+AJmuUkdg6bL/Bi
2Ycq94Ril1wgULuHPsbwTyj3hqo9uNK8pV090UR/xakFmSlrm7sqds+8d1Nj1nRD
ACkK0VxwoVqMqPcInvmD1YHdT7psOJ9wiaahdyIhn9+/dVLjttQMlvObBprE50oN
hVXY1oq04/MfO1vaDkxd
=xXrx
-----END PGP SIGNATURE-----

--o9omvSfeMYbm0Ozc--

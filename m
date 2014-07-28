Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752964AbaG1MVZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 08:21:25 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:59362 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751423AbaG1MVU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 08:21:20 -0400
Date: Mon, 28 Jul 2014 13:20:42 +0100
From: Mark Brown <broonie@kernel.org>
To: Andreas =?iso-8859-1?Q?F=E4rber?= <afaerber@suse.de>
Cc: Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org,
        Michal Simek <monstr@monstr.eu>, Lars-Peter Clausen <lars@metafoo.de>,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Michal Simek <michal.simek@xilinx.com>, linux-kernel@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>,
        Matteo Vit <matteo.vit@starwaredesign.com>,
        Sean Rickerd <srickerd@suse.com>, Kumar Gala <galak@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org
Message-ID: <20140728122042.GR17528@sirena.org.uk>
References: <1406242820-20140-1-git-send-email-afaerber@suse.de>
 <1406242820-20140-10-git-send-email-afaerber@suse.de>
 <53D20A61.1050506@metafoo.de>
 <53D21066.8000905@monstr.eu>
 <20140725101815.GO17528@sirena.org.uk>
 <53D2324B.4070602@suse.de>
 <20140725103905.GP17528@sirena.org.uk>
 <53D63746.3000905@suse.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XVjO8VCnuz2qIvDh"
Content-Disposition: inline
In-Reply-To: <53D63746.3000905@suse.de>
X-Cookie: 98% lean.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 09/11] Documentation: devicetree: Fix ADI AXI SPDIF
 specification
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--XVjO8VCnuz2qIvDh
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 28, 2014 at 01:43:02PM +0200, Andreas F=E4rber wrote:
> Am 25.07.2014 12:39, schrieb Mark Brown:
> > On Fri, Jul 25, 2014 at 12:32:43PM +0200, Andreas F=E4rber wrote:

> >> Maybe this works for you?
> >> https://patchwork.kernel.org/patch/4620191/

> >> Otherwise I can resend with Ab/Rb.

> > Documentation/SubmittingPatches.

> Not helpful here, nor is
> Documentation/devicetree/bindings/submitting-patches.txt. It's separate
> from code changes, sent via git-send-email, has a Sob, went to LKML and
> LAKML and DTML. I could add a Fixes: header and CC trivial for this
> one-line fix IIUC.

It's telling you that the kernel process is to review patches sent via
e-mail, not random links to web appliations - notice the context to
which I'm replying, I'm saying that sending a link to something on the
web isn't a good way of submitting a patch.

> Doesn't tell me which patches I should CC you on in the future though.
> Therefore my request to fix the false negative in MAINTAINERS so that me
> and other kernel newbies don't run into it again.

Feel free to submit patches if you want to see changes.

--XVjO8VCnuz2qIvDh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT1kAQAAoJELSic+t+oim9h/UQAIdLd2Kqc8b4Ddy4l0Hm/zCX
fhJN8b+NDl1Bdi6Y444ymBIT3NftmPXGevxKmlxqTARTusXQHIA0Wv9gll/K16pi
mWgIDVIvH98pHFgyGpafs78rmsKtIhlAP1A0PI0XTIVBNqthiuTveBnJpN6SEr9P
04PpudbuNS3KCA7hPjSv+ToFFB9lLjUDI7KHrmsHXS1kAbLIYqw0ydxRYTngX8b/
4kUUukaEVrM+OB7TN3blY7HqVsesvu58HOPmBk6toFZlENasxZ3uxPoh8rGceE0M
Hber7MACG8Z6fMErA6XJW2rhScIVvQ7tcT9gs4cKH/N/vUGHuZSB3YYtWZeVnssN
N/sXMLdC5Icu3gZATxmdJHYkCO9NMFGjZhN2xPPzNg0xOQ7NHdDtUaGJWjFGWNrm
EFnCDV/ThNbJ/RsaO3xv6+lvKFw0f9hNo4WzkAv6KgzyWVuxWTt7w34c7MQD6YO8
XuWXuk/M5TyIMwJHSMoZU2SU5cWDHy37qz/8fqEjVw1O1HvSh7Tldcc6p8luOuCU
hf9OBftZB2RmJLeSsnHssoa0ibfUYQM70l2BiLE9Nv9AJ109PNeuJy8kJ4ELnEkq
zXUQzxoMZOD0DrmQzoSyTxvqeZo0qI0AIrgXBP1D7pWb1a0kTS5xmC8jgI3a52pz
Lzn1amY/19NJMm2GbBC7
=Gg5h
-----END PGP SIGNATURE-----

--XVjO8VCnuz2qIvDh--

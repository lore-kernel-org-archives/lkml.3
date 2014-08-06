Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754400AbaHFVLh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 17:11:37 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:50390 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753508AbaHFVLf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 17:11:35 -0400
Date: Wed, 6 Aug 2014 22:10:51 +0100
From: Mark Brown <broonie@kernel.org>
To: Andreas =?iso-8859-1?Q?F=E4rber?= <afaerber@suse.de>
Cc: Lee Jones <lee.jones@linaro.org>, Liam Girdwood <lgirdwood@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        open list <linux-kernel@vger.kernel.org>
Message-ID: <20140806211051.GA17528@sirena.org.uk>
References: <1406755767-5910-1-git-send-email-afaerber@suse.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="w3kmj6YJmRtqQaLC"
Content-Disposition: inline
In-Reply-To: <1406755767-5910-1-git-send-email-afaerber@suse.de>
X-Cookie: 98% lean.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v3] Documentation: devicetree: Fix tps65090 typos in
 example
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--w3kmj6YJmRtqQaLC
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 30, 2014 at 11:29:27PM +0200, Andreas F=E4rber wrote:
> Specification and existing device trees use vsys-l{1,2}-supply,
> not vsys_l{1,2}-supply. Fix the example to match the specification.

Applied.  I've previously reminded you to use subject lines appropraite
for the subsystem, please do so - this is important for telling people
what the patch is for.

--w3kmj6YJmRtqQaLC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT4pnXAAoJELSic+t+oim9Y6EP/0DwyVyQ/+UFFITQo7zScDpp
hm9gZqRUOyJwNJC/fP47L464R3l4CrSS3bYfOLFzUe4jcVbAjZVTzguSAaN6f59Q
4znQM8h60K2+vhUWKSxCinz+gvzTchV17d7R4PWN/wPypWg3xjA3jI1TnHca1d59
EN+pYG++04VtV9Z2vj94kJDQRgyOyIz6W9QesyTX6aJuGN+WhvZ/qKLQ8aOifRdF
FDQr4QSiY8tpvrDO8/g831NFT/RyBgCJGDyodlooHZ3Q3Vnx7TXOY24QpFnc/KQ9
yt7KFgKjKfDl4Grgwx37HO5RLeYX2PeMMp0uPZuhSn/HAR9VCk9mXN00BPK7hv1H
lI7M0OydX1crYOout2tTAyxf2pcX5HsRLMMHABCNb8+rzpbpNxrz/tr+VQRzUlfW
IdRxzmlKAziLCg1tuTUbwNwP239nIhaK30FH2kyfJPsxIKEwjJHpF/zbbAZK8yqm
hnDUeB+foWf5xncYeyLJFyG2n76QL9aS3fegQffXXXmrlGtii5OXpS5L2ZGBLcmh
8cPFgVaiHNpyCLEH5Je9HCWdBg4DNwv84Yxrag+IJOTUdh6eJhs6cqWPUm1pn+bu
gYWxhX+4tH76gO0Y6wGoAlG2tn6YUv6diyTPdiOcyi8EYWZWZ2S20JUlLKlR+Iup
WmLYXxzxOZ9trZuNtQX+
=Rlq4
-----END PGP SIGNATURE-----

--w3kmj6YJmRtqQaLC--

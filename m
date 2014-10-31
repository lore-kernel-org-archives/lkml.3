Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757556AbaJaSHm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 14:07:42 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:59589 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752117AbaJaSHk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 14:07:40 -0400
Date: Fri, 31 Oct 2014 18:06:32 +0000
From: Mark Brown <broonie@kernel.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Chanwoo Choi <cw00.choi@samsung.com>
Message-ID: <20141031180632.GO18557@sirena.org.uk>
References: <1414668053-31370-1-git-send-email-k.kozlowski@samsung.com>
 <1414668053-31370-2-git-send-email-k.kozlowski@samsung.com>
 <20141031122330.GP18557@sirena.org.uk>
 <1414760874.7318.15.camel@AMDC1943>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lv1RQUI4Uowj5McI"
Content-Disposition: inline
In-Reply-To: <1414760874.7318.15.camel@AMDC1943>
X-Cookie: FORCE YOURSELF TO RELAX!
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v3 01/14] mfd: max77686/802: Map regulator driver to its
 own of_node
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--lv1RQUI4Uowj5McI
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 31, 2014 at 02:07:54PM +0100, Krzysztof Kozlowski wrote:
> On pi=C4=85, 2014-10-31 at 12:23 +0000, Mark Brown wrote:

> > I'm getting very frustrated with what's going on with these drivers,
> > there seem to be a lot of rather large sets of patches spawning lots of
> > discussion but also frequent review problems and very little actually
> > getting merged (look at the set of changes in the past few merge windows
> > for example).  There's something going wrong here.

> If I over-spammed you, then I am deeply sorry.

It's not just about volume, it's also about the fact that so little of
the mail around these drivers (not just from you) is translating into
code that gets merged.

--lv1RQUI4Uowj5McI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUU8+nAAoJECTWi3JdVIfQYSkH/0fJk94SBzZ0eQUotAuideUC
NDZ+HO0+tR+HPMFuxeAAE1ZsSbWmoopM/v2SZb14ep+0kpyUJes5DuRhUqiq30Dh
KwN3vouzaiBs13U8Tna0LxIbFR0xUVC8HWCyUASkkXrU3vOPRjKxwg0DkejrzayY
r8/OJ7k5/dhAEiW4gp5yrgUVyzwVH/DbxaFTZnm8yv7FJAQPXEsL8ZdBm4B/h8GT
iaMY67RV6luiGgEebXoiCdGbH4fft564obIbTkAbBVGwB68d3cshVJe49Lq7WCrO
bEiyhk8uw21xQrihWUFwJKHSgxE6Xwa3n3e8DyDGi4422cqQf+mWu+MEbGsooc4=
=SmBY
-----END PGP SIGNATURE-----

--lv1RQUI4Uowj5McI--

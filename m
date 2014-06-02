Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755690AbaFBQ75 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 12:59:57 -0400
Received: from mail.kernel.org ([198.145.19.201]:57534 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752278AbaFBQ74 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 12:59:56 -0400
Date: Mon, 2 Jun 2014 18:59:50 +0200
From: Sebastian Reichel <sre@kernel.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv4 0/4] tsc2005 DT binding
Message-ID: <20140602165950.GA28338@earth.universe>
References: <1400693774-21306-1-git-send-email-sre@kernel.org>
 <20140529133356.GA4716@earth.universe>
 <20140530195821.GA27692@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="ibTvN161/egqYuK8"
Content-Disposition: inline
In-Reply-To: <20140530195821.GA27692@core.coreip.homeip.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ibTvN161/egqYuK8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dmitry,

On Fri, May 30, 2014 at 12:58:21PM -0700, Dmitry Torokhov wrote:
> On Thu, May 29, 2014 at 03:33:57PM +0200, Sebastian Reichel wrote:
> > On Wed, May 21, 2014 at 07:36:10PM +0200, Sebastian Reichel wrote:
> > ping! It would be nice to have this in 3.16, since it makes
> > the N900 usable with the mainline kernel when booted in DT
> > mode. The DT bindings haven't changed for more than 3 weeks,
> > so we don't need to wait longer for feedback from the DT
> > maintainers AFAIK.
>=20
> I applied the series, could you please take a peek at my 'next' branch
> to make sure I did not miss anything?

Patches look ok, I also tested the branch on the phone and get
events after running the selftest once (which resets the
controller). Without running the selftest no events get reported.
I will have a look at that in the next days.

-- Sebastian

--ibTvN161/egqYuK8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJTjK2GAAoJENju1/PIO/qao74QAKe+qHPl5CkgROrv/SQrnQq0
XWGGsFaibeKr9cKKwa+zdhEn+eoGZqYI7bt5tfdHsjvlq60/+WwL84+KDuS3IQZF
wETZHLbMgirGbjC1AKumopvzCGq8pG6S2dPeHU3NSyjpjY6lT3tV6wPhZWVlKaxm
0BBLCnqXsq6WrO4H2rbgq1MxTL1tSHc6il4F5wniwP1+kAvgye58UIYHNL2D8geG
x52uCcdEJ2gBRhCofRn43xDpy0p2auFKYtYkZSwA4k4uED14UwBK27ng0s1zMQ+t
pxqa659x6t3byVuz+bu1NE/s7FJrltLMSR+noLqXivnHnmgybzbg9k4L0hRsAbH7
OnjdjimUvN6EL5J/Xw/wA6pPBfK9HcwTjCrvz7LnxgmxuS7qcAiISfBGDdw9eKz0
9Yep8gxwv8RTRNS0Dik7F9oUFjSS2hKDVOHRR6JIYgd4Rhdp3GH7cyG1f8d3EsUX
WsGsHLxQz3+bJ4vmIJuXw10GPRwwd+qixXcFKkzOyNyqWh7m9vTATEyr1yT1ht10
qpy7z6JRznK97ileXKuf5nltwMc6Qq4De0vv3NYCXsX/4dQvh3FMAWEQBIlxl152
qVokixWYe7e0eZgqQeWvSzpPrZeB5XQ8FYl8CiUSDRGz710qn1dqA/6+B17Ug5gY
Y7N541AoaLp91mpPk588
=v0Ij
-----END PGP SIGNATURE-----

--ibTvN161/egqYuK8--

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030261AbaGPGAP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 02:00:15 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36739 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934442AbaGPGAO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 02:00:14 -0400
Date: Wed, 16 Jul 2014 16:00:05 +1000
From: NeilBrown <neilb@suse.de>
To: Ian Kent <raven@themaw.net>
Cc: autofs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6] autofs4: support RCU-walk
Message-ID: <20140716160005.6c43668d@notabene.brown>
In-Reply-To: <1405481098.2527.9.camel@perseus.fritz.box>
References: <20140709233541.4525.25151.stgit@notabene.brown>
	<1405481098.2527.9.camel@perseus.fritz.box>
X-Mailer: Claws Mail 3.10.1-123-gae895c (GTK+ 2.24.22; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/CNjf.8X8joeXB44spg2oeiO"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/CNjf.8X8joeXB44spg2oeiO
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 16 Jul 2014 11:24:58 +0800 Ian Kent <raven@themaw.net> wrote:

> On Thu, 2014-07-10 at 09:41 +1000, NeilBrown wrote:
> > autofs4 currently doesn't support RCU-walk - it immediately
> > aborts any attempt at RCU-walk to force REF-walk for path name
> > lookup.
>=20
> As discussed I don't have time to properly test these just now but I'll
> do my best to review the patches and return to test them later.

Thanks.

>=20
> My impression is that you will be submitting these patches rather than
> expecting me to pick them up and submit them. If that's not what your
> expecting please let me know.

I had assumed that you would take them as you are listed as the maintainer.
However if you would like me to send them on I can certainly do that.
You seem to send via Andrew Morton so I'll do that when they seem to be rea=
dy
if you like.

>=20
> I appreciate you including me in this work, all to often things get
> merged that I'm miss and while I may not have identified any problem
> with them at the time at least I would be aware of what I might need to
> look at when problems arise.
> =20

Maybe I'm old fashioned, but I have this idea that all patches *must* at
least be Cc:ed to the maintainer and if they are as intrusive as these, they
*must* be approved.  Maybe others behave different?

Thanks,
NeilBrown


--Sig_/CNjf.8X8joeXB44spg2oeiO
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU8YU5Tnsnt1WYoG5AQK31BAAomCdO1FMBN6B8AEMIwrrUjm6sAs2UH+w
IMNLjG5B9I6AXcUNX9BxY5VT+6hv+IwkTBAgBmECW2vuLv5pLjWZdUptGSkSDUss
+tPwdBoIxrMY0slNV+jarFNl/yDfB2mKz5B42IF/gIeA9F6J1/inFoBkec4eJOfZ
9VuW1J/9g4gKZQeBkGf6E1ZpBYanR/Sk+Q67GbXVtiRIYDCAUkLLFDrF5/VYoYmE
DR8PO34oTZMzmkR+SDpoL83bIUUYFLuxMfwSed4Myh40Civ1zJuFK+99gjxbdvom
bCU1vjkLeSg2c8bjMVfvDfHGZ5NFommD4cnlgA4Hk7ZFMpqMggEWaJtST2636XP0
yci6wYmn0cvy+jjAQ/UUTnYEyHP4L5OOkNx0/vczmzLKtJnq6lmtmSY48pM2D5V3
HGFtRSzB26RiLKsbNqztnE3v48r7X3HzE3N/VbeLLWZPLxPJpFu1lo26s60BOdW1
UcS0HpA1zAKpTSUdBq0faofbqL+BgrTITRHE+rcAJzBa1AVZOJzRXYNJSSZUGfD7
ma+N0TmWgr1CsVedWZnst8L/JdG0WnstTJAqMmuwFVw1p9DD2K2+cB1HCYfquzb5
BYQ90VlZAFPYVoOr7q3yqEyXVGYc1bNd4dzDXFiy4cE4Mk62B8KcEZ+F1F4v1bBR
1n4qwEdmDUs=
=TOWw
-----END PGP SIGNATURE-----

--Sig_/CNjf.8X8joeXB44spg2oeiO--

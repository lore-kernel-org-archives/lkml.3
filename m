Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933512Ab3DOLEw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 07:04:52 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:57314 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933036Ab3DOLEv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 07:04:51 -0400
Date: Mon, 15 Apr 2013 12:04:23 +0100
From: Mark Brown <broonie@kernel.org>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Arnd Bergmann <arnd@arndb.de>, alsa-devel@alsa-project.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Liam Girdwood <lgirdwood@gmail.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [alsa-devel] [PATCH 20/30] ASoC: samsung: convert to dmaengine
 API
Message-ID: <20130415110422.GA15837@opensource.wolfsonmicro.com>
References: <1365638712-1028578-1-git-send-email-arnd@arndb.de>
 <1365638712-1028578-21-git-send-email-arnd@arndb.de>
 <20130411142706.GB24971@opensource.wolfsonmicro.com>
 <201304111647.17796.arnd@arndb.de>
 <5168601F.2070409@metafoo.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/04w6evG8XlLl3ft"
Content-Disposition: inline
In-Reply-To: <5168601F.2070409@metafoo.de>
X-Cookie: Be careful!  Is it classified?
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/04w6evG8XlLl3ft
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Apr 12, 2013 at 09:27:27PM +0200, Lars-Peter Clausen wrote:

> I actually had a look at how the Samsung PCM driver a couple of days back,
> but I didn't fully grasp how things work with the secondary TX channel for
> the i2s driver and to make it work with the generic dmaengine PCM driver.
> The code handling this in the i2s driver seems to be rather messy with lots
> of ifs and elses. Also things would have would be a lot easier if the dt
> bindings had used two subnodes each with their own 'dmas' property.

Yeah, it's quite messy at the minute as it predates any subsystem
support for things like multiple DMA channels going into a single DAI on
an AP so it was having to do things it really shouldn't have done.  What
ought to happen is that the driver gets refactored to use soc-pcm or
change to represent the mixer block as a CODEC, I think if that happens
then things ought to get easier.

--/04w6evG8XlLl3ft
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRa9tpAAoJELSic+t+oim9DLEP/19t3Inijm3BvaAQZ3bDV/Dd
1aMM9yZDg5fUxb70/7wOVAXTcjVbuiWF0yGYq6OEZoAiJo3z6trivv7YZfQkLK4K
QuZWXlGOzPIHjJy0GP+WT5/K23jAeV+tv8Np8W3auChNgfSmXCg3dGSnhECXewTM
juaT1OGmdy8KD8uijDuR+odsAnUF7F93NFlCrCBtlhO74on2JnA5eT2+qd7V0MAT
ryMmGlURlL4a113SQztU8pSbbJhGED0/6FPPnvBGuXpk0l1BIzR4JJiQJ2Rtj6Rz
h1oGtnCPD0/mKoZqLZipxSxz+MvxeRgRbqft2K+Qjj0v7JeYI0xDrXeq93XyoIrq
bpQnJdsYVgHOPmvXWbOzxytQwibBYBFqjcelCqAFkx3FChNslek0BHPFtN/ncDip
IKBjOUP5OammxNaBZ/NHnjyUpu16PFdWgzI5r4v4KfodR4snq+bKP60q1dr3ZG8h
WQevjfdnfI8uJlma2zKl801NYtKE4oLHGiDa/s2tfLzxuzfiGKD4G8ZeW9vv+Za6
WyLx4tgln5nsnK6wW30cZJ+275XDI5oAxiz7dipiIlwJ3116PL4EWJoXmh4TgPt7
iz24HRfgwNjxL2g7V1Ybg5S5rkcvTY0ASa8j3BwJUh1n6uJWKPOrgziCNVqix7AD
XkBU9ywCTio05cVTLSmL
=xjig
-----END PGP SIGNATURE-----

--/04w6evG8XlLl3ft--

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752314Ab3FZO0D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 10:26:03 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:54001 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751349Ab3FZO0A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 10:26:00 -0400
Date: Wed, 26 Jun 2013 15:25:31 +0100
From: Mark Brown <broonie@kernel.org>
To: Daniel Mack <zonque@gmail.com>
Cc: Marek Belisko <marek.belisko@gmail.com>, perex@perex.cz, tiwai@suse.de,
        grant.likely@linaro.org, rob.herring@calxeda.com, rob@landley.net,
        lgirdwood@gmail.com, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org,
        Marek Belisko <marek.belisko@streamunlimited.com>
Message-ID: <20130626142531.GO27646@sirena.org.uk>
References: <1372251928-15706-1-git-send-email-marek.belisko@streamunlimited.com>
 <51CAE9C8.3030005@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WeAyUrhnD1IdQdNw"
Content-Disposition: inline
In-Reply-To: <51CAE9C8.3030005@gmail.com>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ASoC: Add PCM1681 codec driver.
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--WeAyUrhnD1IdQdNw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 26, 2013 at 03:16:56PM +0200, Daniel Mack wrote:
> Hi Marek,
>=20
> On 26.06.2013 15:05, Marek Belisko wrote:
> > PCM1681 can be controlled via I2C, SPI or in bootstrap mode. This code =
add
> > support only for I2C mode.

Guys, please delete unneeded context from replies so it's possible to
find the content - otherwise people are wading through screen after
screen to find what you added.

--WeAyUrhnD1IdQdNw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRyvnXAAoJELSic+t+oim9w1oQAIm+AxMqP5tOL4blDxl+DMtm
ytgyX+r56XyHNdjzvPO+w5BpM56ak7ZKWyA8Nz3N5LVCbHVz5xfU8iglfC/2V+2q
Wo1IupUC73UG3eY2q39wohUsBhDaAgnOwjSMNPbyjxi0dHe65JfP6iW6FKSD1x08
7OCALK4fx7NjsYtQezjMv3aNMXeaPmqLri1K/NWR1fXUXSCWeLzRaSJPLEV6LCPL
r5Ad/Sz5orzzU6H+QhxY1EplAzf64FUDwz4mPFc7T+QmyJ7eOj3IPZ8eCfqXHTtJ
fd+MIWsqeeNnfDXryq0hRe74ezhgKTHfY/kLb1u2FEKN5FTDZE0kXU6mUk3xIkEE
x0ybdjvqe/I/zUxxwxwj5ms2PYaZsGZvRRcgDUk390KsY0gXteVftwSVLT1cIk2f
igw3cYkC467eAImjBv/V6heoRrtJjesd0+1Lr9yu1Gym1/t10uRcAnJfrhSklo8s
7OkEhoWfBSe89ii6u7SBCa4NkTs0boVOe9uV/dRDcL1ct0moZtksoBuUJm17Tq7U
yLeOw5r6Bj6a/cDJXm13sg6kIbx2fEqCjyy7eEuuPV9Eth5yIOfeKnR2jxE23BCn
2nn9dcCckAoDCZYGXT/HkOmlSP+fBCwr4l2++8yuinj2b9GuCNkUQ5vMuI5RMyKu
em6NL61H9V37jG8RMPjI
=u8wv
-----END PGP SIGNATURE-----

--WeAyUrhnD1IdQdNw--

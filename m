Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758576Ab3GZLGD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 07:06:03 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:48959 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758080Ab3GZLGB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 07:06:01 -0400
Date: Fri, 26 Jul 2013 12:05:54 +0100
From: Mark Brown <broonie@kernel.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Jean-Francois Moine <moinejf@free.fr>, Liam Girdwood <lgirdwood@gmail.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Rob Herring <rob.herring@calxeda.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Message-ID: <20130726110554.GB9858@sirena.org.uk>
References: <20130725111459.145a4aa4@armhf>
 <20130725191905.GR9858@sirena.org.uk>
 <20130725230533.GH24642@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Mq/g1DrVwLsuPImC"
Content-Disposition: inline
In-Reply-To: <20130725230533.GH24642@n2100.arm.linux.org.uk>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 4/4] ASoc: kirkwood: add DT support
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Mq/g1DrVwLsuPImC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jul 26, 2013 at 12:05:33AM +0100, Russell King - ARM Linux wrote:
> On Thu, Jul 25, 2013 at 08:19:05PM +0100, Mark Brown wrote:
> > On Thu, Jul 25, 2013 at 11:14:59AM +0200, Jean-Francois Moine wrote:

> > > +	if (np) {
> > > +		priv->burst = 128;		/* might be 32 or 128 */
> > > +	} else if (data) {

> > When you posted this before I queried how and why the value might vary -
> > I see the code is the same and I don't recall a reply.

> This is the DMA burst size, and can be either 32 or 128 bytes according
> to the docs.  Everyone seems to pass this as 128 bytes in their platform
> data to date, which I guess is why its ended up being hard coded as 128.

OK.

> However, whether it needs to be configurable or not is debatable - obviously
> the hardware allows it, but that doesn't mean it has to be exposed.  If
> ALSA has some kind of way of specifying a "low latency" mode where 128
> byte vs 32 byte fetches would make a significant difference, then it may
> be something to look at.

This sort of configuration would normally be keyed off the period size
and so vary at runtime depending on what the application does when it
opens a stream.  Sounds like something someone can worry about if they
have the requirement.

--Mq/g1DrVwLsuPImC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR8lgOAAoJELSic+t+oim9NTcQAJAY3wv0YQcp5ZNk3jkW2BO/
aKMHDaysqtwbhoAASzJhVG9WWbld9L+DoevxqhH9lo05+0gA0JOxs7BHG7sLDFqI
kvERZ2ZZ4GZ2bySUFhSx09Da89Vi4KEaWwpgF8TUQu72q7JWWj59Q1uEf38XpdHL
j3Hr7p2XynbFFsJy3XoMZ1RTuZUGdpkpHRaenPhOojy1pPiseslr/RwAnZSXKuma
DVCH9veV9QIKAbVVdC6sRXdidff32JN/pjMcIpTxot5cvwJHMNrzWh2u9SwrqIoE
8x+x5DIRK8ZTAHidKpL+iMYWfvR3dPQxI5VIaWOhbpWEK/zI2H1gMkVS79BAFG4d
pOsYLiDmxuWu7ym4OkHOfEuGgjxeRNoSRfOHRnwa6GXZykNhhnU3hxMDc7CbFuKR
DxAOdiUpqpeysjH0bx7+kR/08YHVkGa5WEwkCFDcWK/Bm/I38Bv94N3qzUn/VmsS
nsbUPc7Hkdd/PD7SSvBqR8tQdtXQ7vl7kzw+AVoW6pbUGHV4sFTVj973MIvWxbLF
vE+6ZMNnsI4HRxMOxEhGIaFtzBW9RjTkuLzm4tdcZJQMLZbUJXLZlTlITGLjbRH1
qLtk+ltJfKPpF5Ietu36HZQueuNBZJf+6Et/tfRVCfX4qLnM/Ok2TMnF5P7V/hCD
aF7W/WYZWm59Nza5eTie
=jF6/
-----END PGP SIGNATURE-----

--Mq/g1DrVwLsuPImC--

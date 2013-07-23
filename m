Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932648Ab3GWN0d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 09:26:33 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:35515 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757117Ab3GWN0c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 09:26:32 -0400
Date: Tue, 23 Jul 2013 14:26:28 +0100
From: Mark Brown <broonie@kernel.org>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Jean-Francois Moine <moinejf@free.fr>, alsa-devel@alsa-project.org,
        Takashi Iwai <tiwai@suse.de>, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        Liam Girdwood <lgirdwood@gmail.com>,
        Rob Herring <rob.herring@calxeda.com>
Message-ID: <20130723132628.GD9858@sirena.org.uk>
References: <20130723102320.56bc4555@armhf>
 <20130723084347.GP24642@n2100.arm.linux.org.uk>
 <20130723130622.GB9858@sirena.org.uk>
 <51EE8158.4050300@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NknGfcVoKMD30k4E"
Content-Disposition: inline
In-Reply-To: <51EE8158.4050300@gmail.com>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [alsa-devel] [PATCH] ARM: kirkwood: enable S/PDIF
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--NknGfcVoKMD30k4E
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 23, 2013 at 03:12:56PM +0200, Sebastian Hesselbarth wrote:

> the mask that is changed in the patch is what will be written
> into i2s controller's registers. So, if there is no S/PDIF in that
> specific controller that bit can possibly have a different meaning.
> Also, enabling both I2S playback and SPDIF playback can cause the
> controller to behave differently.

Oh, so it will - I glanced through it and misread, sorry.  If it just
makes the enabling of S/PDIF mode conditional on DAI format that'd cover
it.

> I share Russell's concern about it and would rather like to use
> multiple codecs per DAI (DPCM) for that. I see Daniel Mack picked
> that up again, maybe he submits something soon.

Well, that'd be ideal and is going to be needed for any hardware which
has both wired up in parallel but a simpler either/or thing doesn't seem
like a problem.

--NknGfcVoKMD30k4E
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR7oSAAAoJELSic+t+oim9tckP/1Y/7eU4k2C9WrSBiS6KNzwK
L64Zr0SEx0ADTq5huA16s/t5jXD0z1XxDf9c7iShdCBo8VA9qFZDEeYdpIj6196V
nQaSUIHWeXnhm4yq8yv4PLlAclrIGTY95z2dizUpVKm70v/qDcjG+2yPzU2+HOye
tvLoJPEEJigfoWrJFk7mscooEgeB0BUzY3UYPRe0pwqJygJDzeI/3H5IW57W8dr4
bb1TdAZkWNf3xqJ4+r5WvKOmXdRQKGx0YaFDaUOEMzTHKjhQ5z+tfCnzbdnHMlq/
zsclnqNDekVQMEwYX9HvYbzThZFqHFpiEB1QVJ6YnsW1c2KlQtUwaSb1lq9mZfsE
jwM/UXkAwvqeDW9UT82a9ASX9Ly83TzrfL8Yfg3vT2KWmfqRo8cjMuJbx6pzict8
nOT94l8KMGDOUkqBQfIkTSEtVJd4TVen+zxv4RcOrnipHOkgrvO63tN0QpyzFAy0
uMDJI396tALu9XnzFUwqEqiiowRS7cwRL+9sXrQp+UZLmnQjJ/SzdRj47At4mVvI
pWEjaClHDwVYbA/+CV268TU4oV8lmYMM0o62cmRsWyp3x8bwG8mwt/JXtpqsm00d
HWWdUtGF1q2AvlpTopfswmxVjrjMFv/C1JiV/72xq3F4UkPF6rmNo+54C197OK/o
jXNsrXtLuTPY6RoKt3wY
=B2KQ
-----END PGP SIGNATURE-----

--NknGfcVoKMD30k4E--

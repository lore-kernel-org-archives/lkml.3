Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755377AbaCRQH1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 12:07:27 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:55642 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752778AbaCRQHU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 12:07:20 -0400
Date: Tue, 18 Mar 2014 16:07:10 +0000
From: Mark Brown <broonie@kernel.org>
To: Levente Kurusa <levex@linux.com>
Cc: Takashi Iwai <tiwai@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linaro-kernel@lists.linaro.org
Message-ID: <20140318160710.GE11706@sirena.org.uk>
References: <1395144178-3729-1-git-send-email-broonie@kernel.org>
 <CAAsK9AG7-12Y7RRdmmHDdGYqNh+qBuciD5YaptXZ_+rkvEGNjg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="j9XQ5cF5hebrmXqw"
Content-Disposition: inline
In-Reply-To: <CAAsK9AG7-12Y7RRdmmHDdGYqNh+qBuciD5YaptXZ_+rkvEGNjg@mail.gmail.com>
X-Cookie: Turn the other cheek.
User-Agent: Mutt/1.5.22 (2013-10-16)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regmap: Ensure regmap_register_patch() is compatible
 with fast_io
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--j9XQ5cF5hebrmXqw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Mar 18, 2014 at 02:43:18PM +0100, Levente Kurusa wrote:
> 2014-03-18 13:02 GMT+01:00 Mark Brown <broonie@kernel.org>:

> > +       if (p) {
> > +               memcpy(p + map->patch_regs, regs, num_regs * sizeof(*regs));
> > +               map->patch = p;
> > +               map->patch_regs += num_regs;
> > +       } else {
> > +               return -ENOMEM;
> > +       }
> > +

> I think that is not checkpatch-safe :-)

What makes you say that?  If you think there's some problem say what it
is please...

--j9XQ5cF5hebrmXqw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTKG8rAAoJELSic+t+oim9B5cQAIxfXhGCEERar1f1XDhrl/YY
UTNF6q+RI+Sc5Jz4/6JMFLsS8Y6Ol7Z6/TdxohkW5xAn5j7FmEpxRxDOHq9Z+zV/
nfB6S/4DuU9g4nQPz41ug6V6DVxYDZ07LDx4pDFW37c02WnqBn4oBJHS6TqHPfLl
Fgtm0Tdr8j7z+qU8dK7/q7mPKxwOxyjBGxPQxCKSYlM02uHm4SOT0+Fk87a/uFDH
94t9GLjXF3yLQWLURSX0bmSISfrDToK5m5qsuE0gGCpntb8OWjrYqKOKEUG0SA5m
UOD2rlQJODvGcIDs3nerPMhBX6lXlu1lOek79ufzGcQDxsAArNYe6bs7aIs60NqH
mh28b026ALQ+kOYIA0DAPA89qU1f1CvesUxYkQd7eSyicjOxvTo5MY6Iq0k9Y9HK
FqaQoQ59Gp/BNjijUsZLKrdyzmf8tq7/VJ8cEaUQ+nxrzkqI7lfcHPSIkmjrIITv
qmOEBUyu3F9v9gg4FPSq13FQkfF5f6ZD9zDBLQG5nb6plgKzRpeaZ1SENk4OmAen
inneNI6VJ3Bo9aiNmlbe9LsdXxY+9Sdm4Etfov9hKzz2rpN4NrZoL36s/G5ItDV2
ENi+EH0SAfY/sJVec0a64YfQCxo6Astfe+IU9zSr/eHo783QEpTMC+Vulm+OstwP
hE/fojKxBhvWPeUnTQaK
=M/Ha
-----END PGP SIGNATURE-----

--j9XQ5cF5hebrmXqw--

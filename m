Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756083Ab3FAWHF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jun 2013 18:07:05 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:37151 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751792Ab3FAWHB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jun 2013 18:07:01 -0400
Date: Sat, 1 Jun 2013 23:06:27 +0100
From: Mark Brown <broonie@kernel.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Lars-Peter Clausen <lars@metafoo.de>, Mike Frysinger <vapier@gentoo.org>,
        "uclinux-dist-devel@blackfin.uclinux.org" 
	<uclinux-dist-devel@blackfin.uclinux.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-ID: <20130601220627.GW16790@sirena.org.uk>
References: <1369993250-6461-1-git-send-email-geert@linux-m68k.org>
 <51A88C3F.5080109@metafoo.de>
 <20130601190328.GL16790@sirena.org.uk>
 <CAMuHMdX09zeshD4_TbU4MN1LjooeJKDUaAxsZ4CjNF1+Yp+STQ@mail.gmail.com>
 <20130601211045.GV16790@sirena.org.uk>
 <CAMuHMdWN6Ur47fBu3oZpah4fTaV+mV4Y_Q=SvV_jet-3FiZEUQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ItroYk2LVxvwOvi/"
Content-Disposition: inline
In-Reply-To: <CAMuHMdWN6Ur47fBu3oZpah4fTaV+mV4Y_Q=SvV_jet-3FiZEUQ@mail.gmail.com>
X-Cookie: Advancement in position.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 82.42.102.178
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH -next] blackfin: bf533-stamp: Remove bogus "||"
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ItroYk2LVxvwOvi/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Jun 01, 2013 at 11:29:23PM +0200, Geert Uytterhoeven wrote:
> On Sat, Jun 1, 2013 at 11:10 PM, Mark Brown <broonie@kernel.org> wrote:

> >> Sorry, I sent it to your Wolfson address, as suggested by get_maintainter.pl:

> >> Mark Brown <broonie@opensource.wolfsonmicro.com> (commit_signer:3/4=75%)

> > You're not using a current version of the tree you're submitting
> > against (which you should always do)...

> I'm using next-20130531.

Which has broonie@kernel.org listed as the maintainer address...  the
commit signer information isn't awfully reliable at the best of times,
it's got a big tendency to throw up false positives for things like
people doing cleanup work.

--ItroYk2LVxvwOvi/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRqnBfAAoJELSic+t+oim9ycwP/1VWitWVWrHlPUlUuA3waXl6
xYuMkFAnfI4hf10OTTU5QQ1rZEJZxps9dv06XUtvJETdpu3ysjJ4+7GOkv0aM6jo
aiQBEcvfCbAS/VKDHiiWOyNLMa0gGnQLItjUmWU2p8MkA8oaPlJDYPPBvi6T/pkL
z7Ce46m4V8lUYYOnpjmUiWkKQd/uLCZQEYBOEDmkIvGa6mZ2HWF9zKyfQohe768x
8SFtc3WMas2B4gy8qOsW4oo1vU6DYcVorNasyhy4EaugFcnZDLcSLLP9HgLKWr/I
snuEeoqjQfoTpfRsOaFquvIkOd7uEz1nkaQhqXWh89hDelqvikBjWl8z3pywg+W1
IQ2MrHNW8WQeAZxI0ZxpAeRyi3Zh34kMU6MXSarO9Dgn8LXT2ShSSNPndKRyO8Dr
9a3geszJQ7Kri5UFFF0NI126HZESuA5HS+BmcThbG9oW8SWchIaGpqM7k3WeBbLT
7Y4n1dh/rXIdz2BWyesMAFC6kuFfz+lhdS2xzUVgsGkCm1wEcwsm6OP00vMI1RCm
HSl82qQKkA9BX6CW2LPVyr4kkqc7HgNETJJOpAYT3Do0fxpia5iC2ndBFTAR4Jj3
YNQ5RTTXmeE1czxYQY5G01u0kY6a4dE9H+MHFmX0IhcK/JNhpaQKWkQ1ZhLVFfYo
qN6nz/A0bCvAfmYSG447
=MCiP
-----END PGP SIGNATURE-----

--ItroYk2LVxvwOvi/--

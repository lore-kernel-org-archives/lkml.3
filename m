Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758497Ab3GZKdB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 06:33:01 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:58697 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756558Ab3GZKdA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 06:33:00 -0400
Date: Fri, 26 Jul 2013 11:32:50 +0100
From: Mark Brown <broonie@kernel.org>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: Liam Girdwood <lgirdwood@gmail.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, Rob Herring <rob.herring@calxeda.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Message-ID: <20130726103250.GX9858@sirena.org.uk>
References: <20130725111357.7c976963@armhf>
 <20130725191059.GO9858@sirena.org.uk>
 <20130726082818.480d2a02@armhf>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="x9eD2RskteXOQWXz"
Content-Disposition: inline
In-Reply-To: <20130726082818.480d2a02@armhf>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/4] ASoc: kirkwood: simplify probe error
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--x9eD2RskteXOQWXz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jul 26, 2013 at 08:28:18AM +0200, Jean-Francois Moine wrote:
> Mark Brown <broonie@kernel.org> wrote:

> > This seems fine but doesn't apply against current code but otherwise
> > seems fine.

> My base is 3.11-rc2.

Always submit against where the code will be applied - -next in this
case.

--x9eD2RskteXOQWXz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR8lBPAAoJELSic+t+oim9zmkP/iAVMMZdWXAVm7B+SvNMPfqG
Iwa7wsV6m83cXPzGisvS4rIIL1ygbtZBnfoKYJE8uq+QDgFd/lBGQlGYkBkbWhYt
EqhXkHT47Be9b9CmfOI0tfe29WJbk1goubqz/no5Nb3fpuOBxtmUVdiEo5cHyFcf
Y/1iYIVwafYN5lJLHa5B7C1aOkPDhVN0GkMdWQDBnVnNwA66MXbNjuvz5+BwRoij
c7JpI2PHDtDjYypNu6cRaMBHKo2+BR+dTz4X4bKVXFfuFGCX6YsXk2SiXgAEEzqs
6OBQ+bZ9iDdYFRI1zFwe1SI20Xtofn3vph4SrqQP/FmH1kWCGoNap3pReRQb5/ZT
jo9ryNwORUKY7O3iEp+bcwmqlp+vPsfMXI1v+pF6PCQ6RScrgjNAhZeXOTIX6xiV
TGbYWDtE90THit0nVscvJWhRzOq6T0TszJgZP8oY9bAe2IhptIyJ5aMtgRYlFbZp
ZAlh3YU+tORHiR8wVwsak0ygSQXssb1zVpoqdR64Q7p2OriR35etnbgkE4aMjRdC
5rH0FuSJw+8+hTdPHihWtiScFdpHfKLr4D/LtbeRJ8R4UXXYynvyPjiHpvSfr+ad
x2A0riLmmhfBIH/Fob3kEvCMBLSYqQbvVgg1ApkNfv3erXXykAG59Rw/ci6XYtP/
R6TrfBpPf9PUQjLDIXy7
=X1z7
-----END PGP SIGNATURE-----

--x9eD2RskteXOQWXz--

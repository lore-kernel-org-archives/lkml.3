Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755676Ab3EQLIR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 07:08:17 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:52750 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752349Ab3EQLIP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 07:08:15 -0400
Date: Fri, 17 May 2013 12:07:33 +0100
From: Mark Brown <broonie@kernel.org>
To: Andrew Bresticker <abrestic@chromium.org>
Cc: alsa-devel@alsa-project.org, Liam Girdwood <lgirdwood@gmail.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Ralph Birt <ralph.birt@maximintegrated.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Jerry Wong <jerry.wong@maximintegrated.com>,
        Evan Ragsdale <evan.ragsdale@maximintegrated.com>,
        Dylan Reid <dgreid@chromium.org>, linux-kernel@vger.kernel.org,
        Matthew Mowdy <Matthew.Mowdy@maximintegrated.com>
Message-ID: <20130517110733.GK1627@sirena.org.uk>
References: <20130516175241.GF1627@sirena.org.uk>
 <1368731034-30135-1-git-send-email-abrestic@chromium.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="j/HO4hzKTNbM1mOX"
Content-Disposition: inline
In-Reply-To: <1368731034-30135-1-git-send-email-abrestic@chromium.org>
X-Cookie: You will have long and healthy life.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 212.183.132.60
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2] ASoC: max98090: add digital mic mux to record path
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--j/HO4hzKTNbM1mOX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, May 16, 2013 at 12:03:54PM -0700, Andrew Bresticker wrote:
> The max98090 driver currently treats the digital mic enable as a supply
> on the record path, causing the digital mic enable to always be turned on
> when attempting to record.  This is incorrect, however, since the digital

Applied, thanks.

--j/HO4hzKTNbM1mOX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRlg9yAAoJELSic+t+oim9yUMP/0wVoSZeTeV284+q1Mx+92iq
khkdszgBpjuyHhZcdxOcsIK11A6SYkfR4gcHJee4MD8q1i6XRAnfrhdDt4EKfc9D
O3TioJb2HW1xfSY7f6OxDYzpmWYULksg7FJvJL4CVdjz3NhmohleLvCYlwJgfF5Z
NusRkc2HMVprfa7+7ixTuM1ntndVNSMu1soWPaPypqsLkGCKku2jD9d5mdtDI63p
c3ugz2dd4sLDxkzp9BVyfXwE+CQJrvhJ2CFiSInt6P4YMM30OHpdQ8Hsb97QdBhO
k2LbgFI+oC72Z8KXmppEzYmjhJMDBfrQsvu+CMV8+LYY9a1lW6NysCuzsr1geprA
LriVRVzTX6fB0R0HbNnq6i5TzT/euBH/1LrqpT14EVobQfsu4Z59PbZhjPFtTyOC
4GkQZqqLe8R2T1nMC38NeJpOxwCQW0XETq0pvQcYm81cYLyQ9/wrDO+DTRBh6chA
MxqOTCW1LzaNNA+xTCMPcds/2mb4vuDO2bvPUQUAO/fuTbiClVy0cRHI7j5aKzrX
uKivlObwunuCVrWBkm00ts07/TqaqDWNumCbvnJZ89JgVJxkB6w5I8I89uaiY5yO
0jixnItwjkvj7MJ4mEvKgWn1GZnq+cOI4SaACOSRTnOd+gILAtQAgJWtyuxYAeC6
2L/SHPp1p3qt8rsn1y5j
=kkJU
-----END PGP SIGNATURE-----

--j/HO4hzKTNbM1mOX--

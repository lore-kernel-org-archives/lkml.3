Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935925Ab3DHMol (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 08:44:41 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:58082 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935387Ab3DHMok (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 08:44:40 -0400
Date: Mon, 8 Apr 2013 13:44:38 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Liam Girdwood <lgirdwood@gmail.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ASoC: Ux500: remove test for undefined Kconfig macro
Message-ID: <20130408124438.GL9243@opensource.wolfsonmicro.com>
References: <1364560101.1345.62.camel@x61.thuisdomein>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UUMz/kfoogzZ9WLZ"
Content-Disposition: inline
In-Reply-To: <1364560101.1345.62.camel@x61.thuisdomein>
X-Cookie: Your love life will be... interesting.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--UUMz/kfoogzZ9WLZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Mar 29, 2013 at 01:28:21PM +0100, Paul Bolle wrote:
> A test for CONFIG_SND_SOC_UX500_AB5500 was added in v3.5. But there
> never was a corresponding Kconfig symbol so this test has always
> evaluated to true. And since AB5500 support was removed in v3.5 it
> appears safe to remove this test and a few lines of code.

Applied, thanks.

--UUMz/kfoogzZ9WLZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRYrurAAoJELSic+t+oim9aPsP/3Dc335jJXE0S4Md6FFP8V2v
CLTjR5fXFr5j98CtXULSMBivry6wqZy2KLGlUiximzYXoCjtVbOAirQOWI6wjtl2
V09sUz7QMbstbJc3SN5PCGN4UO0ZxSimyiWMeXhyw+qtNUOJcYY9HdxNSZC+Q8jG
peWz2V0TVMPK0qTsO74Lpb7ZI0FlvmfHlf+I/N2svKsCpy3hQvVqzX+wGwNDd4m+
gat0FSHq9kfwB8inpoevIX08pdU9rZM/37M/8vDLL9SNbN+wGNwRhEYIKiVOhskI
C2pFNkBKWYEV3Wa4bNWEgotqjr500WuKeUEAORxPQrqwCh3uW0+7VQecWwlTcg/H
gju8yvXdF3A5bH/U8gn42b77Ku5nMdHnC9m+9aQLmUDicxq86VTzipUZzpX60UYP
/AAB9I6W8AMaWOXfkI4HifUsr9VQRY6pPcH+uPfgg6GArav0kXxYEgXiGXnaKKMo
3cHb5aaXwrHgRl3x9Q48Cd40kSaZJGCIdtVi2+M2O9LiFlO3M9ehDt+NClH7svFU
QjNrNWeWRPbUQdACcrv53HQXdbc0gd5QjLwCNRePJbQ/iH3eqBsrSJOTYd+QV5Fp
atp2r9o2j62KXWlvh+hCWEpcwWcuR9hpY93Ug/5CNzRRZ2759oeemgFExgLWBwAX
w2jkygFGxirUuTy+6Eto
=VYCU
-----END PGP SIGNATURE-----

--UUMz/kfoogzZ9WLZ--

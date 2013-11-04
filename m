Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753928Ab3KDRK2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 12:10:28 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:47123 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753898Ab3KDRKW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 12:10:22 -0500
Date: Mon, 4 Nov 2013 09:09:50 -0800
From: Mark Brown <broonie@kernel.org>
To: Nicolin Chen <b42378@freescale.com>
Cc: lgirdwood@gmail.com, tiwai@suse.de, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Message-ID: <20131104170950.GO2493@sirena.org.uk>
References: <1383548251-17655-1-git-send-email-b42378@freescale.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hND5PKUeuErErcgH"
Content-Disposition: inline
In-Reply-To: <1383548251-17655-1-git-send-email-b42378@freescale.com>
X-Cookie: You love peace.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 209.49.225.226
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v4] ASoC: Add pinctrl PM to components of active DAIs
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--hND5PKUeuErErcgH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Nov 04, 2013 at 02:57:31PM +0800, Nicolin Chen wrote:
> It's quite popular that more drivers are using pinctrl PM, for example:
> (Documentation/devicetree/bindings/arm/primecell.txt). Just like what
> runtime PM does, it would deactivate and activate pin group depending
> on whether it's being used or not.

Applied, thanks.

--hND5PKUeuErErcgH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSd9TbAAoJELSic+t+oim9jYMP/02gbCuXf3yuEO0cpIHEO6hE
4HCkFOhpbiQlSzJWbgBVaeSUfX5GZT12t6lv2AyeUjP9Mj9riWS/tzldoBlg+Me4
StQ3BeYTHWLL0gFR2DMpKnfLMlB/EHEUR4zYDWbL6FqYBBrUAFQZcdmsjQd5GmJI
NCE3bQvewitpfKT+1VIPEoRVYWbLTNA5bH6qDuVL1q8rPpZfnYdy7YO8DbU5FHYs
XSrzBPL4DTwZHD49Ej0Eju6UplSTGoW4SJ3ik2oDo66igEjr9oClFRqzbUdlYgAu
V0jhFAicNs5VQCVBo7Ap0X/BA9sYfZGh9IR86gH2IRb3ZwxY30HC2VBP2Xgg6Izi
QylnF0ZLtfkkGewlnleXZJylIeWbRORZmpoCiv5B5H4LWRV0hXOSbqOKP2mw+2PC
FarOChe5w17DrHd8YJfMNPMp7owbdWM5aqN3LGfhtPF1aDWAlwXgxZFrGHASmZIZ
KphEvh+LvTzQiRV2DXvrpzL27UiGPf/d8eAUtHgEOJdkmNSOhM4borIVsx/JnOfb
/irGV23O1cYwNowuzv6PdMdGulsDGGm0opKV177imOg/IeNihmCDmJW4IPuZc7DT
6en+xMNP/bOHeQ6v6fZdpgAS9sDa9kQPV/77YLkSrjMmA2MUg4t8WJHkshlnixMv
AzmaGP7tja1feSDMYBet
=snMs
-----END PGP SIGNATURE-----

--hND5PKUeuErErcgH--

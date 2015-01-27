Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759488AbbA0SuT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 13:50:19 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:36647 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758625AbbA0SuR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 13:50:17 -0500
Date: Tue, 27 Jan 2015 18:49:10 +0000
From: Mark Brown <broonie@kernel.org>
To: Inha Song <ideal.song@samsung.com>
Cc: alsa-devel@alsa-project.org, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, s.nawrocki@samsung.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux@arm.linux.org.uk, kgene@kernel.org, sbkim73@samsung.com,
        lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.de,
        grant.likely@linaro.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Message-ID: <20150127184910.GL21293@sirena.org.uk>
References: <1421989410-12490-1-git-send-email-ideal.song@samsung.com>
 <1421989410-12490-3-git-send-email-ideal.song@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="BupHoQMOlvKF7IyR"
Content-Disposition: inline
In-Reply-To: <1421989410-12490-3-git-send-email-ideal.song@samsung.com>
X-Cookie: My LESLIE GORE record is BROKEN ...
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [alsa-devel] [PATCH v4 2/3] ASoC: samsung: Document Trats2 audio
 subsystem bindings
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--BupHoQMOlvKF7IyR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jan 23, 2015 at 02:03:29PM +0900, Inha Song wrote:

> + - samsung,audio-routing : A list of the connections between audio
> +   components. each entry is a pair of strings, the first being the
> +   connection's sink, the second being the connection's source

The list of valid components should be specified here - reference the
CODEC bindings for anything on the CODEC but things on the board need to
be enumerated.

--BupHoQMOlvKF7IyR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJUx92lAAoJECTWi3JdVIfQJd0H/RGrpS2pSSQhGQPjNHK2GSRu
/l8yWZVaxI8SGIfcZZNetKBPv84uXrU7QUNRLttL6EfeAC0qgt0QS4XbdtY1ubeQ
YAGqUSv18N0Ym66scWiQqDGyZ3b0Qu2EEwwq+Ec7NockWutfumNG2jxFHzGRw0WF
8/0rPCaf6BnYNc02Zg2njB2WDXA3u1KKShiX/sCdQEW/Zy5gWFFpx5VuxIqh/Pxh
r3rqH74oCymM8JoarNuUtA6JMB7RVlwc3VyMRq8FjCmQpEVzVyp68/RNb6JOJJON
xLdj7bvE38HDkrnOfw2+Vr7av9K/UxNUxZOf/XRebkU+wRJm+f74ZvjJNrg1E8M=
=OLNI
-----END PGP SIGNATURE-----

--BupHoQMOlvKF7IyR--

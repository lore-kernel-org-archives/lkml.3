Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752943AbbAUNvg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 08:51:36 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:55877 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751546AbbAUNv1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 08:51:27 -0500
Date: Wed, 21 Jan 2015 13:50:53 +0000
From: Mark Brown <broonie@kernel.org>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Dave Airlie <airlied@gmail.com>,
        Andrew Jackson <Andrew.Jackson@arm.com>, Jyri Sarha <jsarha@ti.com>,
        alsa-devel@alsa-project.org, devicetree@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Message-ID: <20150121135053.GI21293@sirena.org.uk>
References: <cover.1421782532.git.moinejf@free.fr>
 <ddd1b299eca187ab2fa9b119da2ec8297ead1a66.1421782533.git.moinejf@free.fr>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="GlnCQLZWzqLRJED8"
Content-Disposition: inline
In-Reply-To: <ddd1b299eca187ab2fa9b119da2ec8297ead1a66.1421782533.git.moinejf@free.fr>
X-Cookie: My LESLIE GORE record is BROKEN ...
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v10 9/9] ASoC: add generic dt-card support
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--GlnCQLZWzqLRJED8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jan 20, 2015 at 08:16:25PM +0100, Jean-Francois Moine wrote:
> To create simple cards, the syntax of the simple-card does not follow
> the common binding of the device graphs
> (Documentation/devicetree/bindings/graph.txt).

Please be more specific, I really can't tell what this is supposed to be
doing from the above - in what way is the binding not common and why
would anyone care?  Please also address why this is done as a completely
separate implementation rather than a new revision of simple-card and CC
Morimoto-san so he can review (given that he did simple-card initially).

>  sound/soc/generic/Kconfig   |   2 +
>  sound/soc/generic/Makefile  |   2 +
>  sound/soc/generic/dt-card.c | 275 ++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 279 insertions(+)
>  create mode 100644 sound/soc/generic/dt-card.c

As you know all device tree bindings require binding documents; you must
supply a binding document.  I'm not going to look at any DT patches that
don't include binding documentation.

In general please pay attention to changelogs and documentation when
submitting patches, the harder it is to understand what a patch is
supposed to do or why the harder it is to review.  I keep saying this,
it's really important.

--GlnCQLZWzqLRJED8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJUv668AAoJECTWi3JdVIfQTCQH/3LeWH0MvFi6Qqax4tZWuAvl
uPsAYOvWkxKu9b28WmnFC+xco356sr9wcslrN/zmlh7LwuGPQUvnEbCrXOQIosjj
zb2UuJUJdjlKZDRvoFti8OiEKqcz1L7uO2EDrc8LBMlE40U6rdu+ajrZ+hwtSqhS
U9i7/ELtVZBCsI6PHSSP7Ajv8XgpWUqqrC7oSrnsW5I3ol9APZIlX0c2MO5fQQrT
ZZzP99L7kopiJ5LtwkK1/0VxxOoPBAGLWd/JFtByDyESq6APEEuX2EcxqniKvA/W
Ynv6SoCdm8GjFt9lg0dWc6vmsa1Yf1thdQrGAJ/mYqvorlLN/TO827KNVY+VYTg=
=0ztJ
-----END PGP SIGNATURE-----

--GlnCQLZWzqLRJED8--

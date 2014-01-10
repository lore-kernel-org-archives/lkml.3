Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755983AbaAJMyr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 07:54:47 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:52081 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752485AbaAJMyp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 07:54:45 -0500
Date: Fri, 10 Jan 2014 12:52:31 +0000
From: Mark Brown <broonie@kernel.org>
To: Nicolin Chen <Guangyu.Chen@freescale.com>
Cc: timur@tabi.org, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, rob@landley.net, lgirdwood@gmail.com,
        perex@perex.cz, tiwai@suse.de, grant.likely@linaro.org,
        shawn.guo@linaro.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org, linuxppc-dev@lists.ozlabs.org
Message-ID: <20140110125231.GK29039@sirena.org.uk>
References: <1389347646-20432-1-git-send-email-Guangyu.Chen@freescale.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VJJoKLVEFXdmHQwR"
Content-Disposition: inline
In-Reply-To: <1389347646-20432-1-git-send-email-Guangyu.Chen@freescale.com>
X-Cookie: May I ask a question?
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v3] ASoC: fsl_esai: Add ESAI CPU DAI driver
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--VJJoKLVEFXdmHQwR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jan 10, 2014 at 05:54:06PM +0800, Nicolin Chen wrote:
> This patch implements a device-tree-only CPU DAI driver for Freescale ESAI
> controller that supports:

Applied, thanks.

--VJJoKLVEFXdmHQwR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSz+0LAAoJELSic+t+oim91akP/2mtB/1hNpiDcevh1qECfDrT
EbvzZIEfN5bJQCjSsA1j4uv/2wz7u3teazfK1SmQHcBv7IF6McpQktdZD5KaP0LO
sXmV3o6qCfm7ZflKt2fjU2CtnVO1/PFwxfdNhxG+BZ7n8IqwW7EF/Oyvg0a8FAbx
jI9wxpur/hnqBbQGCi+g/NZ5RFouoH9EJ6W2YnSuCqMT/h/ifTX2gjf0GLlDJ/ip
Q0fqFfwZPaxFJzUQrEHl7THfEr9MkZswgD6eY8a/bw9Nb5R3a6d1TsToFipco6Zl
XedQyIBU33hgbq/l471+YH3RtNNQW2PTYP75+Aj1glQxxY0n1MplF7A06obKnBpe
f9m2WD+6j1fVX0nQVsLXpdN5mcKTk1H0NumOWqi+CQpk9ZYivupXNoKDdq8pk+bX
DRaQ0yGuheuPCr9BSnK20c1PRnPRwgpaqBfhbd4vZHiuIZFH+TMFz2q2w6IXnE4z
NDuLj2oAy6BNGb0hCK9FVXXmHnGCKdXaugVoWkp8EG47D2DI2D4sU2Cx1Y/kzbot
U54pvApJaKaADtFyAm2Z0t1GzCN1TgmAsJa4K1J/tF3S7/0IrD49XzGGQtPB5QP5
3ZvYG9iemHZoEfJiPzhQQZRCHCO6WCEuLgqFRMk3p75ZAx3FYxdv3XCRH6FMgR11
JA6UEdXSAb+Gl9OMKVLX
=yaEU
-----END PGP SIGNATURE-----

--VJJoKLVEFXdmHQwR--

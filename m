Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759751AbaGDTcc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 15:32:32 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:47329 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753115AbaGDTca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 15:32:30 -0400
Date: Fri, 4 Jul 2014 20:32:11 +0100
From: Mark Brown <broonie@kernel.org>
To: Tushar Behera <tushar.b@samsung.com>
Cc: alsa-devel@alsa-project.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        dianders@chromium.org, tiwai@suse.de, perex@perex.cz,
        lgirdwood@gmail.com, galak@codeaurora.org, kgene.kim@samsung.com,
        ijc+devicetree@hellion.org.uk, mark.rutland@arm.com,
        pawel.moll@arm.com, robh+dt@kernel.org, trblinux@gmail.com
Message-ID: <20140704193211.GJ14896@sirena.org.uk>
References: <1404463980-25027-1-git-send-email-tushar.b@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9aCKuHbn5v2q3RVc"
Content-Disposition: inline
In-Reply-To: <1404463980-25027-1-git-send-email-tushar.b@samsung.com>
X-Cookie: This bag is recyclable.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/2] ASoC: samsung: Update sound-card name for Snow
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--9aCKuHbn5v2q3RVc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jul 04, 2014 at 02:22:59PM +0530, Tushar Behera wrote:
> Snow sound-card driver supports multiple boards with different
> audio codecs. Updating the sound card name per board basis would provide
> some more information to the end-user.

Applied, thanks.

--9aCKuHbn5v2q3RVc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTtwE4AAoJELSic+t+oim9eBQP+wSTOTDTRhu+W6zH+JqKRs1z
4k5RWU2uTnqSmdJQ3nP9NzbSg4r1RstICOwHY+SC39eTbTpG6J4aYyw0wUAgaQv/
UnDeNqPFTiW9WMzJ01fIFlac8kiSONvB35si1uLf3NSEl3mLdOGd3HSub4sVrfE4
VT156VXGg9oxDhWBWiqX/0ukV9xwW3x+TJ0raXTXGbB+AiQol2MU+bXxURs+v//y
soVUPK1cTUApAU1KNVMOqzS7hIxa5Ijan6LafljJc4+Ef4nF0IN+rI1TF1ubHBDu
QdMNrLKchEXRiGohqNhNjDLMby3lTLtnyDsrLhx/YeY836SGrgxh573rseQ47Dq/
NnY8d5tnhgnv4y+8/BTgiEGJLwECEvMHL0EA0xPLWkPMSKUphhgtMqGACd+zljdV
NsQjMTUWUtRYuO9+I9Nx0wjzWp5qZjtdFNHx5LeAiQz5urGoQN7kgyCw7KaWBAuo
CF0+YULm1ifVl49i9DL3PuwmzKgPDKjdrESmQPs/KLJoZGDOAcmQhiKqAKjy8M/r
adjnCzhTGlHanIpYYcihZlHW4sEiEnI1h37W9Wlwxvm0CL8julgLnPZWhm775RRj
3ARGVrmw1RDMgV/zTur6RNBQotBtxWTBKm1kbMApCJw5hwbsINZJ/iEYAb+7RAuv
R7vGX6KxRhf+fKpWxN8q
=M42b
-----END PGP SIGNATURE-----

--9aCKuHbn5v2q3RVc--

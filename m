Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754421AbaIDWzi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 18:55:38 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:50604 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908AbaIDWzg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 18:55:36 -0400
Date: Thu, 4 Sep 2014 23:54:47 +0100
From: Mark Brown <broonie@kernel.org>
To: Doug Anderson <dianders@chromium.org>
Cc: Addy Ke <addy.ke@rock-chips.com>, Heiko Stuebner <heiko@sntech.de>,
        Alexandru Stan <amstan@chromium.org>,
        Sonny Rao <sonnyrao@chromium.org>, linux-rockchip@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <20140904225447.GZ29327@sirena.org.uk>
References: <1409777067-17422-1-git-send-email-dianders@chromium.org>
 <1409777067-17422-4-git-send-email-dianders@chromium.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Sg+dTrkCjluZnrMn"
Content-Disposition: inline
In-Reply-To: <1409777067-17422-4-git-send-email-dianders@chromium.org>
X-Cookie: Simulated picture.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 3/3] dt-bindings: spi/rockchip: Mark DMA as optional
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Sg+dTrkCjluZnrMn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Sep 03, 2014 at 01:44:27PM -0700, Doug Anderson wrote:
> The Rockchip SPI controller works fine without DMA (aside from a few
> warnings).  The DMA property even implies this, saying:

Applied all, thanks.  Please use subject bindings matching the style for
the subsystem.

--Sg+dTrkCjluZnrMn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUCO2zAAoJELSic+t+oim9CTEP/Rf44WtOb/2Vx7JHJA2+h3UX
35cBi+EM8jfJ2Gs5bSL8bdErUkzd7FcVjaI+FCpn2BEc8uepPFFVrmG6RtZRspoT
wWpc+44c0Je9GlqLepcSx2lReGtaOTJk5fpVlkf+3qseHcGMpqruoUrVpGn6ACqn
H6Yi7JvxaLPeZ4MVvb6zfyy2GkvK0kSc5uFA5/AfBIeBUn0A+jQLQ8EuaUwhjdKf
9zWOmGIQ6LhjdTWuVU5F9W4pwpbRKE7hy7Csac3/8KZXaAdHIcz83fnjvXxdbnJc
hB/Zif6aNi/DEI0Ml7pKbl1LkrivtthbEzd5S1B4fBhfeqWCD/SKlCd0+4wbRkez
HlEfYNhm6doj6W39qRBmhCx+1QO4UdZ1muzUsAiYFESWbKyWg5U0UB5MfVTnktMc
yxkW6ZG+J+KkyEMCCCMT8Wk/gxmwTbDw5VFuhwv7evSng0bShl3bwW7zN5tNeGh+
8uZx2S/lZBDEkQUO3ePsse7+sXD8Hg1H9NY+/WQd1QLIT915Bcw0NNAm38tw1G0l
RMwalQakZlIvNWISCPFWINrSjeLeVz3+ppyPoU2DVMCyMsmVzMZ3ISNxevy58L+E
L4zilvlEzLQFkZN57Uqfzg7eXXEd4LuYupCFtPMIZvMmXkITLIXEZsw0ndEQWQmi
oJTVgZWn9vi9/PxCvpDp
=MFC6
-----END PGP SIGNATURE-----

--Sg+dTrkCjluZnrMn--

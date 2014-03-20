Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758107AbaCTLui (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 07:50:38 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:57162 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758056AbaCTLug (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 07:50:36 -0400
Date: Thu, 20 Mar 2014 11:50:10 +0000
From: Mark Brown <broonie@kernel.org>
To: Nicolin Chen <Guangyu.Chen@freescale.com>
Cc: <brian.austin@cirrus.com>, <Paul.Handrigan@cirrus.com>,
        <robh+dt@kernel.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <rob@landley.net>, <lgirdwood@gmail.com>, <grant.likely@linaro.org>,
        <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <alsa-devel@alsa-project.org>
Message-ID: <20140320115010.GD11706@sirena.org.uk>
References: <1395310717-2090-1-git-send-email-Guangyu.Chen@freescale.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Mx3Wl9kSzNzqr7Kn"
Content-Disposition: inline
In-Reply-To: <1395310717-2090-1-git-send-email-Guangyu.Chen@freescale.com>
X-Cookie: Turn the other cheek.
User-Agent: Mutt/1.5.22 (2013-10-16)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v4] ASoC: cs42xx8: Add codec driver support for
 CS42448/CS42888
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Mx3Wl9kSzNzqr7Kn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Mar 20, 2014 at 06:18:37PM +0800, Nicolin Chen wrote:
> This patch adds support for the Cirrus Logic CS42448/CS42888 Audio CODEC that
> has six/four 24-bit AD and eight 24-bit DA converters.

Applied, thanks.

--Mx3Wl9kSzNzqr7Kn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTKtXvAAoJELSic+t+oim92oYQAJ4uVmnOH/4eaekP8lsS+Poa
28nCDZbM2/U5rt2H6Id0b6F6ZnmDfuUN7BKN8TsTFMRUoKf+YZkFJ9cxnLV4Np4u
6u2DOsSTNyIlQiRODPmQn2XUCFSD+VHxX+w7m85ysUdbO9RoQzpFtd384LLpfrWU
mUvpc9cJXHy9WtFzJWnyE3Diem1WOk6Y62T0LT5YonMgDpgC9gc95Zk3JcHQOMEc
/SBlrnezoG9nPmHQmgA5nzgAmhDSL3cPRbHexlRMgaRNW0+w8iMbCBVDUIyE6E95
0agE16yPjwkSrLgH3IOToWaq5FKHeTZ3x+b/T/WwbWM5vDjqRFmZ14cogx+21E/l
lw0dVEpKkboOojimcJGNmokxfhSddugr4/yFF531WcTDmxvBSoi7UPKdcLd9tZPX
qxOZG8AgZ2DgrQNP/Iy03MudzOaM5zD4DbYX54Bdrhf4rLET25mXQmTIGLVJanny
9hsusNCv9oH/BXp/k/9jhPkYw3vBm0Ops4kzLVWFX53rr6K3I/AXZLlCLM8JU6/t
RhRL+CLlHwc8tgV3RfcjPUabtgS6s6hDJ4vk4IgbzDcGahV88K0dSnqq+KIdJHez
GcucK2+k/9M4jvICCioRhdBwsI/O3Wj59ftQ8JurZ6LbxPXHGapZGXC9DHvxF6os
S8aeytThkzEyycz3tKz5
=27uM
-----END PGP SIGNATURE-----

--Mx3Wl9kSzNzqr7Kn--

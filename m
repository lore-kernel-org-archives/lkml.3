Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758059Ab3GRPTR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 11:19:17 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:39849 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752845Ab3GRPTQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 11:19:16 -0400
Date: Thu, 18 Jul 2013 16:18:53 +0100
From: Mark Brown <broonie@kernel.org>
To: Chao Xie <chao.xie@marvell.com>
Cc: linux-kernel@vger.kernel.org, lgirdwood@gmail.com, xiechao.mail@gmail.com,
        Yi Zhang <yizhang@marvell.com>
Message-ID: <20130718151853.GQ22506@sirena.org.uk>
References: <1374116823-27414-1-git-send-email-chao.xie@marvell.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="az3KEMGG4k+YNHvv"
Content-Disposition: inline
In-Reply-To: <1374116823-27414-1-git-send-email-chao.xie@marvell.com>
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH V4] regulator: 88pm800: add regulator driver for 88pm800
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--az3KEMGG4k+YNHvv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jul 17, 2013 at 11:07:03PM -0400, Chao Xie wrote:
> Add the regulator driver for PMIC 88pm800 including device tree
> support.
> 88pm800 is an I2C-based power-management IC containing voltage
> regulators, a real-time clock, and some general purpose ADC devices,

Applied, thanks.

--az3KEMGG4k+YNHvv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR6AdaAAoJELSic+t+oim9UmsP/jrODWuA84ZTdsEX2Fbf+zTi
vmgb27C6+lgeT/W6EPv0S7xlJbnJCqhdEGOps8kYY/fMSuwFvU15e+7EcRRnTsJx
dRNWer7bNp02Ls/zyBOrNLeE6KiD0S5JxyqFs21LViID2jhdIdE6D0kfQhnQIftX
4LLTvUFNvWGOJsGy3l5mr55Bx3h00DNZGw6O48Vs+7FHXalOPMuj9Ocl7kCsi7uh
QHJAe5T8M/ldZcpuJ8KLPwXQboD+5yP/Zi1m3n9qJGBphQE6xFN2OqmbeVfDR4t8
WqpknWMurCoDKyVOfcEp8yYOA59hqd85ZdS+Him77YNMReb33F0vlWtirx6gcJPp
kxe4fPevWysHXSN7/6ZBX6JTthp2vLwXENoijIf4EpRvwRMn0RpQN6hJiMn/0AfL
bKvdO9FpHIemlKWS2pVcNj5kefj/wn/wgmvJLekPiXdcVXT7k0B5UiNMaszjf51O
NxYZrJM1rtSw4JD4NcmL+eQEaqjFja64xqX2qDJ49J07jzCDZaeRZEzcWaJoGKhH
DX5mfIAlX9L/lUlbEDQC0qt4XCONF6s/lKjIhS4cRAMgFFW3hfa1tLG4oh0DXo0t
SASex54lNm5JOTYJdFBrbLjeGxhJMakLv4/f3610QopV2RSRWckwcs458a0+jZof
tGyjEnR3x/QFcSmCk5MD
=oSIh
-----END PGP SIGNATURE-----

--az3KEMGG4k+YNHvv--

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753584AbaDWMqu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 08:46:50 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:42898 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752692AbaDWMqn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 08:46:43 -0400
Date: Wed, 23 Apr 2014 13:46:29 +0100
From: Mark Brown <broonie@kernel.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org
Message-ID: <20140423124629.GA12304@sirena.org.uk>
References: <20140423113941.GL21613@lee--X1>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PLySx9pBl73A+dIr"
Content-Disposition: inline
In-Reply-To: <20140423113941.GL21613@lee--X1>
X-Cookie: You will be successful in your work.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [GIT PULL] regulator: First pull of MFD <-> Regulator IB (v3.16)
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--PLySx9pBl73A+dIr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Apr 23, 2014 at 12:39:41PM +0100, Lee Jones wrote:

> Doug Anderson (3):
>       mfd: tps65090: Don't tell child devices we have an IRQ if we don't
>       mfd: tps65090: Stop caching most registers
>       regulator: tps65090: Allow setting the overcurrent wait time

Can you drop the last one please, I've already applied it?  I'd have
expected just the first two (or probably even just the second one).  If
you need it in your tree just grab the branch (or I can tag it if you
like).

I tend to apply these things early where they don't have dependencies
due to the large number of reposts for unrelated changes in the series
that tend to happen (and often several very similar serieses being in
flight at once); I frequently end up just deleting them unread.  Not
sure what the best way to handle this stuff is in general.

>  Documentation/devicetree/bindings/regulator/tps65090.txt |  4 ++++
>  drivers/mfd/tps65090.c                                   | 41 +++++++++++++++++++++++++----------------
>  drivers/power/tps65090-charger.c                         | 11 -----------
>  drivers/regulator/tps65090-regulator.c                   | 56 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/mfd/tps65090.h                             | 19 +++++++++++++++++++
>  5 files changed, 104 insertions(+), 27 deletions(-)

Your formatting for these still seems to be messing up.

--PLySx9pBl73A+dIr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTV7YiAAoJELSic+t+oim9g2kP/0MFvzRXIbXKJrtcGpox0AQc
HfNnOUWFehgr2FzHieMXFllFmyhub9/DZl0kgR1658Kv+nLP3tzxcGBZMTnaGzSV
MhkbHaA9Wg6g8uS0jH5OZiEwlhuvljOVAGiPXudClW29XmcvKs91en7XNS0TT1mc
LAeYYNxPMqDtUWmFZLVdfstVbaoYhgW0L9Xcfv5NQahXC4L7baofOIRh/tOvcG3F
PkbHW58egs+9BdcXWHDu9C35T2PUbJt0/zkfl0qBtK2f+Qn7IBbzgEkEZtqVUASL
bpCvx2WDjrEfjUxzJ7vdcPH1tCkHbzLq3D1y8LjIZ/0vO04q495LoY4+ExnQP2lG
YdI3fqtgbGBAF8CuZtBDTsi0J+8hgAtMF/LSs1R6II9qESDTZFoKBxyHuXRG9ZRp
OKQFqTLePKqcBEmYLNgvg//Dg4IhZaiLashshKiAmgmSffXH2/xw9bZMjG5HMcgW
7Z+c00Q6LF3vHRFiLPAI2Tq3NkJbhidk5UGtjvc6fdtpkEFsdyXhZYErLbvB/vRx
d+GK4OtMhT0okoAVBoUl//XTDIIUyfXIMKnxVkSNn5QjQMqt8TDwe+dnUI4U1sCq
PBtlgJEmgvDIxgibLE/lnhwLHpP1GrjLGs61qGMvxx04Kcrxk2iznb7e4BlKu48X
6ZmnRtLTKwdqOfApoC+O
=P2hl
-----END PGP SIGNATURE-----

--PLySx9pBl73A+dIr--

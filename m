Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932217AbaDVLDB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 07:03:01 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:41337 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932154AbaDVLCz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 07:02:55 -0400
Date: Tue, 22 Apr 2014 12:02:36 +0100
From: Mark Brown <broonie@kernel.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: Doug Anderson <dianders@chromium.org>, Anton Vorontsov <anton@enomsg.org>,
        Olof Johansson <olof@lixom.net>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        AJAY KUMAR RAMAKRISHNA SHYMALAMMA <ajaykumar.rs@samsung.com>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Simon Glass <sjg@chromium.org>, Michael Spang <spang@chromium.org>,
        Sean Paul <seanpaul@chromium.org>, Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-ID: <20140422110236.GN12304@sirena.org.uk>
References: <1397689950-1568-1-git-send-email-dianders@chromium.org>
 <1397689950-1568-6-git-send-email-dianders@chromium.org>
 <20140418174353.GX12304@sirena.org.uk>
 <CAD=FV=VQckC34rZwF2RP3F+2T1CRVs0JwtgoqUeA1NVmB20=sA@mail.gmail.com>
 <20140422074709.GD17657@lee--X1>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7n4sH0AOSdTe0Gi7"
Content-Disposition: inline
In-Reply-To: <20140422074709.GD17657@lee--X1>
X-Cookie: You will be successful in your work.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v3 5/5] regulator: tps65090: Make FETs more reliable by
 adding retries
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7n4sH0AOSdTe0Gi7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Apr 22, 2014 at 08:47:09AM +0100, Lee Jones wrote:

> If there are cross-subsystem dependencies I prefer to use immutable
> branches to eliminate any change of merge conflicts in -next or the
> next merge window. I'm happy to either create on with Mark's Acks, or
> receive a pull-request from Mark with mine applied.

> Up to Mark.

Well, Doug didn't send me the MFD patch so I can't do anything with it
anyway.

--7n4sH0AOSdTe0Gi7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTVkxJAAoJELSic+t+oim9b0UQAJ3/Ie7fvY23Vspef191P0fO
3gLow7Q44cFH8GW06LJEyeJoKP1YGf1RHMcZQeO3FqKrPE7avtvzCZkfgKzKxzAv
526m9rM6fCLWdAJX9ZEaiEGznsT/mfBjd/WDuJpf83yOPk6cbrFJG+7NQDaF3mN6
ugaJXcqnJ6TVHzDWGemhrkswN1KlJ7oArq60OvndcnplpX3i5s+fjq4EN8LuaL5J
zLF+4vDRssyrciiH3cS8MQX7T/tp8TvMK/VIVIRchydoUTf/qIBXOiM9hVqANfsy
mquChJOXbS/MXa0GmpA+MUp/YEq7o2QEKGdKuONxVQ19/SSxn7o6WPsVVOPp4npx
v9aIWJu7GyN/W3fP99ug5IHMZnrHRDa4ExSP7lL5DKvAf51YhIKyYHHo9i/+ijAU
5iruNJNJW8LKPPwc9T5X9xcnvEfaLGnpmzsRJancDEs9bQAFSeZ4cJo1VrKpkoog
gYu0yV6zxwy3tLpBccGEvkiyPY8xSuhj0RC4yFE2rP7ho4xBL9RPakV+ZvCQb6rG
VaGDnhglLY12SV2dAqGIjXD/UC1MIoD6gJKE05Zl9kq+x+EgYn4qPu3hqNPYTtVU
DkVv2Z1s30HLALnDijm2dvHs95EJwIm+UuDeiqJjK36o1df2y3+Jd54IzH94j7iW
WBHXsY+J+5K8mlgfLvS4
=6Jv/
-----END PGP SIGNATURE-----

--7n4sH0AOSdTe0Gi7--

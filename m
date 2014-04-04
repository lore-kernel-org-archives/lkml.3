Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753273AbaDDMsc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 08:48:32 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:51219 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752659AbaDDMsa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 08:48:30 -0400
Date: Fri, 4 Apr 2014 13:48:05 +0100
From: Mark Brown <broonie@kernel.org>
To: Christoph Jaeger <christophjaeger@linux.com>
Cc: tiwai@suse.de, perex@perex.cz, lgirdwood@gmail.com,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Message-ID: <20140404124805.GU14763@sirena.org.uk>
References: <1396611859-719-1-git-send-email-christophjaeger@linux.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tphTSO44SEA4WSDH"
Content-Disposition: inline
In-Reply-To: <1396611859-719-1-git-send-email-christophjaeger@linux.com>
X-Cookie: To make an enemy, do someone a favor.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ASoC: alc56(23|32): fix undefined return value of
 probing code
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--tphTSO44SEA4WSDH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Apr 04, 2014 at 01:44:19PM +0200, Christoph Jaeger wrote:
> Commit 5d6be5aa ("ASoC: codec: Simplify ASoC probe code.") left variable
> 'ret', whose value is returned, uninitialized. Since it is not used
> otherwise, remove it.

Applied, thanks.

--tphTSO44SEA4WSDH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTPqoCAAoJELSic+t+oim9SHcP/34p7tBNhBHMzDkkLFrKr64S
juTqT0DK2BNwPPEYyALbqahQl6rHn+nXS1sT5Q+0kUtgtWacjQ2ck2j0srQNFlTb
a5naq93FmBZ4oETuNk+C3VhuEB1Pyb+y5Eg15STRq7HbdEYQOGZkot8peqmj88Tz
SUBc29xHYb8U+hBzNZjxiLffdJp23ciHBVpt+nvOO4/h9//vdMHw/ZRZMGCO+KY1
dAL8jMIWtxka8kJedd5fnmd+vUj1CxbgxR06Dsm6mTcTyCD8XXap7bS5+/ug2Yni
JKnknZvl2v01S7rrUQVISdghx7Sev/PF1+0Zv0iGs23oh+VhFRn8pZa3ENTJ0R6Q
KSK8939enaoBzGNCsG0etbFNQ3CpClkddqE7qDrxCyQt2ltA6KAnYsQEnCXa3cFq
q1MSTmD3eKLSlHNd8ThIlpAeDm1VqSzlljp6ZGRMI6ztNVQTKFYTtJ3cSOHHotZA
ze8+NwO75DLz5H3dbI3/zOPry0kRmT3DPkgFbK1dorpj12FBWSs0FLjdkId/MkUc
ffybI9iPKoNdXDY+Vm9mYJczcs6qt6lXE9y6rd9tKHWxUv+HWlpeFlaK1lRRD3q5
RvqoHDmdqmFOYcYAvrLSlANKoADymqaz13Hcx9DbvQGffkYFX8GvCFoWbyle+7Ae
zzxEaCRVV/BmOh0nw3it
=SpWM
-----END PGP SIGNATURE-----

--tphTSO44SEA4WSDH--

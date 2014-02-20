Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752953AbaBTLZj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 06:25:39 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:47251 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752355AbaBTLZi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 06:25:38 -0500
Date: Thu, 20 Feb 2014 20:25:30 +0900
From: Mark Brown <broonie@kernel.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org, lgirdwood@gmail.com
Message-ID: <20140220112530.GB2669@sirena.org.uk>
References: <1392886403-10640-1-git-send-email-sachin.kamat@linaro.org>
 <1392886403-10640-9-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5FUAC2IlSu3YzB0h"
Content-Disposition: inline
In-Reply-To: <1392886403-10640-9-git-send-email-sachin.kamat@linaro.org>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 106.188.156.234
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 09/23] regulator: max8997: Remove redundant error message
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--5FUAC2IlSu3YzB0h
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Feb 20, 2014 at 02:23:09PM +0530, Sachin Kamat wrote:
> kzalloc prints its own OOM message upon failure.

Applied, thanks.

--5FUAC2IlSu3YzB0h
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTBeYnAAoJELSic+t+oim9OyoP/1y8TLqxuwF89atZcODE68sz
Zs0elB65rKX6U9hK5ka4EkJybjU0zcIpLVgifvAvsfFHOqgLP8hX3JoesBovkvMB
Shq5oEaxqtckwtRAbnB/R5kUHnmBdAEDkAaKia4HiZtPev61mp76sI/khOr4sFvq
DLnYJK2xmVPQZG0XFVCJijMyriiFRJ699RammzbcNPer2s8V1S095iVwzjuyCQ54
M75alAjhXQA3R8qtGhzv158lmwl9JNUoNydKMNj3dMn+1fMW93R9D+lxDK3Ytk2A
D3SvkVBG3KVhuGxbNgSxPSS9RLvNlG99yDAsLlVfcSh4Rxaq+alaYmtgrV0atgvO
GL6CVorwPppU9W11C4OI11OO5XGa+MjCRO/tQGQ1lrdsR3W7saCcz3lGbx8bRpYt
PwS5FKWVqzjGPV+HHDrXBytM/h5eWBN3pxpcK52HWDy+b7lA17x1Jp3ryeGxBX0B
vZZzn58WGZFyymHAw7tCR+Ro5PnKcnFDaxadXBVOeV5WzbhDfrnIaAHT1l36gGo5
hfPoDgVkzktoV1e3yDaG/6ZNzjY/NdOSFJSmeyLRNuhsaFicIeEGZjeZjlyWtsRD
ZAtZ3AydrEhxFaROesvBX5i8kLUKKgMAF+kz24rw+1s7bj5wfzGI9ta5k+goKRJ/
804bUvfT+AqqeT8WSshv
=U7dQ
-----END PGP SIGNATURE-----

--5FUAC2IlSu3YzB0h--

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756234Ab3AMXEo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2013 18:04:44 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:34853 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755460Ab3AMXEn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2013 18:04:43 -0500
Date: Mon, 14 Jan 2013 08:04:37 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Andrey Smirnov <andrew.smirnov@gmail.com>
Cc: andrey.smirnov@convergeddevices.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] [regmap] [RESEND] Add provisions to have
 user-defined read operation
Message-ID: <20130113230436.GH5041@opensource.wolfsonmicro.com>
References: <1358024054-9895-1-git-send-email-andrew.smirnov@gmail.com>
 <1358024054-9895-2-git-send-email-andrew.smirnov@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TKYYegg/GYAC5JIZ"
Content-Disposition: inline
In-Reply-To: <1358024054-9895-2-git-send-email-andrew.smirnov@gmail.com>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--TKYYegg/GYAC5JIZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Jan 12, 2013 at 12:54:12PM -0800, Andrey Smirnov wrote:

> This commit is a preparatory commit to provide "no-bus" configuration
> option for regmap API. It adds necessary plumbing needed to have the
> ability to provide user define register read function.

Applied, thanks.

--TKYYegg/GYAC5JIZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQ8z19AAoJELSic+t+oim9uIsP/jSoUGVIEs9zuHgKK1hHXPY5
CrhoQBKR6j4kNIHd5oqC+wTnBM9Iy7J8ju3RuPxFgdf/LFXCooJ2+mpmfT1yPqEx
AsVp4AgQXHT1uexcDJI1vsx+YhJEK23Fa6v5Md/GV54QCMwGLyQO42uNU4RcUnat
2rlWQe0rRFRcqDh+lpf7691P05pK+aMUOKmHTyVDIrunTjIBuzYKJZ2p4jRlnSUR
4st50F1MC7dx7zr3cVFlBiLEdaRjrKhkHHYPz1NFYPYmKVpHlaU2LivSemdj7eUX
zPTJYcJZn7oFzlkREsmfsFp55Ixf/hlLsPtV1nqnK5Dn3h1SC9xQJbKieH43A9lH
1rdrpnQFUrr9BRq6eVJjtKG0NvWXNcwbqhU1YAoZxcPI3+EcIYcWYwWIBPCY8JMV
QFUwIpAX+QzhF8/GJpbwITMXpBgn3SECekMdrzBOjGp1uA9vH+Og0Hs3RtqPfXIK
szSel8+tRDvcytMvhfLW5mU7VCCLByCvGbAoKyawU8WFX129ldnanfIFSkwY5z2y
qdJqQWmJ2c9cE2k4bWIbWQG35SJ7v/WwwSs63vy1ytYwwvzPAKTKIspqAIAZUkVg
lPqCtMqWQmq+UVwwi3RCFl1PkMTiKOeEGsgsqfpJPDrEmWvC9JABK/yOvcfLhaTL
tM2Fokc/+7giOivh0atg
=JLag
-----END PGP SIGNATURE-----

--TKYYegg/GYAC5JIZ--

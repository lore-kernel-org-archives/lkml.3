Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755511AbaLVR7V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 12:59:21 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:44235 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755071AbaLVR7U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 12:59:20 -0500
Date: Mon, 22 Dec 2014 17:58:45 +0000
From: Mark Brown <broonie@kernel.org>
To: weiyj_lk@163.com
Cc: Liam Girdwood <lgirdwood@gmail.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, Vinod Koul <vinod.koul@intel.com>,
        Mengdong Lin <mengdong.lin@intel.com>,
        kbuild test robot <fengguang.wu@intel.com>,
        "Subhransu S. Prusty" <subhransu.s.prusty@intel.com>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Message-ID: <20141222175845.GG17800@sirena.org.uk>
References: <1418087444-14504-1-git-send-email-weiyj_lk@163.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="J1ldk4ymECC/Y9sn"
Content-Disposition: inline
In-Reply-To: <1418087444-14504-1-git-send-email-weiyj_lk@163.com>
X-Cookie: You have no real enemies.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 31.51.36.65
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH -next] ASoC: Intel: fix sparse non static symbol warnings
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--J1ldk4ymECC/Y9sn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 09, 2014 at 09:10:44AM +0800, weiyj_lk@163.com wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>=20
> Fixes the following sparse warnings:

Applied, thanks.

--J1ldk4ymECC/Y9sn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUmFvUAAoJECTWi3JdVIfQpXIH/j6+9PzKVeLaNFdoD7Mmj9sK
2FsWIyoVMcbzkHA+kJug/kjDYNhWsSGEeShRn7SGBqwHd0lrXonBiAgHaXWkUbYH
zT0fuEDPUtAhFJO51yZMeLXQuq/gJ2ubDjha8nId2Dlg+YlPjnHYuvrhnteNGvwo
U59T22HAUlkefPoh+b7J9KAoYmSYXtCjG9KNAadfMVRzFOQT+lelq7DtEMdirHqn
YrLvVoKMMyBONLRUG2UU7pQ3XQF/cx29CZPWLQvB6ZwGPTA8s1jC1F78a8IOU3VS
iRteBXyaIqmY7y5kjamNkFHSQ7oK70716a0pUCNnDHb2xBENokQ1DXYhqpaxjz0=
=rwWj
-----END PGP SIGNATURE-----

--J1ldk4ymECC/Y9sn--

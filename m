Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932358AbaFBORU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 10:17:20 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:50966 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932334AbaFBORS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 10:17:18 -0400
Date: Mon, 2 Jun 2014 15:12:32 +0100
From: Mark Brown <broonie@kernel.org>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'Liam Girdwood'" <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        "'Haojian Zhuang'" <haojian.zhuang@gmail.com>
Message-ID: <20140602141232.GG31751@sirena.org.uk>
References: <000101cf7e2b$b5c9f9c0$215ded40$%han@samsung.com>
 <000201cf7e2c$129996b0$37ccc410$%han@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="z9ECzHErBrwFF8sy"
Content-Disposition: inline
In-Reply-To: <000201cf7e2c$129996b0$37ccc410$%han@samsung.com>
X-Cookie: Big book, big bore.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 92.40.249.170
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/3] regulator: max8649: remove unnecessary OOM messages
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--z9ECzHErBrwFF8sy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 02, 2014 at 03:29:57PM +0900, Jingoo Han wrote:
> The site-specific OOM messages are unnecessary, because they
> duplicate the MM subsystem generic OOM message.

Applied, thanks.

--z9ECzHErBrwFF8sy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTjIZMAAoJELSic+t+oim9cHAP/A9WX93f77rUisorQrHlKFI6
tYLU6xcNDU6Op3kp07Tjy0L/KFZg8oKICvWPhCgrY/rKuWj88m6TjVNPLoKpEXbJ
qLPt/Wo66h6gDRJT1gGnQlLOyX3wn5skIigvZJ+a5O1rHnEndLVpa6mpAER/8Zt7
ZH87CQBhBoUWfYhL6IYCyGP+i3KHF5tsXUuY9yLpXx1IksblRVXetQt5GrlsSpV/
BIxAv0Bu3UiYqV6tgpYLS5TUGfI12PeiO/W8jhLwnWlQDHdf0POXb1EiEB1lONZO
65iQs2/G1cDNYIQGaEkQsLXe2wU1M0PjtksfWWkhrurhKU0lVXtI4VCJhC0TbAwX
VAQ9PENrN08m/+F2iilI13/8TMRPZ88fWdim7fTjY0rLPGPzmaQu5I/2hGAgcq65
f5dLwEX0/k7ZXP1dsMBv3zMXoboKTRy6sBMGZWzAd3YeFIWv5ybtc2fTu98pbNkG
fkkpu0ugYVAkN/d+aq8JcQ/cOuGPZ6HNHzyGRynuxnfRNe3fWO1wTxWNXPUfvUzr
6XhN/9f21SWLmnzXeTPeS7oyQwZdk9hKgJtrbZ7WsOfpzoYC+LMcll+8Ez4Wjn2W
UKrG82oQF4QkIb7hPbbC/OEGDaXnkKjj5rZPt4iMjTVivXbk3IbpOegogiXYinIk
rcJvsVPai9VQ/Q76R0zE
=rGJO
-----END PGP SIGNATURE-----

--z9ECzHErBrwFF8sy--

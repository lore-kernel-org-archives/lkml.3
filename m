Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755271AbaBTJOl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 04:14:41 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:46974 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754028AbaBTJOf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 04:14:35 -0500
Date: Thu, 20 Feb 2014 18:12:57 +0900
From: Mark Brown <broonie@kernel.org>
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: myungjoo.ham@samsung.com, cw00.choi@samsung.com, dmitry.torokhov@gmail.com,
        lgirdwood@gmail.com, lars@metafoo.de, peter.ujfalusi@ti.com,
        jarkko.nikula@bitmer.com, eric.y.miao@gmail.com,
        haojian.zhuang@gmail.com, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com, alsa-devel@alsa-project.org,
        linux@arm.linux.org.uk
Message-ID: <20140220091257.GB2669@sirena.org.uk>
References: <1392736948-26623-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
 <1392736948-26623-2-git-send-email-ckeepax@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="M3d18yTenwKOqJX4"
Content-Disposition: inline
In-Reply-To: <1392736948-26623-2-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 106.188.156.234
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 01/17 v2] Input - arizona-haptics: Fix double lock of
 dapm_mutex
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--M3d18yTenwKOqJX4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Feb 18, 2014 at 03:22:12PM +0000, Charles Keepax wrote:
> snd_soc_dapm_sync takes the dapm_mutex internally, but we currently take
> it externally as well. This patch fixes this.

Applied, thanks.

--M3d18yTenwKOqJX4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTBccVAAoJELSic+t+oim96ukQAJz0JktANPHTKHZuTakeIbiP
bpHQ43gTHHA0LSSF/uxbTd12EVHOJVdPITeXLiCg+O99A0fKC2cBW5DgKHRQ7KB/
cNK5AG4xAqORuRzj5tUVkmffdvTLd8qDznXq5EjhT97MQe0u1SB8WcRgGReos/w1
LKpGgYRgHBE/ZmVaZIEZjHCfvrFKJeS+kPB7tKElrdah351ptcSJWYoeCLKAF+gi
TiUd+nO7ZOS3W1uv45qjfwvUM/V+swQqntsGTel9/mJcTLDQSjqyRKALoaC+sxNF
cbbRTrKd/2YnZyetwzTpztBOOUicZbN6USuRnA8Ti9YV0dcfBVgmSu8I3QLuqJEN
EIDeFfUk7Hdvc8v2uvlDDa8t/R0QwHY977Kwos/7u3W8SaDJ1SHLMzl4QNdt3Qua
x0BhxMHOk1gUKPEymlf06NeNdKZ9zAUHH5fydOCTXzHWNwhqkG7nsGax4RDcTRHB
dvB5GddWYWwkwsRuKdW2HZeA04udO2JIE/4QFDG0LOpitLkpWhtz86GRhhzi8RE4
sy6TV322/teX0yjqaR2i53YUKZMufsayNzxG8ykWdSwdHy+bJQaxVlWyyqb5iGOD
8kQF5DP3JG4hjs/D1WXNomr9b0uEZqO6d/ZeL4fqoh6w8ncpCWmwzEI1gbEkmyYk
+OaVo6XDClrBDvpPp9Jq
=R1zC
-----END PGP SIGNATURE-----

--M3d18yTenwKOqJX4--

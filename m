Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759460Ab3BYPY0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 10:24:26 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:56601 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757034Ab3BYPYZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 10:24:25 -0500
Date: Mon, 25 Feb 2013 15:24:22 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Subject: Re: [PATCH 1/2 v2] regmap: debugfs: Simplify calculation of
 `c->max_reg'
Message-ID: <20130225152422.GB28907@opensource.wolfsonmicro.com>
References: <1361362523-8120-1-git-send-email-dp@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gatW/ieO32f1wygP"
Content-Disposition: inline
In-Reply-To: <1361362523-8120-1-git-send-email-dp@opensource.wolfsonmicro.com>
X-Cookie: Give him an evasive answer.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--gatW/ieO32f1wygP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Feb 20, 2013 at 12:15:22PM +0000, Dimitris Papastamos wrote:
> We don't need to use any of the file position information
> to calculate the base and max register of each block.  Just
> use the counter directly.

Applied both, thanks.

--gatW/ieO32f1wygP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRK4IfAAoJELSic+t+oim9tCwQAJByMpnXLWQVb+WYRjOYQLfk
hu7Rxl8qOzf5Gx5/I8mS48nr49I1eTJaD9gEDCexiQ69oGG8cWSm/0eHgUOb4xiw
SkP46IY6c0YCIjrdnNCPd1/vnNlh7GNH0ddZXs7MdDtXKQrIZU+6wT/EI9xQsfei
3wMPO3tHVpK8jlNQitskycCWs4WxMzvR7INz9ux81B2d//M/MlwsMAj8M6+T2nYM
huP/fjjFNdqkzTsv35+doxjU2zpFuNzsaT+KfsQW6JNsWYGuwJw7YUgNiQMp69UU
Sb+vTmoy4uHDUZ9XptSQykIPU8A7A5PJTXTfRZ/jC6yxTd0uhwEr7aWKWcbBpLoD
/bsM1QPmHNRvWelUw7UBQP6wH5Fc196607DDEKV1S5622WuWv0qY0YSOsCiPTHUi
CMxRChuO754BdoOkpzY26rg1mBrbjV+GlhkWe8B+jjffYQFJhWTt9FbeBU2wcySw
Ii3sWp2dyqAQm1k9DWPS9b61QymWxDHbdv1z7+/IFaEUjjn4596ItpKOm/doq/dr
yLSJN14AMccN0Vj+AjDGwaffghdN2gXNm+c+zTfP3zHBCplaLxxxQCmZkYyhtK01
UdY7IpLMbLS34b9o0gvY1wYEgNiivQl6rA+klB1/x7pMO4luilui4ddKBvFOSeKY
4qP4i4orlJCp4AbMLMfo
=7Ooc
-----END PGP SIGNATURE-----

--gatW/ieO32f1wygP--

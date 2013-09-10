Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751380Ab3IJKbI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 06:31:08 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:52395 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026Ab3IJKbG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 06:31:06 -0400
Date: Tue, 10 Sep 2013 11:30:43 +0100
From: Mark Brown <broonie@kernel.org>
To: ZHAO Gang <gamerh2o@gmail.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Message-ID: <20130910103043.GA29403@sirena.org.uk>
References: <CAAb+SYY9EBzVj+16dmhsOvzJLQd1hJeVh==kxA+vs=SovjCeow@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9Cifn/h8XkfDE4v2"
Content-Disposition: inline
In-Reply-To: <CAAb+SYY9EBzVj+16dmhsOvzJLQd1hJeVh==kxA+vs=SovjCeow@mail.gmail.com>
X-Cookie: Your present plans will be successful.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH]: regulator: fix scripts/kernel-doc error in header file
 <linux/regulator/driver.h>
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--9Cifn/h8XkfDE4v2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Sep 10, 2013 at 01:54:01PM +0800, ZHAO Gang wrote:
> When running ` scripts/kernel-doc include/linux/regulator/driver.h
> >/dev/null`, I get following error and warning:

Applied, thanks.

--9Cifn/h8XkfDE4v2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSLvTQAAoJELSic+t+oim9+yIP/3FmbcxVylRYLQKncWho/u04
GiQ42hzN9CnzFKiyQ8eRJ7KhiPbC6ANztQ3WkWsWJD9QIZpS6CU+dA7nO7DEu6ta
PsOK8CUEvpuP6nHskiKw8ZeUFTHhg3+dEd9yw5Gn6d3WEnjlh/GYbrVMr+SPR/Mp
kvWtVqNr/spL4yrjn/jg0TJeWDMySJ/uIFi7ystuTZ+/TbOoFUGXObU2kylGquP8
RaYXaD5i8iiX1bIWUHR4XyDSj7a9WfmUn05SawGOhQQxaNie+9L0cwIdB/rYXYSL
vdPQjKzKaLBbz66CWi0u/YpwDaOaBRE4Sa009nuy40yeW2RfP5MiELvA3ezYe/zb
MCGlaIZe/wwDYtreBG3DV0AJmPUbkKGjyIuZgNwgRUzsZi45U9H+nF26/3PDTz+y
+SvdDiIhQ1QX7CPH9IA2GSryK1WH5oS64dd0YMjts9E8ziUfRYoiWHLI24r2wdqp
peC/Hh8bV22rYMKWv2ozA++CT0thq4YI1w09XFOaA1YpY+c0kDPfn/Qp82qn4rOG
UsMR9BHHcbrbZfwnuljKtvlaoegzJZbK71fn90O0hLvORDMoPxbxX//GVv+BOaVI
ul1TfNtliG9t6JpYnw6e9SxEsQrJdrETdqDO18WEtp84cevVk3vLAQ+G+wNmPxFA
hitKQEy2gZs4Ww/afL80
=/f5e
-----END PGP SIGNATURE-----

--9Cifn/h8XkfDE4v2--

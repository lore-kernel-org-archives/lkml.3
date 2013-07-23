Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932506Ab3GWPCA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 11:02:00 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:60504 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932873Ab3GWPB5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 11:01:57 -0400
Date: Tue, 23 Jul 2013 16:01:50 +0100
From: Mark Brown <broonie@kernel.org>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Jean-Francois Moine <moinejf@free.fr>, alsa-devel@alsa-project.org,
        Takashi Iwai <tiwai@suse.de>, linux-kernel@vger.kernel.org,
        Liam Girdwood <lgirdwood@gmail.com>,
        Rob Herring <rob.herring@calxeda.com>,
        devicetree-discuss@vger.kernel.org,
        Russell King <rmk+kernel@arm.linux.org.uk>
Message-ID: <20130723150150.GH9858@sirena.org.uk>
References: <20130723104615.3696f1a9@armhf>
 <20130723123444.GW9858@sirena.org.uk>
 <51EE7E1A.3040301@gmail.com>
 <20130723132016.GC9858@sirena.org.uk>
 <51EE8591.7060005@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lvzXnIqIiPbDUI27"
Content-Disposition: inline
In-Reply-To: <51EE8591.7060005@gmail.com>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [alsa-devel] [PATCH v3] ARM: kirkwood: extend the kirkwood i2s
 driver for DT usage
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--lvzXnIqIiPbDUI27
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 23, 2013 at 03:30:57PM +0200, Sebastian Hesselbarth wrote:
> On 07/23/13 15:20, Mark Brown wrote:

> >Why would this be required?  The driver is already asking for multiple
> >clocks...

> The driver is asking for multiple *DT based* clocks. Legacy
> platform_data has never been updated to reflect that. Mainly because
> multiple clocks are only supported on Dove, which has no active non-DT
> board in mainline.

Why would platform data have anything to do with this?  To repeat again
the way the clocks are mapped should be totally transparent to the
driver requesting them, if it isn't then the driver is not using the API
properly.

--lvzXnIqIiPbDUI27
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR7prbAAoJELSic+t+oim94yEQAI8Lxb6zeff+wXWxZsZuHv+Y
Y7U0ls8+Gx4xPE2DwvyPCj49v3rJIJBhZc916VfM3TbTjqDJiZedCkff7rm2Df8T
WoKoLbZuagN5MVWy/6VS2tKNKtGzCEfg5eekpR7LZ4n74/Hua9r083w4ztohSnjn
paUN+d8385eVdXVkd/HS6M0NRFAssk9Fq4e5H1pznQjBEFyQDSYLBSjjVbO1yJiw
2hTjx+3Oe0FTB7pjULQX9e/X47bqFBDpBLfoIwgxMTerRxyTxsIv1E3aotHKRg0Y
E/nDe5fIY915t8Sjro6E8PNJ7QWMGTC02W9L0o1d7PgDaISdyBBlLlcGj+u/T+x3
/N5aa/mlat1tv9ffR6Lt9JFYZQZ2u9cqQfuDELZynU5uJnn5HtEZuHJoZCmdJEMl
lVvJUAZxvZrWKWqxNnoHJ4AIVCHjt8jbHPwHvIGtmki/RuPsNOMw8iJQXuzczzcd
weOewZ3Mb56jzYJ2qgZb4fllg9qhJiDvhFpBtFCnNhhb0jCD0qoswzgPTUtoX6yz
9eRfP96OmT1lPtyi+xeZbj+xzNL2gEDSsGExXPBNOk3zIhZqdwVsneFizxGkKeUj
RY8vN8gi4OF6FWElLxHs6G6uN+epw+T55JhFHmco5vEmeTQVnxMlcCOFTtFkD+tC
YGK8Q0Q2+H+WxRdRvhJb
=0T+r
-----END PGP SIGNATURE-----

--lvzXnIqIiPbDUI27--

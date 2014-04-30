Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752843AbaEABSd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 21:18:33 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:53371 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752577AbaEABSb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 21:18:31 -0400
Date: Wed, 30 Apr 2014 11:25:00 -0700
From: Mark Brown <broonie@kernel.org>
To: Richard Cochran <richardcochran@gmail.com>
Cc: Xiubo Li <Li.Xiubo@freescale.com>, mark.rutland@arm.com,
        gregkh@linuxfoundation.org, mpa@pengutronix.de,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-ID: <20140430182500.GD3245@sirena.org.uk>
References: <1398833029-29546-1-git-send-email-Li.Xiubo@freescale.com>
 <20140430071011.GA7312@netboy>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="fOHHtNG4YXGJ0yqR"
Content-Disposition: inline
In-Reply-To: <20140430071011.GA7312@netboy>
X-Cookie: Keep it short for pithy sake.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 12.104.145.3
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCHv3 0/2] add DT endianness binding support
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--fOHHtNG4YXGJ0yqR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Apr 30, 2014 at 09:10:12AM +0200, Richard Cochran wrote:
> Shouldn't this go to the arm list and rmk for review, too?

Is there any particular reason for including rmk?  It's generally not
helpful to spam people with serieses without reason, we all get quite a
lot of mail already...

--fOHHtNG4YXGJ0yqR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTYT/4AAoJELSic+t+oim90z4P/2gWqw9tczkPtuJjqyITcAv0
1tecGCnsG15Iq3U/9E5IeyC01t3/NZMlpdpVoUJl+NvUKyczMmwHqP/fZv+nbLzd
PpW7ojIKUhNr0cbdVhGfFbALiEnsyH15F97MYsA5Vgufo0MO2z/m9WRgZt/HgtB4
J8Gawswg7ql0keAby2wflww1saTkDdihXYi9caOLO25JlToHkqkN7n5icGU4KSkw
52ZvZ6HwmzT1HPbQDoQKH6+ifmaubdRSBDPL24EPLWWe6Ut9X8XT2TKrZuQ6n3qJ
n0YduezEXRQLaf8IukGXoXwwcL6ryEIQsW21DzHTetbPwwrwhJPPLr9ADj2/Lj6u
zq9H4z59OfuPDOjGsnmuQ2RmjmpbiC3vJ5nqCERS44/J3cSZx8fA4GWwZNyZN7GK
agicuSDd3uA9dGFlTENEPgQDIT5qfw8w7+yQmYWyLVzx/7qnJTYwaBW7IdTSGCcz
dy7q/JnuElgI+SfvxkaM6OIwPIU15vOUzd+C6Aakxc2Uz2ETHnznaVHmkpIJLuSQ
v/0flOjeEf51JX2viG/ZnozPLSESr8/8MjQ/SlE5dKnJ8Qd0V/wSXr1P09+195PB
6MYn2f3vIW+G2+u7ezuEZn8i3GTsAR6v4OPmvei73pahwd160r2rEcCB9TaNEdyG
QZwUDRZjfMTBgwE/qUIU
=Q5VZ
-----END PGP SIGNATURE-----

--fOHHtNG4YXGJ0yqR--

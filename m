Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755920AbaAHJE4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 04:04:56 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:59409 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755170AbaAHJEx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 04:04:53 -0500
Message-ID: <52CD148D.7060107@ti.com>
Date: Wed, 8 Jan 2014 11:04:13 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: =?UTF-8?B?TG90aGFyIFdhw59tYW5u?= <LW@KARO-electronics.de>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-fbdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Shawn Guo <shawn.guo@linaro.org>
Subject: Re: [PATCH 0/2] video: mxsfb: fix broken videomode selection
References: <1389014278-4903-1-git-send-email-LW@KARO-electronics.de>
In-Reply-To: <1389014278-4903-1-git-send-email-LW@KARO-electronics.de>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="GMq3TqRcUMdQXMwxcJqh5L0lPUnf2JAHD"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--GMq3TqRcUMdQXMwxcJqh5L0lPUnf2JAHD
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 2014-01-06 15:17, Lothar Wa=C3=9Fmann wrote:
> The first patch in this set converts some messages that are printed
> in case of errors to be error messages rather than debug messages.
>=20
> The second patch fixes a bug in the video selection code that
> incorrectly OR's together the 'pixelclk-active' and 'de-active'
> flags from all possible video modes specified in DT into one flag.
>=20
> The current code does not allow selecting one specific mode from a
> list of video modes, but always uses the last one of the video modes
> listed in the DT.
>=20
>=20
> Since all current dts files only have one entry in their
> 'display-timings' node, this bug was not apparent and the fix does not
> change the driver's behaviour for the current users.
>=20
>  b/drivers/video/mxsfb.c |    6 +--
>  drivers/video/mxsfb.c   |  120 +++++++++++++++++++++++++++++----------=
-------------------------------
>  2 files changed, 53 insertions(+), 73 deletions(-)
>=20

Thanks, queued for 3.14.

Your diffstat above looks a bit funny. Where did that "b/" come from?

 Tomi



--GMq3TqRcUMdQXMwxcJqh5L0lPUnf2JAHD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJSzRSNAAoJEPo9qoy8lh71ti0P/Rrj7HkaiwvhlokkLcSL5k1S
Xk5uwQHZNXWousKFOM8JQwlspYVCbaKXW6aBTOu60kBxcmqFvcCgCERSDqnOJoBT
8oQf3tRinL9knd7D/2E3etnc1rCrJFu2MVVPyaKMX4a7/qYyG1q3ZmxDIbtn6whD
lfV6qRaaHMkkUvHaf9GFS5sjdlV6JrPkpUkpsmbaNq6tnaglnrAZchBnX6vbDhor
in9zUfzbBNLhqVEs1JP11W0XHUytuTItLlueMxlLxt7WzsN2shTyy3S1NfNpcJuD
LTOHQcgiS0v4yl3Hzci1r6UMP9qt+4iK1jxmDug4mPbEWP3M0d667wbt0u5EKs8/
oD1KLvogy6H37d/+gkcRnlyXN64R2XXF9I6ywjj4tsUxnOqaWhspN/YgTSgffD50
Jj0+ewHm3wO+b1BLbf0HxML/xTRRs3RFeRtiWfLNBoGdoE172TN1XVx7jHMarHEh
7BcCZV8rfBXX+JXptJ1kGgDN5qJ+yHWCfdj8Soaie+w/vxGLqnwLCZs/rgm9yH6h
95dXWv0xneDjlLULF0zApE5XULOXTgXlaunscrMQ2YPtX1YQVuWh+3o5EmwI0VgV
g1X6rSQq1syz6I8TWTzuDQSRRc0acOj0xkqxDx6Y/QqNpiKLgxagErh/BrxgHiLI
3kBkWPsYA2Hdyq59PFD1
=s1co
-----END PGP SIGNATURE-----

--GMq3TqRcUMdQXMwxcJqh5L0lPUnf2JAHD--

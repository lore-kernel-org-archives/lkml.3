Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932547Ab3GPNON (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 09:14:13 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:48076 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932308Ab3GPNOM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 09:14:12 -0400
Date: Tue, 16 Jul 2013 14:13:32 +0100
From: Mark Brown <broonie@kernel.org>
To: Jonas Jensen <jonas.jensen@gmail.com>
Cc: rtc-linux@googlegroups.com, a.zummo@towertech.it,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arm@kernel.org, arnd@arndb.de
Message-ID: <20130716131332.GL22506@sirena.org.uk>
References: <1373550711-18828-1-git-send-email-jonas.jensen@gmail.com>
 <1373978485-17496-1-git-send-email-jonas.jensen@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OGLMwEELQbPC02lM"
Content-Disposition: inline
In-Reply-To: <1373978485-17496-1-git-send-email-jonas.jensen@gmail.com>
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v3] rtc: Add MOXA ART RTC driver
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--OGLMwEELQbPC02lM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 16, 2013 at 02:41:25PM +0200, Jonas Jensen wrote:

>     1. don't use hardcoded GPIO numbers, use of_get_named_gpio

Since you're now using OF you should also be including a binding
document.

--OGLMwEELQbPC02lM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR5Ub5AAoJELSic+t+oim9+V8P/18ePGelt/l1Grih+4Wlh9Sz
tJSl5D8j5a59fFShOY2gJOv+UPvCS6Tc3tHMXQYaJFS/piqsOysAYVd6d/y1ywGN
yGe19q8e/NEu8tbeWqUfN1mj1QMVb/s86jE/CVjqTTx88gEZ9uwGjLszSt/jL9Pv
3mgyTLmdnmy4Lpn7nlyhUcy8ASIwHA3ok1VB0WTmraTMBI9jPlAJVNki6BNt+FY+
4ZJnYCHeCU0iNXXKxRmh/WVHoOM4ZURLIlRNP8SuIxNMqJakK6TxKHcySpfHwCrv
bNPnbpwC+nYzRemdBzzxMO3/ZJNqqUc0OqRWfk8Wfm70rFlshbuzEODJ8QlEnX1f
j7ee9tu3m+A2PMDpYCcaG7DS/NzXxhv+rm/8L023s2zNBVMDSbyfJG4ruvEb4PFu
DRZbTTo31plh5WowKrUy32GWh8yBYNraGzjpoR6uXazt66vGqP48wA/2v0eqiMdl
eUbQsJIW5SoH4Ty8m/hqvRSoLvR3fywwqutSdat/d+XlCiF5+s6HQd5L23IQmiX/
+s+VYziJ3BI1391KwGI4nSTCTVlFvEZeAy9kNNkeIlgO0T23LawWT3I8ymlHHjrx
Q0qpisBgkvPtAuZ0o3LJgH2oT+u70OO/YzrTWh15DUYCa3KUhI/foKVIMH5mZlDo
oAozSzDf4xLASA4wangf
=Ytta
-----END PGP SIGNATURE-----

--OGLMwEELQbPC02lM--

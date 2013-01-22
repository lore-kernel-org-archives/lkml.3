Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753845Ab3AVH4J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 02:56:09 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:50634 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752273Ab3AVH4H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 02:56:07 -0500
Date: Tue, 22 Jan 2013 08:55:52 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Wolfram Sang <w.sang@pengutronix.de>,
        Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org
Subject: Re: [PATCH 33/33] ASoC: Convert to devm_ioremap_resource()
Message-ID: <20130122075552.GA28158@avionic-0098.adnet.avionic-design.de>
References: <1358762966-20791-1-git-send-email-thierry.reding@avionic-design.de>
 <1358762966-20791-34-git-send-email-thierry.reding@avionic-design.de>
 <20130122074824.GE1766@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BOKacYhQ+x31HxR3"
Content-Disposition: inline
In-Reply-To: <20130122074824.GE1766@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:N6O8bp/pq3ORQCCeoaZvQqFWbmK/Stji91JW5kMh/m6
 N1cMQW+CfceOk9ELGPs/wBM5BlmeA/uGpHPUDHxBRYdb+4xM72
 mKlwJ71eESMmhdPY7rEfdmiY6jtzQYkzdxiYyCxHtXaMe+BO6J
 jdLwxWHN4fnJstuGl++fOBp1afhJITlMhTj6p1hlSxqGdAFWOO
 Hno5gW8GZUk88VumdTn2XtXbuziAKs7UBvRTebOlE8Z05JLHTf
 ECNUGxAC2ICKKsKiMkZqS7KVwLaQ7sk85V/6T8Pea9lJZNuOYq
 L0YHNRHCmO/oPYik5YrfZElsZpxNWkrTNJN752MW2AcTKL2D82
 je66hQMHbztI9rNJX+9qkUPpy09p1DbyxDuNBt0zn49aPgXC4m
 wZ4h1ql46NXE8jiEMEqgaFmVE7TqtP9O4pofwdSeqg1GsUjIT0
 6APq1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--BOKacYhQ+x31HxR3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 22, 2013 at 04:48:26PM +0900, Mark Brown wrote:
> On Mon, Jan 21, 2013 at 11:09:26AM +0100, Thierry Reding wrote:
> > Convert all uses of devm_request_and_ioremap() to the newly introduced
> > devm_ioremap_resource() which provides more consistent error handling.
>=20
> Applied, thanks.

It's probably too early to apply this yet since the first patch in the
series, which introduces the new function, hasn't been merged yet. I
seem to have handled this poorly, as David Miller already pointed out,
by not Cc'ing everyone involved on the first patch.

Thierry

--BOKacYhQ+x31HxR3
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQ/kYIAAoJEN0jrNd/PrOh2NMP/33LhnrtqB9mDGZrCLSbTcF1
f5O9xdMID/b7K9wUurFFxUTq0uAJEvPWzjMsnxrs9zx3+zAcKDp8YiziLK05Hie0
M2sfuOf/HtJoNm+OyWiuqWGJQT7hYICHDX/zrHYFHLyGI1Hj8MuD9LApBviZ5PLH
8wwjCZm7etR1oIhCBQv9Rh7V5GPLvBjL1YD1vjU5Mh1Sbn3J1Rs2Qak7wJR9DL2S
O/nS6J/XNDoXetudyHUV4pJ23l6j7LyX2JSG/qklnxlSrj0GmgPTwGdhihmXTSHk
eFgovE+FTr7x6PevHfw/3GFEfdhLoabPi8HZpTPZESKiRmNt0QhOLJss9cvzHNp6
ujcvHCL+6JfXeqQiv27XQZrg5PAOIB9h089KBK9jUEzMAXaYSIp5Ii/GKKNNGLYa
yoY/1SnzB9wkzb7K8QTuD1HhuR7BdSi6Jigbhg0TpnM/vF5GHTfJJwYlyLNRSOje
gzFPECIeIkzP4QND/anfDTKobzdqo4AcmMrIZc44bxR7WFMJ9xByoI183eBkBwBm
mxLbLE1ydTRR+Hudrb13+wOTZuJ/F3SqjguCrI4u9U57ecju3l4DZNMhi3wa+KYu
VWjOysIBKPitcXER9PdYKVHJ/y2SBu4EX6NAK/VLbKiVzsuAwDdeBkoV5XN4MZCx
JKCioRENtF+pEHqJnMgx
=/0o6
-----END PGP SIGNATURE-----

--BOKacYhQ+x31HxR3--

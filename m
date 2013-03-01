Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751685Ab3CAGGD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 01:06:03 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:41219 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750879Ab3CAGGC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 01:06:02 -0500
Date: Fri, 1 Mar 2013 06:05:16 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Liam Girdwood <lrg@ti.com>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Regulator: db8500-prcmu - remove incorrect __exit markup
Message-ID: <20130301060510.GA25302@opensource.wolfsonmicro.com>
References: <20130225032624.GA10547@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="17pEHd4RhPHOinZp"
Content-Disposition: inline
In-Reply-To: <20130225032624.GA10547@core.coreip.homeip.net>
X-Cookie: Condense soup, not books!
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--17pEHd4RhPHOinZp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Feb 24, 2013 at 07:26:25PM -0800, Dmitry Torokhov wrote:
> Even if bus is not hot-pluggable, the devices can be unbound from the
> driver via sysfs, so we should not be using __exit annotations on
> remove() methods. The only exception is drivers registered with
> platform_driver_probe() which specifically disables sysfs bind/unbind
> attributes.

Applied, thanks.  Should've been __devexit up until that getting
removed.

--17pEHd4RhPHOinZp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRMEUJAAoJELSic+t+oim9Ml4QAJcHee1gFSvsboY+EnwqHAkz
8Whp1d9/1Tili0M7pwNgTWWQfAFWgFHd713W4bt4uQyzmgDGEwaEmT7fDzSFvI0s
xs9Fl5vm+ukV7l6XDJ51VFoVUfeaLTYSpADN0wqMP8DcFP1c6yOZQA699wDVbRjI
CjT4AvpvXE7wFw8vKb4gnFNv7QlUTx5uXGxrDX1Y+AYJLm3paecFKjFJn1zndJmi
rAcsALQ5z/R4ZTnjciWOu/JyyMNnE8bfgaaZPUVr3/gxfP6xgGtXsFqaQgVoZ3Jb
EuvLTb6vgmQaQHMpgRgYsKpDKw1w+EdEPQMoIMw0UsGl3q4upshpqogLty2GpB6H
JnEKzMEeruIH8gLPCPNHBVLAbqReRcIPjmNLTbBiXf5RLasoKmvdO5wBWi9cknJp
hFOechkZjHeiVVyHReeSpW4APuBEnsJX9FJv7+qdXOrDJxynklk8zforeixfAoBc
gYWthIcnj2pZw9+KQF77qqkog/8yreRf/b5OMkicF8uymstQFKyPR0+eRQw2XVPc
C6rfD3nKnftbfnEibAel41h8euxAqPzqysQ73ZsS1VkMMIAVjjxAQ/VcmycUPd7U
IOA7dAchZkhhEVXhyxluiP0c9+DucKmL1UzhDLAlrgMOhKZC4GarsVt4uP7Yhq0C
pTMJOJyZXbJeMO5bq0u8
=kIi5
-----END PGP SIGNATURE-----

--17pEHd4RhPHOinZp--

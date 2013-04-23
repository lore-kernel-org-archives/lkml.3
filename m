Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754696Ab3DWNvK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 09:51:10 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45371 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754385Ab3DWNvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 09:51:08 -0400
Date: Tue, 23 Apr 2013 14:51:07 +0100
From: Mark Brown <broonie@kernel.org>
To: Michal Bachraty <michal.bachraty@streamunlimited.com>
Cc: perex@perex.cz, tiwai@suse.de, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, lgirdwood@gmail.com,
        marek.belisko@streamunlimited.com
Subject: Re: [PATCH 1/2] ALSA: ASoC davinci-pcm, davinci-mcasp Clean up
 active_serializers
Message-ID: <20130423135106.GN5019@opensource.wolfsonmicro.com>
References: <1366378083-14325-1-git-send-email-michal.bachraty@streamunlimited.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="i6vqABX3nJKXLk01"
Content-Disposition: inline
In-Reply-To: <1366378083-14325-1-git-send-email-michal.bachraty@streamunlimited.com>
X-Cookie: Caution: Keep out of reach of children.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--i6vqABX3nJKXLk01
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Apr 19, 2013 at 03:28:03PM +0200, Michal Bachraty wrote:
> As pointed of by Vaibhav, commit message: "ASoC: davinci-mcasp: Add support for multichannel playback"
> number of active serializers can be hidden into fifo_level variable, which is set in davimci-mcasp.

Applied, thanks.  Please bear in mind Daniel's comments.

--i6vqABX3nJKXLk01
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRdpG9AAoJELSic+t+oim9sxAQAIVSOmbDkAOK5V7SO5bP97M8
6fwI6oLzbdWIzhqhy19PLeqzcFRPGYKzvMw9HAt3SG4TGAQMsnZVGNikpFSq7m+N
SE6DcM2nVOwN6lnI7RhsKar31uoNrtXM/kPunM/fYZgQJLp6HiIT2jZt1zkkU8je
57azmP3iAFSS2fkd8Hup9l2jp2RQTiFAyYsFtEDDlRi3wRopjYhZVPL+VHhXQt45
vlVwd/I6OiW6k34pNrYJIsI90QvsAqarHbanqHzLq2N9/b0PUy8rvp8funUvUu10
h9mnItR0YmYse6SWVeXFZlO4TzKsoJIXFOHG4/Ewqh91cUYxYJdZzJaoH4voO78p
BIGlt7UMCaktHRtnid7nz0DJLwRmQljtHGWo+ksCgtkXCqvCERaRweCw9XE4aFjY
fxadLRWq6Usfz1HPgR0I80h9eaz1G37YgRkU5d6NG7c9jMSL0exEaYLVn3tNv1Qs
iVcQT4ftQvCqfJ519H/o2xKjb+iq+q37Q6b+UAffQfIuInQFZjVptPql2qouuc3S
DWhTg2fOnlZl2e7XGc7n+EIQCI0sa2ioYwC2isqfyOeolOjay1+vkyXAHYk/mFI+
6cQpURz2n6bWexQRuZlsFaZxOSyDpMDLm26yTcWEUXoS+fetPoXkoF335Kj8TwN4
aNS12LthbvMvarJ5viC8
=UziZ
-----END PGP SIGNATURE-----

--i6vqABX3nJKXLk01--

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756907AbaF3SxA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 14:53:00 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:38871 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754162AbaF3Sw6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 14:52:58 -0400
Date: Mon, 30 Jun 2014 19:52:52 +0100
From: Mark Brown <broonie@kernel.org>
To: Tushar Behera <tushar.b@samsung.com>
Cc: linux-samsung-soc@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        dianders@chromium.org, kgene.kim@samsung.com, tiwai@suse.de,
        lgirdwood@gmail.com, galak@codeaurora.org,
        ijc+devicetree@hellion.org.uk, mark.rutland@arm.com,
        pawel.moll@arm.com, robh+dt@kernel.org, trblinux@gmail.com
Message-ID: <20140630185252.GG23300@sirena.org.uk>
References: <1403251396-17487-1-git-send-email-tushar.b@samsung.com>
 <1403251396-17487-2-git-send-email-tushar.b@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="inZzG0lmAPZRgTxV"
Content-Disposition: inline
In-Reply-To: <1403251396-17487-2-git-send-email-tushar.b@samsung.com>
X-Cookie: But it does move!
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/2] ASoC: samsung: Extend snow driver to support MAX98091
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--inZzG0lmAPZRgTxV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jun 20, 2014 at 01:33:16PM +0530, Tushar Behera wrote:
> Peach-pi board has MAX98091 CODEC. Extend snow machine driver to support
> this board.

Applied, thanks.

--inZzG0lmAPZRgTxV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTsbIAAAoJELSic+t+oim9Fj0P/Rao00pWI49oDpseouX3gUTk
haORX6B/NuaaK9RM1IJefDKC+iijsIi1awzDZBt0dj2MuNTXvIPvqyfpBcEb//Uo
NAmQL8gE4SncWdW/ZsXwgsZLuF6CeT3rHMUBcwjuZynVCpJit3UjnbT+H9+cXXjv
nGVzxTFRTZH5z2KRXxr7xfnOBlralYywb7zfv/brNcdydCNtzb4LABxzLJ+iu3yu
FU3e0Iu63m1pO7ovZJpYSjfqq3AWyxxgHpf9G7QvhGwyBIX5OFFW76sowZ96ydSW
tMTOCvsBC2xPLGGGcqa3PnNc7VZL3wrAD6YJUlxd5QI4cFfUHCQ4RrN9mdrwzmfQ
hIZmB9Bx8wHQ0mSxuplfjmFnukJcmvZPSe4YiRruhhZhRnfVUSHop8tiHw62ioyx
yXZ/NbP/P92wlxRfTC6QHO7sKVHcDAdVUB2UKxU6GZOAobzGw0LXUu+dW2ZDOI3E
iXNpjDICZtXV44mZEsCWcG5A7uojYfQTiuJBGUiJssUm/rv05W65U/ApLE5OymT+
Sj3UpaCkLwEY/RHKCTq1Qyow0qQmswxH3HcoDWpZj6ZzzGh+MqdyLDiqzSUKa7+j
itzD9nm8tir4V9nh1W/7TLg3lEL7hDbn2oI3C7X2nPJE2RcYXxrkEDg+Y6VJWtVJ
2X0wFqzKSkbubCo6KHqe
=XO3h
-----END PGP SIGNATURE-----

--inZzG0lmAPZRgTxV--

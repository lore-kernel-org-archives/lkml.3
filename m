Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755870AbaAFSKQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 13:10:16 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:48035 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755838AbaAFSKO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 13:10:14 -0500
Date: Mon, 6 Jan 2014 18:09:58 +0000
From: Mark Brown <broonie@kernel.org>
To: Andrew Bresticker <abrestic@chromium.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>, linux-kernel@vger.kernel.org,
        Vince Hsu <vinceh@nvidia.com>
Message-ID: <20140106180958.GR31886@sirena.org.uk>
References: <1388094527-7585-1-git-send-email-abrestic@chromium.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/wUBB1VsywAzobeC"
Content-Disposition: inline
In-Reply-To: <1388094527-7585-1-git-send-email-abrestic@chromium.org>
X-Cookie: Go climb a gravity well!
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/2] regulator: as3722: detect SD0 low-voltage mode
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/wUBB1VsywAzobeC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Dec 26, 2013 at 01:48:46PM -0800, Andrew Bresticker wrote:
> SD0 may operate in low-voltage mode, with a minimum of 0.41V
> and a maximum of 1.5V.  This is indicated by bit 4 of FUSE7.

Applied both, thanks.

--/wUBB1VsywAzobeC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSyvFzAAoJELSic+t+oim9TewP/3Afpm5cwpf4p7pCX9wt1ks9
IDd19TktBze3ZqZ+8RBE6xCcEyfyT5IEK7FVcGzQWsl1LlgcIBlT7h6F6UVf3T1g
wCa0BH3GbVuyLYD777hOSs61MwwuY3Wawjrq2BuYSgaeGJ0TIBmNJsOF5lbwMyvL
8q2phBD5zCZx2qdyO3wNLXbGUxzWqN2aridOsyacWQq5RghXT7dpevbf9ZFOcK8M
2V8Qr5+y63R3uhxtcKVrJzVuy6+lByikCQbA814kuEy0WFC4YipsT6xkGdIjkk7n
TNaXyAIB/S/wfM4tat6vtjXHi0aMRt9oX59LNYuz9+B8mI5SjmNFmm5oqeyO1ezg
JvuQ5Y/+7Gp5CcKHnkYz7uq6wlTOGjg7gfkMxqp/wys5K631nlJjrmGZQU4tKafy
Cfi+I8v8bI9iWoFyttcgOB8AHJm828XVhqBaF96NqRcZRdRXQDxz6KVYLtDc3wdr
W2T173PPdjFH9UgiI1hrq3+C9ISdsuQW2lPELO+8vtoggMwP+KknPAQ6X66knPRU
lfJqv+hLf1w5QHhWNN0UbXk3xtibM6D5ds/ddaRHiS77PB8gVwDBXsuZ/om/+8ni
33BYnaXuLEBoN/QaXeNyLer00f/s8XsWL4Drs+4oqLEkin7kTRpbNfJGQYg5MXJi
ZCkAOQXkaXUjTmpExnKW
=o9xp
-----END PGP SIGNATURE-----

--/wUBB1VsywAzobeC--

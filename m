Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752226AbaFVLEU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2014 07:04:20 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:53424 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751737AbaFVLET (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2014 07:04:19 -0400
Date: Sun, 22 Jun 2014 12:04:00 +0100
From: Mark Brown <broonie@kernel.org>
To: Shahina Shaik <shahina.s@samsung.com>
Cc: perex@perex.cz, tiwai@suse.de, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, lgirdwood@gmail.com,
        sharab.shaik@gmail.com, shahina.s@gmail.com
Message-ID: <20140622110400.GS24291@sirena.org.uk>
References: <1402638528-5787-1-git-send-email-shahina.s@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FYef6pHvFBuPZp1D"
Content-Disposition: inline
In-Reply-To: <1402638528-5787-1-git-send-email-shahina.s@samsung.com>
X-Cookie: This is NOT a repeat.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/2] SOUND: TLV320AIC32x4: Fixed Coding style Issues
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--FYef6pHvFBuPZp1D
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 13, 2014 at 11:18:47AM +0530, Shahina Shaik wrote:
> From: Shahina Shaik <sharab.shaik@gmail.com>
>=20
> Fixed a brace coding style issue in the tlv320aic32x4.c

Applied, thanks.  Please try to use changelogs matching the normal style
for the subsystem.

--FYef6pHvFBuPZp1D
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTprgdAAoJELSic+t+oim9HmYQAJlVs9dk9kUoox/0MrL6Ujlr
3e2HSWqUTrML0P1pbBGc/izYZk5qPYNS3eYKbVIFlyGLZ9oZHJGhWvRPna6nywjR
LTZ7nzXeWrxREey4Yi0opQtFyXQwB2OlIk3wS9cK5PcxkrUZ7XY0sxz3h63ogKcM
9+1uGhKmu5ZEykHasougi5CJIZYiMJtnThf5I+lbdNah7Oq2xcSBJ9+cch6FIPxj
hLGzWnuyzhFFtysoWbzv22I3UHfgV+UxhELSlX++KknRai4UCHONGjvly86iHvq0
xIO/4aL5vBFEvcIgwWqgrSuDaiXWx+IwclhkBFSf73EeVGCU8tR/EsnxEC4bnSXO
R12z8NHh2tLGOH4xriYs4ve8Qlppc96kAOra9DU6wdKctDF7aAquWcd6G0cekaQQ
FVvnsd8OtQcUiysWvd2axL1HnZI84xP3f17kaHqPIwhC+b5CS0c3NAtWwkZKjDJa
AfMvbQDyLLAyJeTISt1qlQaVvOKPrFTWLUZ/0el6pS8MI9iR21Ln6XUNLlZuQD+j
d4UUudR9Dd/dgnMIpc/mfjlVJTFtQW08cHPxeWNO37pYtmYLxDLxcbu/ZQz6PpNi
RIstyiBFeZiZD+dTZq4XcV0M9YE2yl30afrLOmhiQKvtDmmKnRrLOV9Zya00YYq6
bLbA0IT86zI75GRtfvlO
=LE0L
-----END PGP SIGNATURE-----

--FYef6pHvFBuPZp1D--

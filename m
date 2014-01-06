Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754817AbaAFMmh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 07:42:37 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:47748 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751320AbaAFMmg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 07:42:36 -0500
Date: Mon, 6 Jan 2014 12:42:25 +0000
From: Mark Brown <broonie@kernel.org>
To: David Howells <dhowells@redhat.com>
Cc: akpm@linux-foundation.org, Laxman Dewangan <ldewangan@nvidia.com>,
        linux-kernel@vger.kernel.org
Message-ID: <20140106124225.GQ31886@sirena.org.uk>
References: <20140103160755.8153.81654.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="y4KCttt5BRl02Fhp"
Content-Disposition: inline
In-Reply-To: <20140103160755.8153.81654.stgit@warthog.procyon.org.uk>
X-Cookie: Go climb a gravity well!
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 5/7] Fix up a pointer-integer size mismatch warning in
 tps62360_probe()
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--y4KCttt5BRl02Fhp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 03, 2014 at 04:07:55PM +0000, David Howells wrote:
> Fix up the following pointer-integer size mismatch warning in tps62360_pr=
obe():
>=20
> 	drivers/regulator/tps62360-regulator.c: In function 'tps62360_probe':

Applied, but please follow the patch submission process in
SubmittingPatches - you need to CC things to maintainers and use subject
lines appropriate to the subsystem.  Things that don't go to people's
inboxes are likely to be missed, as are things that don't look relevant
=66rom a scan of the subject line.

--y4KCttt5BRl02Fhp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSyqSuAAoJELSic+t+oim9F24P/Ru6gSrhJG1ZUtmwgmlL8FTk
v8FQNtsJp0tzEQcDGqJiszZwhzvpn+9AnYs221mBTuKj7fQeBFjCg1dn1f/AQIAN
xv/j3jyZHHll8mxm5c4If0pJrfYQ0h3lOfIPWhdthU3nmJ6DIDTfEv4pcgxVsOtT
S8K2notTqFmd28x5Y78Mbvspz3dLnwiV0nzDP9o0BdpjjBEk/ALopaL0YYMmv8mZ
M7XfWxvpdSVTDFeH+7WXBQNJZdwNeHruLaALbIArImiKpJiCGwr3WJGbotFhKXvD
ORoIpslM+leZaGv6pxtnnQosYaQp08UNphQ89UY6IvqZDp42utg7iswtTmQAz4bt
uFc+SqvkIyzkO7M7UAc8oHMrDsZwt7V22swd/FHZdTojwsq3U5MrURjA13JS5vzT
ldRDqlhUhxDqDnj+H8mSVdSwvtj6uxe+Pxs/pxvDf2FV1s5zKhL2fwBbobREi28X
FuaTXYJcLJffj3ujgcZG0lyn0XMgZKm4CdmMbPc0UYPGuO89mcPLInNaSYUSDjiU
qjiAlwWj2vS2J74ajXI7N0o4vmQuaCBjsJY2u6Nnt3UJtFGjkBUnjYJSUiBxOlrH
8lRWDiQ6SKWel4QYySeG/D4REaEe/p/MzEkKDToMhPZ3tjh0DrOZOeOXTwq9c5rQ
tWIy1HoXXEkd5WZqeyf+
=2jeF
-----END PGP SIGNATURE-----

--y4KCttt5BRl02Fhp--

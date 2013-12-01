Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751545Ab3LAKYd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Dec 2013 05:24:33 -0500
Received: from ring0.de ([91.143.88.219]:39224 "EHLO smtp.ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751227Ab3LAKYc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Dec 2013 05:24:32 -0500
X-Spam-Report: * -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	* -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
	*  0.0 URIBL_BLOCKED ADMINISTRATOR NOTICE: The query to URIBL was blocked.
	*       See http://wiki.apache.org/spamassassin/DnsBlocklists#dnsbl-block
	*      for more information.
	*      [URIs: elinux.org]
	* -0.0 NO_RECEIVED Informational: message has no Received headers
Date: Sun, 1 Dec 2013 11:24:25 +0100
From: Sebastian Reichel <sre@ring0.de>
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Cc: Pavel Machek <pavel@ucw.cz>, kernel list <linux-kernel@vger.kernel.org>
Subject: Re: device-tree based boot on linux-n900 branch
Message-ID: <20131201102422.GA7403@earth.universe>
Mail-Followup-To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
	Pavel Machek <pavel@ucw.cz>,
	kernel list <linux-kernel@vger.kernel.org>
References: <20131127125149.GA9389@amd.pavel.ucw.cz>
 <20131130172938.GA5194@amd.pavel.ucw.cz>
 <20131130231532.GA6688@amd.pavel.ucw.cz>
 <201312011050.18256@pali>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="OXfL5xGRrasGEqWY"
Content-Disposition: inline
In-Reply-To: <201312011050.18256@pali>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--OXfL5xGRrasGEqWY
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Dec 01, 2013 at 10:50:18AM +0100, Pali Roh=E1r wrote:
> No, this my tree has rx51_defconfig which is used for classic=20
> booting with board files.
>=20
> Sebastian, can you create new rx51_defconfig or at least patch=20
> which enable DT booting? Also some steps how to compile DT kernel=20
> will be usefull (maybe on http://elinux.org/N900).

http://elinux.org/N900#DT_Kernel_Compilation

-- Sebastian

--OXfL5xGRrasGEqWY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBCAAGBQJSmw5WAAoJENju1/PIO/qaNTMP/1YNlLeJpY16Tg2HPabXrsGQ
9TevlOvzjtll7dt4tthoYlj4x4vy+d78Wh4rXXGshlFzHQ+nmr9V5VnDqfD+2M9P
LcjK6ijWIRz2M/4BUd4e/rEi8NRO734pm7ie65WKPUBS3ixApIBaitRovr/mB+J/
UzLgae+opejZwN2s7UWu/CEldtChI33wdNci8UaW52JWKMISyMuxEaKle8ff6NUM
9InIkj4VhEqas9NO+3Ahmevnxk6nFxzq8DvYsFQoHUOfvm4o+sKb+fs7Np/m53DV
E1PwdlaLiTaQvc/LjXvoW/Mwjxp9mCtRELtgjEKQmRrGGI9lrS3IAxH7JQVq75Wi
V0a/cN3G8HcAPg6dsxXQqDPgVoirkbzxMkrtgPQmjBaK2l5sacr6baFwe5zOm2hA
8usxrNcuvYGrtG43V24JdszaZTNic0gTLF1vv+J9mlxx2FAKV0nTByeDIa+24R/4
lZ8glQ0sdcZy8A+9tFuWfEoXU5/Zgdn2g1FO8HF+PksIV5Q7pIAvuI9XH5CDi1Qz
CA4t7/Gl58RLIIFKvP+K5QudV0abU5ol/8se5gWUSw1IgM8OKiROUu++8WOAw9H6
N8Gnrf4LE/rWZBlwiCizjKjnAGq414scnKlkIXiQBm0UfbBZy6EgzG+a+XFvGn4z
gMLo2k6eLdgvWtFRTrHJ
=vawN
-----END PGP SIGNATURE-----

--OXfL5xGRrasGEqWY--

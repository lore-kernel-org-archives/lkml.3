Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753427AbaIJXKJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 19:10:09 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:57944 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751541AbaIJXKG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 19:10:06 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, viresh kumar <viresh.kumar@linaro.org>,
        Magnus Damm <damm+renesas@opensource.se>,
        Simon Horman <horms+renesas@verge.net.au>
Subject: Re: linux-next: manual merge of the pm tree with the arm-soc tree
Date: Thu, 11 Sep 2014 01:29:29 +0200
Message-ID: <24748175.vQ81Vho3N1@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140910141850.34c07f72@canb.auug.org.au>
References: <20140910141850.34c07f72@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart2936667.Qb1nb5oQlB"; micalg="pgp-sha256"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nextPart2936667.Qb1nb5oQlB
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

On Wednesday, September 10, 2014 02:18:50 PM Stephen Rothwell wrote:
> Hi Rafael,
>=20
> Today's linux-next merge of the pm tree got a conflict in
> arch/arm/mach-shmobile/setup-sh73a0.c between commit aa0bdc303b0f
> ("ARM: shmobile: sh73a0: Remove duplicate CPUFreq bits") from the
> arm-soc tree and commit 978027e170fb ("cpufreq: cpu0: rename driver a=
nd
> internals to 'cpufreq_dt'") from the pm tree.
>=20
> I fixed it up (the former removed the lines that were updated by the
> latter) and can carry the fix as necessary (no action is required).

Thanks!

=2D-=20
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
--nextPart2936667.Qb1nb5oQlB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAABCAAGBQJUEN7fAAoJEILEb/54YlRxTVYQAKrmbVrzV342dd9rj/y8ZUVj
/htZs/7kI0c/qcciat93NANMEYPDvwH3UtSG0D61aaH59L3fTzUvHivzHMB3hcE6
gQsWl6ZbwyFvoYd5hiLOkTL6hX1XtbXTc58Y1/mOiASP3APoYRIjKqaLAd+c89qC
3sQkxSTAlc6MoDVA4oo3g4E3uUt7I65rSLngQ94NKPR3JC2IBuKJ19BHNBSoFVZX
/WVYjEBUFDBojfP81LpyKZzqgkWpHXsL7Zvp5+5z5k7d9nqXqy4pkqXUmq+nnk+m
H1evCvWMg1ibDlonE5k9fAhQ9kO2R7d83tdtlhtKJvMlcK0l/oViC0KTKPFMAs3u
OfIxoHGCn3kSBdzLEAdqyr45NeZi5ThyBNRdA/6vCu4nGFqDSTPjVnIKyBLnRQkJ
6vQIW7kxkQSBqxxdcwzFB2lI8shTcP5LOHoZhOhivbYkKiZFnrVV5wzxAxJVtWL9
nU3upk4CdQC30d9/fsC5PsaoMMx4xYklFXkgzHAIjdLpz9OyleUkiWTHE/dpOMar
meLD1ka5G3Duem6oSNRuenJlkNYoPkxRrfMHBj/njT618QYPduVsztslsIaSXTCI
ruVO1X1/keAt64r2SBBGzWoAOZ7a8/bUHQ3VxBqG2L6PjuiXxpCS7k+FifkXpgU2
NU93KqzPDpx4u//d3BW9
=zgCa
-----END PGP SIGNATURE-----

--nextPart2936667.Qb1nb5oQlB--


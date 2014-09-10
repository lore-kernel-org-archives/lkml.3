Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752081AbaIJETA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 00:19:00 -0400
Received: from ozlabs.org ([103.22.144.67]:47019 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751715AbaIJES6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 00:18:58 -0400
Date: Wed, 10 Sep 2014 14:18:50 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        viresh kumar <viresh.kumar@linaro.org>,
        Magnus Damm <damm+renesas@opensource.se>,
        Simon Horman <horms+renesas@verge.net.au>
Subject: linux-next: manual merge of the pm tree with the arm-soc tree
Message-ID: <20140910141850.34c07f72@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/p5sUDb/LzwXpdD0HIT2XWTN"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/p5sUDb/LzwXpdD0HIT2XWTN
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Rafael,

Today's linux-next merge of the pm tree got a conflict in
arch/arm/mach-shmobile/setup-sh73a0.c between commit aa0bdc303b0f
("ARM: shmobile: sh73a0: Remove duplicate CPUFreq bits") from the
arm-soc tree and commit 978027e170fb ("cpufreq: cpu0: rename driver and
internals to 'cpufreq_dt'") from the pm tree.

I fixed it up (the former removed the lines that were updated by the
latter) and can carry the fix as necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/p5sUDb/LzwXpdD0HIT2XWTN
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUD9EvAAoJEMDTa8Ir7ZwVqGgP/RThxcD3MHNFfMsDNoYBs9fU
fgTsa1+XG30/HT7rJRfIJ7qlLG80mgXutbjd85nf8UV832HCkkmdeVjuGSDxUg0W
EB2M5DDKX4UwIwpFlzO3SkzwPiZAOvN0WY5zyGSGutyVBFMKpzvkT+Up71maeLJW
BnJl1Gg3AbqDcUlu6Z6gWxyBUpBnmV9tHHkaEAey9nu5tI/qw+9vctPfVLlXQkjX
siq3+Aovfr/PJwzXQOmQsdpRnzqq6p3Gm1uFKwXZNg9tjCQXuiZbRiu6Wrs6GFsF
hMJplQGneRTvd5uydl5Jgho2YIeYvY7idMU6Hbg9iLI+En1UTEwEy23IfBUl2xOV
wP1G7JlebDmBaSNDonbh0WFClrmDBoJqcm7mSxIaEbIV3eV6OVz2TzXBhqP3TX53
8eomVBE8Cem7DE3o+6EzlExAsvuI5mqxv72Nd8pu7f4+FQ9Oc17qoO3r8STpNalL
9mQC9nlpuBw9Pnw/bQnZir3QbvBduBj1w8izCAKlDGlW9RTz5Q23wqvTK/x/jmQ8
pfPf/6PRF12Z5bDDzW8D8ZmFx/kxyMNBjBT63T2jolNvYnZqYuEEGK3ZsM0x73LJ
DTWaav390aHveTFXqAM7olOXZqEL8QUdBWmE5kVkZJlHVt6sKawC3V3CveIGuoj2
WpcT2dzg6MZdjf77nCT3
=k/JF
-----END PGP SIGNATURE-----

--Sig_/p5sUDb/LzwXpdD0HIT2XWTN--

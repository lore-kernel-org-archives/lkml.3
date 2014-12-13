Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933253AbaLMEKg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 23:10:36 -0500
Received: from ozlabs.org ([103.22.144.67]:60640 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933210AbaLMEKe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 23:10:34 -0500
Date: Sat, 13 Dec 2014 15:10:26 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Paul Bolle <pebolle@tiscali.nl>,
        Valentin Rothberg <valentinrothberg@gmail.com>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andy Lutomirski <luto@amacapital.net>,
        Josh Triplett <josh@joshtriplett.org>
Subject: Re: linux-next: Tree for Dec 12
Message-ID: <20141213151026.79a75a8f@canb.auug.org.au>
In-Reply-To: <20141212145623.dc2394c57c2254b2603456e4@linux-foundation.org>
References: <20141212183518.06e3803d@canb.auug.org.au>
	<1418377757.5756.24.camel@x220>
	<20141212210449.7f460bb1@canb.auug.org.au>
	<1418380316.5756.37.camel@x220>
	<20141212135719.4c79bac46d43bfd8d7c8e6a6@linux-foundation.org>
	<1418423797.5756.54.camel@x220>
	<20141212145623.dc2394c57c2254b2603456e4@linux-foundation.org>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/5mds9I==dpRLAn3wVw4zIGd"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/5mds9I==dpRLAn3wVw4zIGd
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

On Fri, 12 Dec 2014 14:56:23 -0800 Andrew Morton <akpm@linux-foundation.org=
> wrote:
>
> How'd that happen?=20
> http://ozlabs.org/~akpm/mmots/broken-out/init-remove-config_init_fallback=
.patch
> removes all mention of CONFIG_INIT_FALLBACK?

Well, the patch now in Linus's tree adds the INIT_FALLBACK bit to the
Kconfig file, but in your patchset, the bit is added and then removed.
So when git comes to merge the two results, it looks like the
apm-current branch in linux-next does not change that file at all, so
git just uses the version from Linus' tree.  I missed it among all the
other conflicts I had to fix up last evening.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/5mds9I==dpRLAn3wVw4zIGd
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUi7w3AAoJEMDTa8Ir7ZwV7PoP/AvNK1smmvLRpLuFIoYBiSih
zDE3o3FZNFZF46NA3fmFE5gHk5gL0Q6pvf9WLpIyG6mR/1BqmWPei2ZN0ws7sEAw
IO438/MO6WZKC4RJAgMrlTjyUDlh1USYgid38kd5LszYHtMrVNqobFRneVa1u7SD
80WSWqy20N6DRC/TzZfDJjZPWg9ySfYp6y6tvr9j87iiqZr5a2gZrJkTRiHjSm2u
cerGMj+xUWBHqFgfJZx8XqXgy/+F/IgPnfiU+zBVsd1p4zooOWEyPgB2f6ZjhszD
BXh86qPhmaOXMwxlfRlnnrKAu4RXjOFw8sjVLd0xVWqRD3VW8O8FJf0C4hVUIf/a
bBSVorCXlXLnPY0YBa8MFBP8LUdFaGi7YGCwiGvobMY/Ewt9LZIkGZa4TnL2N59Q
OwaL0sX/wPkPuc39GX4CwtKoMU8pm9pc1Hixejxo0e049UyEvjpGLAO6KWHbNCV6
7QiEVfZNWt0tVKXRiRoQZobT/oa4KemMcTKFsxwjv1RRSYESG+Rve1zakDALZT0a
ggJb55R+UnHcqUD1tfjws6Cp+cMhH8Ko03qQdtakH0lblpoVeEBGbM4AvjkcHUGR
2CTr+dxz/oYJko/GUXgevbjZEoeY08gTRs7poYzVGZyBnVOyr1n66n0P18AlVobZ
FDleKo0bIRNb1Anf8/Tm
=sI3g
-----END PGP SIGNATURE-----

--Sig_/5mds9I==dpRLAn3wVw4zIGd--

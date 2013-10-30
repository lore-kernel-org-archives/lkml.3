Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753574Ab3J3XUY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 19:20:24 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:53011 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752247Ab3J3XUX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 19:20:23 -0400
Date: Thu, 31 Oct 2013 10:20:12 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Samuel Thibault <samuel.thibault@ens-lyon.org>
Cc: Randy Dunlap <rdunlap@infradead.org>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-next@vger.kernel.org
Subject: Re: [PATCH] Fix build without CONFIG_INPUT_LEDS [Was: mmotm
 2013-10-29-16-22 uploaded (input)]
Message-Id: <20131031102012.599a7a256c48feed7832a208@canb.auug.org.au>
In-Reply-To: <20131030114624.GY5442@type.youpi.perso.aquilenet.fr>
References: <20131029232351.D2E6F31C173@corp2gmr1-1.hot.corp.google.com>
	<52706790.9090602@infradead.org>
	<20131030114624.GY5442@type.youpi.perso.aquilenet.fr>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__31_Oct_2013_10_20_12_+1100_peaaPe.XZcK0NR0X"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__31_Oct_2013_10_20_12_+1100_peaaPe.XZcK0NR0X
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

On Wed, 30 Oct 2013 12:46:24 +0100 Samuel Thibault <samuel.thibault@ens-lyo=
n.org> wrote:
>
> Randy Dunlap, le Tue 29 Oct 2013 18:57:36 -0700, a =C3=A9crit :
> > arc_ps2.c:(.text+0x500): multiple definition of `input_led_connect'
>=20
> D'oh.  I indeed hadn't tested the inlines, sorry about this.
>=20
> Andrew, could you add the following patch on top of
> input-route-kbd-leds-through-the-generic-leds-layer.patch
> or perhaps rather fold into it?
>=20
> Samuel
>=20
>=20
>=20
> Really mark inlines as static inlines, so they are not defined multiple
> times.
>=20
> Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>

I have added that as a fix patch for the akpm-current tree for today.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__31_Oct_2013_10_20_12_+1100_peaaPe.XZcK0NR0X
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJScZQxAAoJEMDTa8Ir7ZwVt48P/iiClTn5eHvJ3qlKEIXxaGZN
docO0HT6qR7GCElApqimwXNrnzr96Mu9hLvqBDaEMIPOM74YF8Rijx6x7dkTRisx
2n8d2vrNwCtJcAZVlO7RZNOz7kMoPWJCMts1w5w54YDS4lctM68kpVBuGpeJj8yf
DTXOVfet7TjdkaL1E99ay4JR/Yn2n5zviNcL6cZmITR8PTJkegqOYRDYyQUAmIDG
6h6M+Sb0HvrufAFzCHAMbIO56jMbojW9lKM16K2MwSIXofKFyJ+ksv6cfqWMPGAW
ijf3NlkDDiuueQ2/BlZ9ChclxFphFHyy1Kcss98lczAd7NNu3k+lDZ/VV0/29cmn
RdSFK0JfaIY9PNgzbakPkIIzz/kKctFNghWrftCF1HlT7x+BQK9E7uqPoYcE9uzM
vS+pP2savbCYxt+p6akOYF5LkHOrQvca+nihD58ujhLuiQkP2CWxLqI3pBk69MPk
KK8nyPCK6H3rkk0zhH8H5vsj1mSTyo40QbVtDMykCPqC7ZYTKZzqpbn/GX0WbOIg
E8gyjarVI3JFDb4RMFtAqBVKZOSsdX1hEuHiAgJThOpcUvqCw/A3E2cbA4JsV8L5
0OdO0X3hK2IL9TYDnASI/h7wpNRYdniw3vbljMOnI9pLqpeKT0dJ6dWXJiFjm01Q
xaQzpRq5hutwIebekZOm
=pZuB
-----END PGP SIGNATURE-----

--Signature=_Thu__31_Oct_2013_10_20_12_+1100_peaaPe.XZcK0NR0X--

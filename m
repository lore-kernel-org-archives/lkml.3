Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755877Ab3ALBKA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 20:10:00 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:39973 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754845Ab3ALBJ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 20:09:59 -0500
Date: Sat, 12 Jan 2013 12:09:57 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: James Hogan <james.hogan@imgtec.com>
Cc: <linux-kernel@vger.kernel.org>, <linux-arch@vger.kernel.org>,
        "Alexander Viro" <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH v3 00/44] Meta Linux Kernel Port
Message-Id: <20130112120957.36df3412c9d6cca089a0340a@canb.auug.org.au>
In-Reply-To: <50F0296E.2000704@imgtec.com>
References: <1357831872-29451-1-git-send-email-james.hogan@imgtec.com>
	<20130111103442.b80ddbfb11ef322ed28ca3b3@canb.auug.org.au>
	<50EFD824.3010502@imgtec.com>
	<20130112000336.1f24c42237fab4fe0c305ff6@canb.auug.org.au>
	<50F0296E.2000704@imgtec.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Sat__12_Jan_2013_12_09_57_+1100_POYultyISUFo+wkQ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sat__12_Jan_2013_12_09_57_+1100_POYultyISUFo+wkQ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi James,

On Fri, 11 Jan 2013 15:02:06 +0000 James Hogan <james.hogan@imgtec.com> wro=
te:
>
> Okay, I've rebased the metag tree from linux-next onto the master branch
> of Al's signal tree (to get Vineet's GENERIC_SIGALTSTACK fix and
> GENERIC_SIGALTSTACK's eventual removal).

OK, but I hope you mentioned not rebasing to Al.

> git://github.com/jahogan/metag-linux.git
> branch: metag-core
> tag: metag-core-v3.1

When you think it is sufficiently ready (and I am guessing that it is
getting pretty close), please send me a request to add it to linux-next.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Sat__12_Jan_2013_12_09_57_+1100_POYultyISUFo+wkQ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQ8LflAAoJEECxmPOUX5FE3jEP/jRXJJcnTY7KXZm8grr0N17U
IME1m838orRa+zHtSt05KbWkGdULKaKfWq4R85ZHTKrmmE0yqbW94fkNL9Fri7c1
8nC8qeWdg54Kvjbl5l/mYbpjyXwYAcqLRp02el7iH9C5FYRTrxJNAeUG42l4eSpo
LDsp9sR/nvmk0/jUy2ksNNbS0U23OaQ4og0YGaFbLsg0fHS98acs/RPGPs+y/r47
RgeCVEAu47qjbLlQE4TzM7he8YKyhg93c9udeFsNwDj/HyCpIzkQB7Quyg4V58tQ
hJgVMTnL2vqUnzj+tVOLqAKr625MyzBnB9apROj1j9DSIrW1Ksn4gD8QfIkSQlPX
J1hZhmUURC61Oz2p0FNAn/qdMV/uhQkQfwi1ucDN+S6p2FUzohLQ2utadCT3U4T5
HVF36Fvb46/e0xM/ZcbqiCHF0/924MSRaAOgVAupcn3qV09yJXOPit+UgKX8kWmX
LdDwnu3CeHKPXuM0Fsj9MYrl2mcMRVcLHMubfWADHxA4cqtu5NoylCtIFajz8cva
aB3WKntzVt6UoQvOl+oA0YpuR1qn9JjqcSk87BI+B1VPF4RSMZ6vSLuMb5GyO8qs
nKXeaS9XdpWQJvo2S86WN1GwR7pwir7SAU6TF8uqVqVvVYdWyjr6/hdX+1CMCvqi
u7FqKfnm0oEImup24idn
=+H2d
-----END PGP SIGNATURE-----

--Signature=_Sat__12_Jan_2013_12_09_57_+1100_POYultyISUFo+wkQ--

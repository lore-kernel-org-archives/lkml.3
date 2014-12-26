Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751377AbaLZBqD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2014 20:46:03 -0500
Received: from ozlabs.org ([103.22.144.67]:50578 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750725AbaLZBp6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2014 20:45:58 -0500
Date: Fri, 26 Dec 2014 12:45:51 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: error while fetching the watchdog tree
Message-ID: <20141226124551.318187c0@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/xoh+i+OCUMUSy+sbWOVK.Ip"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/xoh+i+OCUMUSy+sbWOVK.Ip
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Wim,

Trying the fetch the watchdog tree
(git://www.linux-watchdog.org/linux-watchdog-next.git#master) today
produces this error:

fatal: unable to connect to www.linux-watchdog.org:
www.linux-watchdog.org[0: 83.149.101.17]: errno=3DConnection refused

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/xoh+i+OCUMUSy+sbWOVK.Ip
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUnL3UAAoJEMDTa8Ir7ZwVGu8P/RRqzbKd/abgGbtfWrprpgDY
mwxVcV7qqPjbrhNzJfS5JY2wyvFrxauPn1ss2muI5nwfTGapIsWdoygAiOHRQTlC
8M7rnCxY7ipms9H3TISV4ZspKmI6Ts/oiQcyHuTgst2VgQKOfoMXMACVgU7U5Y56
rWidchnXN3ychaVcMyEqTWKtqjmMQ7YKbgMAsh1qftzi9l8bwkYQ4YbSM6IA9QHG
4TvcI88nCmeUUhfE6WHfF/sprf+a1YFb1ZtDU4Lu1yrZsC7FzraDVxckth20xO1q
U4ra2U0+NOXyuwbYGV8WNivF4jETLgu2GLGHjFslBa0KZnpuSHkhT6SnBG+gx+yu
THxoFEHPQ1Inkhd0/6yiQQfRBZqn5RVHbUJlzptT0Bzw+3uxN8gpfcwAW7xkXQWV
EAIsqbWIxMXBaCywTmfC8101wSGC0V3akqiXvnPSavcTaY9KvOtenQ8wZ9rM2N9w
bOog7Lnk7S+nivAyG7vHkENW5q0o95tyCByTpvsZbSGhPGbeGhS9EEAYadtByn8R
bqhNVMb+X0YFOINy9k1jRUEwkIoMi6khFTPzTgsDYXwVPb4VLuFNRfHvQyfxB06j
pCRRYaDifvsm2j8wT4TVdhPsX+lD+SuQv5j5qaGi04sGkXlcjkLDfhwxbmOH6sls
lOb1wNaiY7/fgEAHaIxe
=Ik3i
-----END PGP SIGNATURE-----

--Sig_/xoh+i+OCUMUSy+sbWOVK.Ip--

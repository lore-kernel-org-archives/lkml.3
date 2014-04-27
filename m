Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754614AbaD0RZD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 13:25:03 -0400
Received: from mail04.raumopol.de ([89.238.82.176]:41037 "EHLO
	mail04.raumopol.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751966AbaD0RY6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 13:24:58 -0400
X-Greylist: delayed 704 seconds by postgrey-1.27 at vger.kernel.org; Sun, 27 Apr 2014 13:24:58 EDT
Message-ID: <535D3AA8.5030306@florian-kaiser.net>
Date: Sun, 27 Apr 2014 19:13:12 +0200
From: Florian Kaiser <fk@florian-kaiser.net>
User-Agent: Private
MIME-Version: 1.0
To: stable@vger.kernel.org
CC: linux-kernel@vger.kernel.org
Subject: Linux 3.10.y: backport b04c46190219a4f845e46a459e3102137b7f6cac
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="ajfKxDjdpMRJaj7b7lblwwBGt7qjoMp3f"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--ajfKxDjdpMRJaj7b7lblwwBGt7qjoMp3f
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hello,

Not sure if you did not include this for a reason in the latest 3.10.y
(3.10.38, released 16 hours ago) or if you just missed it. In the latter =
case,
please backport it.

Patch from commit b04c46190219a4f845e46a459e3102137b7f6cac should apply w=
ith
some offsets but otherwise work as expected. We tested with 3.10.37 and d=
id
not find any regressions or other unexpected behavior.

As for now, 3.10.y LTS would still be vulnerable to CVE-2014-2851.

TIA
Florian




--ajfKxDjdpMRJaj7b7lblwwBGt7qjoMp3f
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTXTqoAAoJEKREsMxr9FzxWXwQALUvuBcP8Rtc1I0OjMc5L1FD
YM8StMEb9rLn5CPLB9Ec7k1DSuP1d3FLxvAAU7wxFYEIxZew8GnZdlzAwRNCuEzH
ItGRE1sIsbJRjSPwpIgdwYs6fQZG5BTKl5QKkYSKez5wUF7s/UR9sxiIlWtJ1qMw
KwRtHT1detN2aK4SEUrJsjd/Z3u4KQElHfCGWIwqGBEYLIf8O5wdBNBh+5tZjlVe
6VInPX1BKh3qn/mjV8g0crKd51CD7IQLLvG40ZKdEQM2eaEFAnyJ++QzbKgSc0Vz
rRrVZKwU8ldi8Be+FKJTKb9y8z7C7dmfgBfjiFJctVd35Kfcs7dPnK7iFpu3cnDw
OyfPVZk1lXZsfp7jdoGYlfAIPU8bgEOv7X+E2j+fJsmQlHMiCgt05r27cv8z+g+v
FASdUlSKhu2TnRui5GndbCe3CDeXT71Wkjh4Ap6DagGWu4kwioWgzYnUp8PWdQbm
suck8yoYLQ/a0iwalPly8YqGKWLH6PAcqDInqRBj0fSgma/c/RUku4kmvRkh/EY2
eTNuWUWpHnQC0z9cSFIymrV1hx/aLjt9mHeMMo2enac8zvpo81n5fZzN1TlxlG+R
mm+OT7XrBwN/lWJIMl1gnw39vtiXqPDG1H0ZmlB4+Ue+S++jl8AVIi2Zobk1XFhG
Gb9EfUatVO/XzWIr4vkL
=3lMb
-----END PGP SIGNATURE-----

--ajfKxDjdpMRJaj7b7lblwwBGt7qjoMp3f--

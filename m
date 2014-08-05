Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753846AbaHELkQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 07:40:16 -0400
Received: from domine.madduck.net ([77.109.139.90]:48218 "EHLO
	domine.madduck.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753525AbaHELkN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 07:40:13 -0400
Date: Tue, 5 Aug 2014 13:40:10 +0200
From: martin f krafft <madduck@madduck.net>
To: linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Disabling physical RAM regions for testing
Message-ID: <20140805114010.GA14521@fishbowl.rw.madduck.net>
Mail-Followup-To: linux kernel mailing list <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="Q68bSM7Ycu6FN28Q"
Content-Disposition: inline
X-Motto: Keep the good times rollin'
X-OS: Debian GNU/Linux jessie/sid kernel 3.14-1-amd64 x86_64
X-Spamtrap: madduck.bogus@madduck.net
X-Subliminal-Message: debian/rules!
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Q68bSM7Ycu6FN28Q
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,

A NAS seems to be having RAM problems, leading me to want to swap
out DIMMs until I found the offender; I'd rather not go to the rack
every time I need to make a change.

Is there a way to declare a DIMM unavailable to Linux with a boot
parameter? There is mem=3D and memmap=3D but i cannot figure them out.

I have two 4Gb DIMMs in there and I just want to disable one, then
the other=E2=80=A6

This is the e820 physical RAM map:

[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009e7ff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009e800-0x000000000009ffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000000e2000-0x00000000000fffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000bff8ffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000bff9e000-0x00000000bff9ffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000bffa0000-0x00000000bffaa5ff] ACPI =
data
[    0.000000] BIOS-e820: [mem 0x00000000bffaa600-0x00000000bffdffff] ACPI =
NVS
[    0.000000] BIOS-e820: [mem 0x00000000bffe0000-0x00000000bfffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000e0000000-0x00000000efffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000ffa00000-0x00000000ffffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000022fffffff] usable

But what do I do with those info?

--=20
@martinkrafft | http://madduck.net/ | http://two.sentenc.es/
=20
"aus der kriegsschule des lebens -
 was mich nicht umbringt, macht mich h=C3=A4rter."
                                                 - friedrich nietzsche
=20
spamtraps: madduck.bogus@madduck.net

--Q68bSM7Ycu6FN28Q
Content-Type: application/pgp-signature; name="digital_signature_gpg.asc"
Content-Description: Digital signature (see http://martin-krafft.net/gpg/sig-policy/999bbcc4/current)

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQLvBAEBCgDZBQJT4MKawBEaaHR0cDovL21hcnRpbi1rcmFmZnQubmV0L2dwZy9z
aWctcG9saWN5LzU1Yzk4ODJkOTk5YmJjYzQvMjAxMTAxMjQxMTI1P3NoYTUxMnN1
bT0xY2FkOTZmZDI3ZDMyMzNmNTNlMjI4NDk1MzM2NDgxMDdlNWVlOGQ1YmU2NTUy
NTFkNzRjOGYxYzVjM2JjNDJmMjMwNGZhNTE1MTUwZjdiZDRkZDA1ZTk4MTk5MjRm
MDQ5NTEzZWU5OTYyY2E3MTcwOWY4MWQ5NDUxNTg1MmJkOAAKCRBVyYgtmZu8xIES
D/4iQlUZd5t82Wz1uXM6E//nnd1177Y4UaZCGw55wjClJOaVYp+DZEshvcb49uH+
Sc97KtgjFOIiwv5NAZOmOeV4r+HTN8qVjx9wzsQ8mpaEpGOSa38GhgHQlkAKRpAm
jXBNxLaKOF19Z3WXoqwc4v1V10fK05y2dRZIxn/HImnJmsolJrpJjFkKc6UXWcXX
V6LN3vPCy+RTS7qU/lhO/ftfF/nO44BG/9/O3fsmmRhqP5PKXErCsl87HbXDauVU
/IEQ0DSp0fH0e/dUZWh9WrIxImzLC+L7K3J+Bc9ov0qcag3o2eSeiU4nTn7ofY0u
T0jK4X0L2Ok00poO6Ib5oRpDSZ2a/+aAnClqYPOR/Hw153owBDZWUBUNafPfOGJ+
krr+ei9i5rgJMXQjqy28cHEoYPEfOvYV8bfG2I1qnfEc9VOWqQ1duj2snyhqIo59
A+6z05A/RnORtqArMNxcQNwMtPUHTBRwjZgN6X+XTLkvOx37QlJleC4YUDyDgV7L
Q7EtiFWi7kLb/LtN6BMCL79iFemje1injNQb7y7lpFnScb0KFdFJ8mAgpuACJ6ZR
36QM2EEG76CSEFlUW5ZCvBWr2fn8EWxDzdFkrSzekrZX2LZaJGHKlQu7x8YFa9T9
LAbyz8BSXnSyPCUB8cB8P0brdNBYEBvpcRe99lTqrT8NMQ==
=N9Q0
-----END PGP SIGNATURE-----

--Q68bSM7Ycu6FN28Q--


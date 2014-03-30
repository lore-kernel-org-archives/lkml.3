Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752802AbaC3Bpn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2014 21:45:43 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:42888 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752583AbaC3Bpm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2014 21:45:42 -0400
Date: Sat, 29 Mar 2014 18:45:38 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: [git pull] Input updates for 3.14-rc8 (take 2)
Message-ID: <20140330014538.GB14270@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vtzGhvizbBRQ85DL"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--vtzGhvizbBRQ85DL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Please pull from:

	git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git for-linus
or
	master.kernel.org:/pub/scm/linux/kernel/git/dtor/input.git for-linus

to receive some more updates for the input subsystem. You will get a fix
for race in mousedev that has been causing quite a few oopses lately and
a small fixup for force feedback support in evdev.

Changelog:
---------

Dmitry Torokhov (1):
      Input: mousedev - fix race when creating mixed device

Elias Vanderstuyft (1):
      Input: don't modify the id of ioctl-provided ff effect on upload fail=
ure


Diffstat:
--------

 drivers/input/evdev.c    |  4 ++-
 drivers/input/mousedev.c | 73 ++++++++++++++++++++++++++++----------------=
----
 2 files changed, 45 insertions(+), 32 deletions(-)


--=20
Dmitry


--vtzGhvizbBRQ85DL
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTN3dBAAoJEH70+W8r6ZYqJGwP/3pXpk77iZ7+D9nkAUv0SXJF
6HnvmTFwCqvFAb0yG8KMw+Hgrn9TlxEl5w0jvcetwjvP1ESSXAQ5+tOXoohze4AE
DRgHAS2AEZiOvoEeO8SJFRHSR5Qy6QIObyqgsdmAKsD+tCdwxhdKCYkXpiwKioJl
V+VaNapTbt/HriJSKEinQ1tb+U++YiGLETaO5hpdF7L+D6hzyve1kEiWwa4ek7EA
FfY/uQpZcDVeXWxavJIrWhVfopBrFG5SJGjjTLWA39TgexHLUEF3YO0HsvvHpess
pt8HYHSEYN9WrfaTmyGDWJVR6TZ2TXGsxaDwHZBAvGR1V24yJSGbgt7m1M9RFUSF
I9YSVbj10DBtWladHhPZ9/jS3bUm4Sa+1J/HCfDnP4BjinPUeCB4ZtEPO1NgCEgI
DXSWXxejXlhduqFBFbkXIItitNL3SKLfHKd++yVq0QmX5ZNF4/emRxNVUJSwTxia
oI3eB3oc01QOjy/czUeWKcNwLDT/qIf1EPNlmAN6AXM6cPRn8YSNRnUiTjUr6W3V
eU4cNaEAGIc+pbfMUhEhaV1UNlZ3CaAOMNzx1+E/oZZ6JgI835RPvG9Ro2bEhl6m
TyLH3ZFVIPLhoLUBpC32XpH6azYQVxa03724nHzTfEHaNdvg9JBYKTkS0msm/1ob
BH193KljHjrv5uLtT2Xq
=z+dT
-----END PGP SIGNATURE-----

--vtzGhvizbBRQ85DL--

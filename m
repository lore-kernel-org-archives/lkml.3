Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751900Ab3BPC53 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 21:57:29 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:54463 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407Ab3BPC52 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 21:57:28 -0500
Date: Fri, 15 Feb 2013 18:57:25 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org
Subject: [git pull] Input updates for 3.8-rc7
Message-ID: <20130216025725.GD25913@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="envbJBWh7q8WU6mo"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--envbJBWh7q8WU6mo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Please pull from:

	git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git for-linus
or
	master.kernel.org:/pub/scm/linux/kernel/git/dtor/input.git for-linus

to receive updates for the input subsystem. You will get 2 small driver
fixups and a documentation update for managed input devices.

Changelog:
---------

Chris Bagwell (1):
      Input: wacom - fix wacom_set_report retry logic

Dmitry Torokhov (1):
      Input: document that unregistering managed devices is not necessary

Nickolai Zeldovich (1):
      Input: lm8323 - fix checking PWM interrupt status


Diffstat:
--------

 drivers/input/input.c            | 16 ++++++++++++++--
 drivers/input/keyboard/lm8323.c  |  2 +-
 drivers/input/tablet/wacom_sys.c |  6 +++---
 3 files changed, 18 insertions(+), 6 deletions(-)

--=20
Dmitry


--envbJBWh7q8WU6mo
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)

iQIcBAEBAgAGBQJRHvWVAAoJEH70+W8r6ZYq0iYP/0vh3Dku39QrzljVQ3q0sZBH
bUL2y4ZsBKlEgiuXTKBiFxLOeQdixCvV8MvIIAfiEacXSe3RtC+d4QMCRuMJWouh
KdlXFaL0RyqgDoCv03Ys8YMFT3x2c5kT5YW0kZuZLPu/BoMQfdWdig0csHh5d5Sy
Ry+AXrj0AjltIeSnQG2D6rLo4iKFi+YvWQhsPVVSKlSrL3GsDvO0PQ6PKNnV1Wo7
IKSe+or59z+sJIWEAxaCbC/GVf7tvq7yxH2M/YK8JxzwawyscKq58L/uYMDDkMbV
AcSBs4n8IwG4YbqRYJ1tGOaNCCmh2Diy0lFWve+rlxUoLbZQA6D9+TaW6znmJos7
xcVMgroZB9b63Fv7kGRBLQeoQ3HzZU7mtyuEJCnBt2LZObZlY8wJgciUIjVPXQvc
3sSTcmehJQbXBvJQki27dPgipl0TPY2G6Tl/vGR4Um2hAvSBbRF5UC/XB5HgPUyZ
szVaA+EYdNSmOEad/1Pc7A+fshg4qnQBh+cmzsQu3bxhVbqwu1WmDjNOq5LE5bxL
7S/jL2fzRIbWvTlGjXrqib8oA6TzR/bn3aMkLDHEQ6wC98UAXvISNfrc5SUzsbOw
Mc9c0RZvhDcXucGpHnWCEhYKycp/ulV5lxgUzTmBPvrzmfOAXeXPpxVexxcr5HKd
TByxnFqaoCZBKxoepduw
=5RdM
-----END PGP SIGNATURE-----

--envbJBWh7q8WU6mo--

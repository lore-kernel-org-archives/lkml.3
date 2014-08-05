Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753547AbaHEDOz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 23:14:55 -0400
Received: from ozlabs.org ([103.22.144.67]:59532 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753169AbaHEDOy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 23:14:54 -0400
Date: Tue, 5 Aug 2014 13:14:47 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Guenter Roeck <linux@roeck-us.net>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        lm-sensors@lm-sensors.org
Subject: Re: [GIT PULL] hwmon updates for 3.17
Message-ID: <20140805131447.5cec84e5@canb.auug.org.au>
In-Reply-To: <20140805022209.GA13813@roeck-us.net>
References: <20140805022209.GA13813@roeck-us.net>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/cfbcMSHU=GMMa/UvwSxPV9p"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/cfbcMSHU=GMMa/UvwSxPV9p
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Guenter,

On Mon, 4 Aug 2014 19:22:09 -0700 Guenter Roeck <linux@roeck-us.net> wrote:
>
> Hi Linus,
>=20
> Please pull hwmon updates for Linux 3.17 from signed tag:
>=20
>     git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging.gi=
t hwmon-for-linus

This branch was rewritten (but not rebased) to add 5 commits at its
start and 8 commits at its end since yesterday's linux-next.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/cfbcMSHU=GMMa/UvwSxPV9p
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJT4EwrAAoJEMDTa8Ir7ZwVEGYP/0chSWzQR3HmuRd7B22nYH4K
QWqsFFPD6ZmIcK3pF6ylgfCc9f3ivzhwULD70rRygfmF3AZeXetr1lO4cMmn0Aw7
5ECMM6NaJoMTBeCm7UfN3fAey6Hh8OxWe8h78dQgS3RNvEkb5WuhASBRbYBUZDKs
4cknq30PBAwEH3/RH5jth+P564SxsZSOJahXpuX6+jTlwL4QNT0JDacj1cyyv3eK
8Qo9EKCjmJRBg+pDUghmtKlRz+k9HhZZ/cD8xB7bO+vaEK8D4KY/syyAAxjc86cB
AB+CHtjFkvDZXUP/wyCslZennN56iea/M82VaV3wJDBmHeM4OxSk2VAxRr1LevDC
7ZscCWQaXTpQMEjpU4drUUqDhexfo109jzV2XiCkxb2T2x9c/SmISWvvIMeN4l/L
mZ+cB0Fol1INt5/9nzc+t0KNeLsFqy4NFdBocGMCNKKrU9Rw3rMm3jFYu0V+mZ7p
t+IInrzbXjzj/yrS2FocvoeLnsiUqYYVDt3EUngnCYYHXLBgDfN1a2+k0a2JMfrK
nNTRVJFzN/A6lSlRRQ8Avz+igycsVkGIkpeUGYSmLEBmQPOUSm4kH/Be6aZDj4iN
3hZLdPnjzTth/OBiiqK1ugUYz212vjnwkvd61Qc28yRhYq02ScRcYISmDNQsudGJ
DfTCJwjkVaHVD/O6vrwk
=qAHe
-----END PGP SIGNATURE-----

--Sig_/cfbcMSHU=GMMa/UvwSxPV9p--

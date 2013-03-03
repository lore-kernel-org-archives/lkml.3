Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752966Ab3CCJk3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 04:40:29 -0500
Received: from mail.gw90.de ([188.40.100.199]:58893 "EHLO mail.gw90.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752746Ab3CCJk1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 04:40:27 -0500
Message-ID: <1362303621.13011.14.camel@mattotaupa>
Subject: Re: [PATCH v2] sp5100_tco: Remove code that may cause a boot failure
From: Paul Menzel <paulepanter@users.sourceforge.net>
To: Takahisa Tanaka <mc74hc00@gmail.com>
Cc: linux-watchdog@vger.kernel.org, Wim Van Sebroeck <wim@iguana.be>,
        Arkadiusz Miskiewicz <arekm@maven.pl>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jonathan Nieder <jrnieder@gmail.com>, linux-kernel@vger.kernel.org,
        Florian Mickler <florian@mickler.org>,
        Joseph Salisbury <joseph.salisbury@canonical.com>,
        Joseph Salisbury <josephtsalisbury@gmail.com>
Date: Sun, 03 Mar 2013 10:40:21 +0100
In-Reply-To: <1362289927-3635-1-git-send-email-mc74hc00@gmail.com>
References: <1362289927-3635-1-git-send-email-mc74hc00@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-GWJK8iy925fE51ByZBHK"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-GWJK8iy925fE51ByZBHK
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Dear Takahisa,


thank you for your patch.


Am Sonntag, den 03.03.2013, 14:52 +0900 schrieb Takahisa Tanaka:
> The critical problem which can't boot OS until the power is completely
> cut off found on PC with SB700 chipset.

As commented in my first reply =E2=80=93 at least I think =E2=80=93 please =
add the
mainboard model in here too.

Also add the commit (summary and hash) introducing this problem.

> This patch fix the problem, but,

=E2=80=A2 fix*es*

> this patch prevents the sp5100_tco driver from using watchdog timer
> function of chipset on PC with SP5100 or SB7x0 chipset.

I still do not understand it, as your patches were for SB8x0 support,
right?

> Re-programming the MMIO address registers for the watchdog timer must
> have generated the problem. However, I don't know root cause so far.
> So, I decided to remove the concerned codes.
>=20
> Note that this patch is dependent on the commit adbdcc03 and a6e26b13.

Please add the commit summaries, as a lot of people cannot memorize
commit hashes.

Is this patch exactly reverting these two patches?

> Link: https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1116835
> Link: https://lkml.org/lkml/2013/2/14/271
>=20
> Signed-off-by: Takahisa Tanaka <mc74hc00@gmail.com>

As Linux 3.8 has been released, please add

CC: stable@vger.kernel.org

> ---
> v1 -> v2
>  -The patch was split into the bug fix and the typo fix.

Thanks. Good idea.

> ---
>  drivers/watchdog/sp5100_tco.c | 126 ++----------------------------------=
------
>  1 file changed, 6 insertions(+), 120 deletions(-)

[=E2=80=A6]


Thanks,

Paul

--=-GWJK8iy925fE51ByZBHK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEABECAAYFAlEzGoUACgkQPX1aK2wOHVhTJgCeNIazkmtEIeAJfP2X/oImyB6a
g0YAoIKvhghc4stsu+YE0UiaaOR6Q2y7
=jsVA
-----END PGP SIGNATURE-----

--=-GWJK8iy925fE51ByZBHK--


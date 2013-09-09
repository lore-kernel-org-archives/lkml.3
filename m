Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751431Ab3IIJsk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 05:48:40 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37408 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751195Ab3IIJsj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 05:48:39 -0400
Date: Mon, 9 Sep 2013 19:48:26 +1000
From: NeilBrown <neilb@suse.de>
To: Bastien ROUCARIES <roucaries.bastien@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>
Subject: Re: [3.10.7] Reproductible soft lockup, recover but freeze even the
 mouse
Message-ID: <20130909194826.74d5df39@notabene.brown>
In-Reply-To: <CAE2SPAa-2NY3OKKSbmTY1fsaSD62BXwjNTRhGnrqdRGKd4z4KQ@mail.gmail.com>
References: <CAE2SPAa-2NY3OKKSbmTY1fsaSD62BXwjNTRhGnrqdRGKd4z4KQ@mail.gmail.com>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.18; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/CCm3JLHfbjkHZuF0NYJzfuE"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/CCm3JLHfbjkHZuF0NYJzfuE
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 9 Sep 2013 10:58:12 +0200 Bastien ROUCARIES
<roucaries.bastien@gmail.com> wrote:

> Hi,
>=20
> I experiment a soft lockup. during 20 s I have no mouse, could not
> switch back to console and so on.
>=20
> I achieve to get a backtrace by echo 15 >
> /proc/sys/kernel/hung_task_timeout_secs
>=20
> Seems file system related (hdd led is on).
>=20
> My filesystems are ext4 over raid0 so add some cc

Appears to be "dm" raid0 rather than "md" raid0 - so not my area.
May help to include dm-devel@redhat.com, and maybe include a description of
the dm configuration.  e.g. "dmsetup table" output.

NeilBrown

--Sig_/CCm3JLHfbjkHZuF0NYJzfuE
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUi2Zajnsnt1WYoG5AQKToA//c6DZv3IYM4pbF6V71HBMSb1KObLXaQnX
OtxUerobcMT7UKeG7TYNb38OnJMr33XKO1sp6XADW7Ojc/0L85YwRz+dcXXjEVGm
Xkga+PkNYii/Haqt8/XWiIq1zs6oYiS22hN/f+lR57CHuT4s+QA/t2HKD2CNHfYt
+sZXQp6rAQYert2AgztAuQBZAkQZToNtFX5qmHEJ8fGUQsQVLDTlN8I6wQ77nr89
17+QLLqb0qlplE1QL/8qZ+kwEEWvI2ZouNu85ZkVVg4UQwCgncDKObQNMl0y4P8y
YxB5UCAPBDhVZVlEjB31biZqpwKINtfWMO/kxeNl9siv+sLA0hm3hjDX6DMWSJbD
ISEEsUglNXPri0wwhahfaQX2i4pyBUNTOout+Mn5/Tm+ff1vkU4W+fhwMg2d1snD
stFV3BE9Arou2Lbig1TC21P3D0b619ltMTJTw8e00aIm0kj0xtLh7zGmvx1ikTu+
811rJMleTOZ+UbOx1wkTlcnZ9E9HEIntz8EqiG9vw4TFwhYGR+YB8ZnsqXvnKf86
TQUqLetLTdsvXZ66cCZw5k/NfN5z2kCpKudkXY79Pm9nzoXKkDN88Rqhs9Julazs
juOWEgVYB9bam6twsc+r8557Z2dLjPvI2KSYJVPdYqqPHeNY+RAGhiNyEuq3iDT7
3CXEtDgreWc=
=RIxN
-----END PGP SIGNATURE-----

--Sig_/CCm3JLHfbjkHZuF0NYJzfuE--

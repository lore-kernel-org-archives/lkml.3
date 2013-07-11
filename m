Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755519Ab3GKGVC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 02:21:02 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:54875 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751416Ab3GKGVA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 02:21:00 -0400
Date: Thu, 11 Jul 2013 16:20:40 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Alasdair G Kergon <agk@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, dm-devel@redhat.com,
        linux-kernel@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Hannes Reinecke <hare@suse.de>, Jim Ramsay <jim_ramsay@dell.com>,
        "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Milan Broz <gmazyland@gmail.com>, Rob Herring <robherring2@gmail.com>,
        Robin Dong <sanbai@taobao.com>, stable@vger.kernel.org,
        Yann Droneaud <ydroneaud@opteya.com>
Subject: Re: [git pull] device-mapper changes for 3.11
Message-Id: <20130711162040.8a82cb97a6c647c4f61f919b@canb.auug.org.au>
In-Reply-To: <20130711013448.GD32399@agk-dp.fab.redhat.com>
References: <20130711013448.GD32399@agk-dp.fab.redhat.com>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.19; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__11_Jul_2013_16_20_40_+1000_ZJxiQaIUqlYFVqyR"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__11_Jul_2013_16_20_40_+1000_ZJxiQaIUqlYFVqyR
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, 11 Jul 2013 02:34:48 +0100 Alasdair G Kergon <agk@redhat.com> wrote:
>
> Please pull from:
> =20
>   git://git.kernel.org/pub/scm/linux/kernel/git/agk/linux-dm tags/dm-3.11=
-changes
>=20
> to get the following device-mapper changes for 3.11.

The device-mapper tree exists as a quilt series in linux-next.  The
patches in the above git tree are the same as the ones in linux-next, but
have a different base (and the ones in linux-next were on a different
base from yesterday as well). :-(

Alistair, is there some reason that you cannot maintain some relatively
stable git tree for me to fetch (instead of the quilt series).  Also,
there is not real reason to keep rebasing this stuff (especially just
before sending it to Linus).

If you want to test for conflicts before submission, then, fine, do that
in a test branch by *merging* Linus' tree (git is good for that), but send
Linus your pre merged branch and if there is some complex conflict, then
explain it to him (and me if necessary) or publish your test branch
separately to show your suggested resolution.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__11_Jul_2013_16_20_40_+1000_ZJxiQaIUqlYFVqyR
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJR3k7CAAoJEECxmPOUX5FEhvUQAIi5f1KfGNtx65lE6Q+jfBvF
G5RUw+kWXM1AYiVm2CN4bgl329Hq6EjxVBtOyHue7zgJ6vs3E/s1iskUTdDLZwsP
sBp5l4byYLn2sBS1VO1AOKuYoO0TE5QtJqFMi2mRTw29SsJyollojHA8OxhZpdhq
pwx0CpS5vsBDyYV3r/N3ksf/n9XHsYoKO6seohQzvPkHe2Gjj/iQ3QqvDIJTqcXN
UO2QaHr0mX+vLoOnNm9b88rA4gwDqH15l9MI74FupDt3lf6qBrBlPwVYP2INQ+r0
xBDlPF+TbG2vJNKrjDKzRvxSktP174Gu+/I9ujmKw/vr5nfSFEKKQAJw8cw+D+Op
VN+47xqPxMvf1W6BMQKM8DsUJqKnWKqHGS5kS0Goeyf4q3xqKNi3QmCbzJwfi1dL
h9yHcYuLtHw1mJPeOQgn6fGHtxjH5/t40yTiejsRi87/yDKeZmRVwB3d2lNj0EJE
Mr4jLLaYCAKC6hSIchlGDsw5oWGjtR+VL3KAA1a+Ee/9pfzmrf6kB6BMU1GvxDw3
O7pnJwGTPlxnWUvle8rwew2/EiJzAXuAGOeN7P+UOPegHRe/OHk7rmGO8Tn1zOwT
Yzk5gMlFVMgn3cSH/Jw181GHoFMJDVtv+PuZP0TrDVWthl/gdmSFo1qZDZz45+9t
/c69O3Lwo0tRnntqvKBX
=Qvyq
-----END PGP SIGNATURE-----

--Signature=_Thu__11_Jul_2013_16_20_40_+1000_ZJxiQaIUqlYFVqyR--

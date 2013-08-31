Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755344Ab3HaUry (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Aug 2013 16:47:54 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56227 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754077Ab3HaUrx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Aug 2013 16:47:53 -0400
Message-ID: <1377982049.9792.44.camel@deadeye.wl.decadent.org.uk>
Subject: Re: stable: please queue commit 0231bb5 ("perf: Fix event group
 context move")
From: Ben Hutchings <ben@decadent.org.uk>
To: Ingo Molnar <mingo@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, stable <stable@vger.kernel.org>
Date: Sat, 31 Aug 2013 21:47:29 +0100
In-Reply-To: <20130805082118.GD26746@gmail.com>
References: <51FF5FC9.8080302@huawei.com> <20130805082118.GD26746@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-kflh9ETM4aDJEhIUPciv"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-kflh9ETM4aDJEhIUPciv
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2013-08-05 at 10:21 +0200, Ingo Molnar wrote:
> * Li Zefan <lizefan@huawei.com> wrote:
>=20
> > Plese consider adding commit 0231bb5336758426b44ccd798ccd3c5419c95d58
> > to stable tree. It fixes a real bug, which was explained here:
> >=20
> > 	http://thread.gmane.org/gmane.linux.kernel.perf.user/1144
> >=20
> > and I've managed to reproduce the bug in 3.4 kernel with the test
> > program attached in the above email, and I've confirmed the bug fix.
> >=20
> > The effect of the bug is, if we open a group of mixed events(sw/hw)
> > and the "disabled" flag is not set and sw events come first, then
> > some of the perf events won't be started after the call to perf_event_o=
pen().
> >=20
> > The bug fix should be applicable to kernels >=3D 3.0 && <=3D 3.7.
>=20
> Acked-by: Ingo Molnar <mingo@kernel.org>

Queued up for 3.2, thanks.

Ben.

--=20
Ben Hutchings
If God had intended Man to program,
we'd have been born with serial I/O ports.

--=-kflh9ETM4aDJEhIUPciv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIVAwUAUiJWYee/yOyVhhEJAQrltA/+OqNLr2na8n1LgeN0ndf9vn4FqWvkir4W
9GPJvI26Z04RLEMUVaLE7f3TY3mTwMSYwdoeAmfNyUGEezrAg7vuPO5rLydLcuvJ
HZjnK326sEQETtg4kO8q8jD592pQUebq1OSHBMgtpjJjn9uxEcgJ1BtW2rxcynLm
BZvYrQXgtkOnoexCjy1spaZVFf0/FM0Ehcwlu0p0z9VazDYjRDQz49oyR7WnEuWo
WQtOAnwx4iBWdA+gNf00FbwuZ8bqhYlFUWrYXTBtOFpfy0LqbK+wQWcb6nA1JoEx
0JmSbDN9vSGhLNeiWRCkyZl8tdrPGy3bpOcBStJTv09pQd5umKUkAJE/eQoLZsFl
96cWiTjZCfmZY2oGwuQqEMjg/MPgsVNFoP8AZs8g5NVFVpMsIODuXVRkzUeiUPSV
fGuvkGDTPacRKgyVBS5j8xrZ0JgXO1RlUgH4cTHCSl5VYdfjeEM5nP93WDWSYhIZ
POQhKR1PpH/jV60rXhhQWCe27K23da5M1YssLMZMR6CGUQcVmiYhckYErZBrli30
GDvttKt2RAaVOSi29VC/jS5Uh566hZi+P+LcXJ0KOLVPJBm5XDO9PugWE/NSK6kq
dHX9aPjk6Y23xXlKmAaKuwPBduNDr4GDSQdxd33kQvZbNNfDr0xAluwZ66mq0RtF
0Tuzth52lrA=
=Y9Xo
-----END PGP SIGNATURE-----

--=-kflh9ETM4aDJEhIUPciv--

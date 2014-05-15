Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754146AbaEONWo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 09:22:44 -0400
Received: from casper.infradead.org ([85.118.1.10]:58557 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751455AbaEONWm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 09:22:42 -0400
Date: Thu, 15 May 2014 15:22:35 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Carlos O'Donell" <carlos@redhat.com>
Cc: mtk.manpages@gmail.com, Darren Hart <dvhart@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Jakub Jelinek <jakub@redhat.com>,
        "linux-man@vger.kernel.org" <linux-man@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Arnd Bergmann <arnd@arndb.de>, Steven Rostedt <rostedt@goodmis.org>,
        Linux API <linux-api@vger.kernel.org>
Subject: Re: futex(2) man page update help request
Message-ID: <20140515132235.GM30445@twins.programming.kicks-ass.net>
References: <537346E5.4050407@gmail.com>
 <CF98E3EF.90564%dvhart@linux.intel.com>
 <CAKgNAkh+PWzT2SByaLk_OtiAXeZSkWoMgu+ivDOt1dTWVtaatQ@mail.gmail.com>
 <5373D0CA.2050204@redhat.com>
 <20140515081444.GD11096@twins.programming.kicks-ass.net>
 <5374BE9E.8080408@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Y8f0OdbJ4Wm/1jzW"
Content-Disposition: inline
In-Reply-To: <5374BE9E.8080408@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Y8f0OdbJ4Wm/1jzW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 15, 2014 at 09:18:22AM -0400, Carlos O'Donell wrote:
> On 05/15/2014 04:14 AM, Peter Zijlstra wrote:
> > On Wed, May 14, 2014 at 04:23:38PM -0400, Carlos O'Donell wrote:
> >> There are other syscalls like gettid() that have a:
> >> NOTE: There is no glibc wrapper for this system call; see NOTES.
> >=20
> > Yes, can we finally fix that please? It gets tedious having to endlessly
> > copy/paste that thing around.
>=20
> What exactly would you like fixed?

Not having gettid() in glibc.

--Y8f0OdbJ4Wm/1jzW
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTdL+bAAoJEHZH4aRLwOS6xloP/2+Dg9kFtmCHAJJNl4IJQBgj
mmpDB/VgcRYQo0D2gKtaXwFeFhUJqR0SvWJIEA/wH5PXMG8ItJ5KvJ8DgBlp+IFT
QTrFjwM2LaW/uoDn7T34ubtqUZHJYRJycgFEXIh1m/57CYH41svEEWukUMjf0vU0
9ov0nmp3c3imJ8EYl9a2yudoH2IIL1bY+UNyYguMusPNCG42F2+nWttKhVhKzm5i
oBHgrJjWF49DgHvykNswNj+cB1aeuNf93G9wGNkVZ0xiuFrAbZVCOYXECJT/M01R
nxpMKeM9jWuIvhJEYZ6tcpqjkxkTjaa64fGHoIYgU7mXuVebs1ED6ia4W5398tjm
nUGMrRPrRhy2YgHBlqvJN4b4R25kneVMQ0z2rV7utx5RqiDl60kjcl4K7yHfdisM
JjxRuFOWhN1EgjyEDWCzaW7Ja8ns+SWhIDYfAL4VN7fCcS4G7jY+5pdurM5IxgU+
7+HGgLkAeYqFhRpoC3s1TA7VuxMDXvUCc+YQeP9whs1XDtcznlPlelYBrPbbf9Pt
oJpEhA/VnYKpmiV+CXLxJo5IwDYTJQj+ZHTe5KNSfHCwYe9zF2ytf+R1v+iz2Vy1
hWXTopePCszGVQ50Ls/8kUkFhLY9HnTDEhy9YY0vkLikRUSFWd1P4Ng3dWg9Q+nC
Q22G1Kj7iYiw701hMj2X
=3HGs
-----END PGP SIGNATURE-----

--Y8f0OdbJ4Wm/1jzW--

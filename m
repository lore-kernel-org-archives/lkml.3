Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753991AbaEONzp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 09:55:45 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:36632 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751689AbaEONzn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 09:55:43 -0400
Date: Thu, 15 May 2014 15:55:25 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: "Carlos O'Donell" <carlos@redhat.com>,
        Darren Hart <dvhart@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Jakub Jelinek <jakub@redhat.com>,
        "linux-man@vger.kernel.org" <linux-man@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Arnd Bergmann <arnd@arndb.de>, Steven Rostedt <rostedt@goodmis.org>,
        Linux API <linux-api@vger.kernel.org>
Subject: Re: futex(2) man page update help request
Message-ID: <20140515135525.GN30445@twins.programming.kicks-ass.net>
References: <537346E5.4050407@gmail.com>
 <CF98E3EF.90564%dvhart@linux.intel.com>
 <CAKgNAkh+PWzT2SByaLk_OtiAXeZSkWoMgu+ivDOt1dTWVtaatQ@mail.gmail.com>
 <5373D0CA.2050204@redhat.com>
 <20140515081444.GD11096@twins.programming.kicks-ass.net>
 <5374BE9E.8080408@redhat.com>
 <20140515132235.GM30445@twins.programming.kicks-ass.net>
 <CAKgNAkjrS8WWMoQzsiOkMVn1_Bf06uFCL6ECU7z=mv0fszg+gQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="kjKtxPfQ9oMouvwR"
Content-Disposition: inline
In-Reply-To: <CAKgNAkjrS8WWMoQzsiOkMVn1_Bf06uFCL6ECU7z=mv0fszg+gQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--kjKtxPfQ9oMouvwR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 15, 2014 at 03:49:10PM +0200, Michael Kerrisk (man-pages) wrote:
> On Thu, May 15, 2014 at 3:22 PM, Peter Zijlstra <peterz@infradead.org> wr=
ote:
> > On Thu, May 15, 2014 at 09:18:22AM -0400, Carlos O'Donell wrote:
> >> On 05/15/2014 04:14 AM, Peter Zijlstra wrote:
> >> > On Wed, May 14, 2014 at 04:23:38PM -0400, Carlos O'Donell wrote:
> >> >> There are other syscalls like gettid() that have a:
> >> >> NOTE: There is no glibc wrapper for this system call; see NOTES.
> >> >
> >> > Yes, can we finally fix that please? It gets tedious having to endle=
ssly
> >> > copy/paste that thing around.
> >>
> >> What exactly would you like fixed?
> >
> > Not having gettid() in glibc.
>=20
> Get in the line ;-).
> http://sourceware.org/bugzilla/show_bug.cgi?id=3D6399

Oh hey, it moved.. :-) Hadn't seen the comments since the 2008
time-frame.

--kjKtxPfQ9oMouvwR
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTdMdNAAoJEHZH4aRLwOS69YwQAKdFuSISZZIAkE7rKXBagKXh
S2/lB1zmDUhYELCOQu6ZMm5aFPRr/9Unn+NFRdvbRco9uUuo0K6RiKfcSHfVIjA5
CN6dipOQxJkIcyWr9i/RfVIOiWJTPS0FxjXAbe09YSGw5CFg/3K3uMfkxGOaccm3
Ty9iW8ExJcrihHnASByu4TEBhTYAbeYsn4BIH4vHDNrSsjEmdT78ERhhgK1RumAd
pQIaOeI/Y0t4gDeAsC0nBtXvKhu633SVP6Sgq+d7MuS4h2Q5Gv0QyeLHG2Iz70tr
vu7FaePnF/FJeYcQKS6kFAZI8Ie/2V+D9gQLzGOmu7r5QILxJGHgUME0Ie9k11xA
gOR952WkfRlkgGHHc7Inaym33DPRnqmag9ghnzLKJmsyDH1pCzY+6xNlIKUhsRrU
sv7OdLTRg6Q2omvf9dnSRKUrOaS/NkuwrY4WxpSNwLd0ctvao+zq7k9HhE83z1ge
/m5DObPAe+Fl336AIadRX+kpcPRdo7n8Ru+NF46P6yw1mLlktakMOH2yUQEtQpxj
KCnmw2Eivl6dVXpmmEKW6laZy4ftpGNNr15Qs7jXjMHc/bOzeOnh1ydT8pemv0Tc
9Ft+HttoCt1MkOAGZVuQQYXKC3GF7tTdL/mjZKrTMv4H7mDa2FjoKoYLCFqmRI2/
jmmLj/DRdq4gY82yFXeJ
=iGDw
-----END PGP SIGNATURE-----

--kjKtxPfQ9oMouvwR--

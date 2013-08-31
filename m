Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755743Ab3HaUjE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Aug 2013 16:39:04 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56169 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752997Ab3HaUjB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Aug 2013 16:39:01 -0400
Message-ID: <1377981493.9792.42.camel@deadeye.wl.decadent.org.uk>
Subject: Re: stable: a59f4e079d19464eebb9b06513a1d4f55fdae5ba needs backport
 ?
From: Ben Hutchings <ben@decadent.org.uk>
To: Ingo Molnar <mingo@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Peter Zijlstra <peterz@infradead.org>, gaoyang.zyh@taobao.com,
        LKML <linux-kernel@vger.kernel.org>, stable <stable@vger.kernel.org>
Date: Sat, 31 Aug 2013 21:38:13 +0100
In-Reply-To: <20130802111455.GA29304@gmail.com>
References: <51FB7DF5.8030600@huawei.com> <20130802111455.GA29304@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-TSmKRLMrP82bimTTUHds"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-TSmKRLMrP82bimTTUHds
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2013-08-02 at 13:14 +0200, Ingo Molnar wrote:
> * Li Zefan <lizefan@huawei.com> wrote:
>=20
> > commit a59f4e079d19464eebb9b06513a1d4f55fdae5ba
> > Author: Zhu Yanhai <gaoyang.zyh@taobao.com>
> > Date:   Tue Jan 8 12:56:52 2013 +0800
> >=20
> >     sched: Fix the broken sched_rr_get_interval()
> >=20
> > Without this patch, syscall sched_rr_get_interval() can return wrong
> > value, and the bug was introduced in 2.6.24, so this looks like a
> > candidate for stable kernel.
> >=20
> > The concern for backporting is that this might break some userspace
> > programs? As the changelog says:
> >=20
> >     [ Since this is an ABI and an old bug, we'll test this via a
> >       slow upstream route, to hopefully discover any app breakage. ]
>=20
> It appears to have caused no trouble.
>=20
> So I'm fine with backporting it to older -stable kernels:
>=20
> Acked-by: Ingo Molnar <mingo@kernel.org>

I've queued this up for 3.2, thanks.

Ben.

--=20
Ben Hutchings
If God had intended Man to program,
we'd have been born with serial I/O ports.

--=-TSmKRLMrP82bimTTUHds
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIVAwUAUiJUNee/yOyVhhEJAQqOzw/+MzNT+sno5RVzXwphMPNC9pDW0dyQ934h
S4pQ57ZPJ/d6hdKK///Ui7Np/W6Jljv5OvTBD0FgezLNwHTLxz1tsvRO+sKE9Mwu
jZORti2W8YomE8dpj1FLL/1o3tJx1/H6bg6D566WR74lR+vJvPHexxnQEaVboevp
O8/u3fQX9qd1XPqL7Vde0doEY3tsQ6fLCwBySs+MGlcAw3cCTzGIx13OTaOibgNh
6krGdrtDv0dgD5BSClugB9rAsEGATpZtHgPKPxzdnt4n9LoojHmZkc3fD9EsWeEx
1u3OS7YKpZXGGWvH+fMGpX0qbTmw/wB0+/mTCXb0pfgkmGkVWAnEMi5iCTYDQbv6
LffykdVTJZs07h2HMnSTYaUN/8Jc18grK6GJ31AnW4p/az2x8imhK5328/Yq/uai
C0ClKUjEd3D0A4n/7huTZQTfrDaz2TrGcWMCpRf49wV4mow9M2qAialC4uE7J09m
e8ysuCb9NceuARsled+WW1lx3Q43iFcKq1zlDfJYyvfCP6drhsy+xftQvIuSuUtC
Z233rXW7PEIvHTDdwoJfmKKuFUGbETLcfGRJ8cHp1m+vtkkNOkOB6JQL7fDWYnjX
wwOdW9KS/duV8pGq38JRNdHjuUsOMKeky0Dia4oi+TcE361rRINQ01dx4rE+0fCG
zc/hDNWS8Mk=
=kU+N
-----END PGP SIGNATURE-----

--=-TSmKRLMrP82bimTTUHds--

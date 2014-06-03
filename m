Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932796AbaFCPMD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 11:12:03 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:57821 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932080AbaFCPMB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 11:12:01 -0400
Date: Tue, 3 Jun 2014 17:11:47 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Jason Baron <jbaron@akamai.com>
Cc: Sasha Levin <sasha.levin@oracle.com>, Ingo Molnar <mingo@kernel.org>,
        "acme@ghostprotocols.net" <acme@ghostprotocols.net>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Dave Jones <davej@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>
Subject: Re: eventpoll __list_del_entry corruption
Message-ID: <20140603151147.GX30445@twins.programming.kicks-ass.net>
References: <5370EBE9.6@oracle.com>
 <20140515181102.GH11096@twins.programming.kicks-ass.net>
 <538DE49F.7040904@akamai.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HoX+cWnpt0BNB0oo"
Content-Disposition: inline
In-Reply-To: <538DE49F.7040904@akamai.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--HoX+cWnpt0BNB0oo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 03, 2014 at 11:07:11AM -0400, Jason Baron wrote:
> Hi Peter,
>=20
> If its possible to reproduce maybe we can apply the following debug

I think I saw it twice during a week of fuzzing, so it might be a while,
esp. since I'm now not actively fuzzing anymore, but I can sure stuff
this in my tmp/trinity branch just in case.

Sasha and Dave might also want to carry it for a while, since they're
doing far more of this than me.

> patch to at least have a clue about which wait queue has gotten
> corrupted. The bug could also be isolated to the epoll core too (ie
> not specific to a particular wait queue), but I think its worth a
> shot...
>=20
> Thanks,
>=20
> -Jason

--HoX+cWnpt0BNB0oo
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTjeWzAAoJEHZH4aRLwOS6Y5UQAI3Sl/wBOGi0ZXCIsclDnNQw
JSz91OFXRKyR/0pR/Ow8KyfFBW6q+US49x6elBAopPvg4z+wsOoATcMIH5pz3Ta0
q2RRCpu5NowEeiCEpTqHB2GU0rqEACDBOQUVbmsqGNtuzl878I+a7k1GOyP5v4/d
KIyFUmPYl/HjQ0hBCAwrTaOkKJ3DXxHnnuBSEKlg8BzLivjmP2tAqup1z7sQS1QH
ApFWuUyC+rW9nro/EOJA4B1kUbInSqaRWC0bthQi08aE+P8eHeCXVtW4vgOuz8mm
OfCbsVmgaOjfTPmLb206KFipDTdJCpyCi0ylv65qhFNpGtci2eu78Ep9COlSbXty
bA8mTVgJirqRGN4+2wu88ZejEzMRxLNxSPZaQLp7p4WaluDP6771TsOFDpVuzPzQ
9jzWZni9FOiKor+ePcxOV7k/IpoU28nQc4TEQ0XjgpEyN5vLddJ2jYzGbYviPJf2
ghbgQgwXt7NYHzTPOaQneq3wX0Sjyqlmykler/i0ZzTHbt47TmPeAX5LTw2De7p4
PrfClsmLknq4gN9nHwV++nZHmsYhdE4C0PMLobpdN4/vho9KFQyeHkfHj62O4k1F
0UmFEJjIRWXMANJYvcvrxTIUH36sSCeidqWmleKq6TBIaQRUCZOJZHNt6XcuL42k
r1Ti0E5+2iMmTOPGBcMb
=QFWI
-----END PGP SIGNATURE-----

--HoX+cWnpt0BNB0oo--

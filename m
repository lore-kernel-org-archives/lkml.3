Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751778AbaEGRhk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 13:37:40 -0400
Received: from casper.infradead.org ([85.118.1.10]:39540 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751033AbaEGRhh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 13:37:37 -0400
Date: Wed, 7 May 2014 19:37:28 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Richard Yao <ryao@gentoo.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Vineet Gupta <vgupta@synopsys.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>, Jiri Slaby <jslaby@suse.cz>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        kernel@gentoo.org, Brian Behlendorf <behlendorf1@llnl.gov>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH] x86/dumpstack: Walk frames when built with frame pointers
Message-ID: <20140507173728.GW30445@twins.programming.kicks-ass.net>
References: <1398535818-14217-1-git-send-email-ryao@gentoo.org>
 <20140427120820.GC22116@gmail.com>
 <CA+55aFw39HcWMYsPXb=PMK6--bHCSWwrjucGK+4VswEZrWLbGA@mail.gmail.com>
 <20140507171821.GA16671@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Sr6hGnsCY8KeifOY"
Content-Disposition: inline
In-Reply-To: <20140507171821.GA16671@gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Sr6hGnsCY8KeifOY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 07, 2014 at 07:18:22PM +0200, Ingo Molnar wrote:
>=20
> Conclusion:
>=20
> So to me #4 looks best, and it's 16 lines instead of 31. Not as=20
> compact as your mockup that has 13 lines, but pretty close.
>=20
> (I'd also do the color tricks on #6, but that's more technically=20
> challenging and I also don't look forward fighting the syslog guys=20
> over it...)
>=20
> I'd guess that some people would prefer #2 or #3, depending on how=20
> ergonomic the parentheses and brackets are for them.
>=20

Can we get a CONFIG option to retain the old (current) format? My brain
is all used to those and since I use a logging serial console there's no
space issues what so ever.

--Sr6hGnsCY8KeifOY
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTam9YAAoJEHZH4aRLwOS6vDQP/3EDAea/gHcBuWqQFQme0gQO
fJwuZrw1siBe5BdwL6CAuv0zALJ7wBxtYs/0yHUNgRosZLcJQe46oTGn/A696gmj
xtJE/iZNka9WQYS3kL5OTrrYZZ+BvtppEKuV2P15u0mJp652uChWF5dKmAqC4TtO
JOJTokqSDoRm/v+DwoiXayc6jy9Pt5IIShng9V/gQ865VpArVSvn1kuZXm/n32/U
4hoj9GDAb5aZ4WBif3uWOAZucltPas6QS/eHx1Cyete6Ta50GQsUS6DWQ5Tt/UQZ
mZQt003n3YKsqh+Iq6py7q5ArMTRUD9AP5ZQYFptW98QQjZZb9mBLMxkvLsy1B/S
zenDQAi8Te+RKADWmKqpoKSqRdBIvck5+d4eW8dH4PRwzFW/AxsMy4Esh890K7xh
LiBlDOGQaszcsNQ6awOQN9QnHS+rUk9rFcf2tsYKSCo1I3F+spevA/SblUr8bw+A
rm7M6m5kvNzJs9H2CZ53Sshn1YgOBudwv2+rB/u8zZ8SQVSCSMKljCz5k9fcG75o
uvFPr8mYE5OHFOA5jocw5VX0ZBVSfdgLpZ0TuaYphIHfwYYlf7EVaHh0i7Rea9Qv
cVMat3sspOi0JmFT9hnpi4gFSpr1cEKwvAg3vG2L9QgsrgwHmSrQvNbMoprF8DVp
G/VHIGuDG50jy3t5jkJM
=mVm0
-----END PGP SIGNATURE-----

--Sr6hGnsCY8KeifOY--

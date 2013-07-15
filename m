Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758501Ab3GOXnA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 19:43:00 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35651 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754896Ab3GOXm6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 19:42:58 -0400
Date: Tue, 16 Jul 2013 09:42:41 +1000
From: NeilBrown <neilb@suse.de>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "J. Bruce Fields" <bfields@fieldses.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Ingo Molnar <mingo@kernel.org>, Guenter Roeck <linux@roeck-us.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dave Jones <davej@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>, Darren Hart <dvhart@linux.intel.com>
Subject: Re: [ 00/19] 3.10.1-stable review
Message-ID: <20130716094241.43dbabb0@notabene.brown>
In-Reply-To: <1373915984.17876.176.camel@gandalf.local.home>
References: <20130715155202.GC29526@xanatos>
	<CA+55aFw-FSnVM1xpHs2HVooutz1ystAWYhsWLUqFiGU+owSTZw@mail.gmail.com>
	<20130715174659.GC15531@xanatos>
	<CA+55aFx4VoYZCEQ97jaAKDWViG1yfu9AikJ4R+dKru-qPVSY-A@mail.gmail.com>
	<20130715180403.GD15531@xanatos>
	<CA+55aFxmV83=_kjsHGbXFwQW9tXdbT6vyEGcuDTC00X0JJvB7w@mail.gmail.com>
	<20130715190505.GA3336@fieldses.org>
	<1373915984.17876.176.camel@gandalf.local.home>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.18; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/J6pzIXUGPbktN2ssPCYiYjX"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/J6pzIXUGPbktN2ssPCYiYjX
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 15 Jul 2013 15:19:44 -0400 Steven Rostedt <rostedt@goodmis.org> wro=
te:

> On Mon, 2013-07-15 at 15:05 -0400, J. Bruce Fields wrote:
>=20
> > "Nice", "subtle", and "polite" all seem mostly orthogonal to me.
> >=20
>=20
> "Nice" and "polite" are rather attached.

Being "polite" without being "nice" is quite possible.  It even has a name:
 Diplomacy.

NeilBrown

--Sig_/J6pzIXUGPbktN2ssPCYiYjX
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUeSI8Tnsnt1WYoG5AQJKsw/+LlebrhJmtOIVkCs744DoB0f6fjGEbTxL
r15bdR8plVr+1cnHTqUhltu3S9pc0xuBCt46QdnRa/JAC3OUVZEVPSniPDbio52h
Y7OIo3g6RpgeYhE5BVCfmcQeqN1+fohusUmbkt43tVGig6S+BUxpBnpNzh2qJr/W
Sfj/OAGOXYMcXZ8yoCdO22XvqEXOSnXlmd+EKyJlw8w+v/AsciyY34ItKkIUP7k6
xtjQs45iOm2ANVXY/3nPFKoZ0+KBUY/odR/l40n5xmPrFWmKhthQwFWL+ErmUdcy
aobc53XguT817WDj8wcb4rj6EzOIlU6ICIJZ3snafj1P7Loz69YqLiriifSv73rJ
hk4G8lk4ectzVCIUc9DOdcnx0xt+gInVMIlw0UKEmRuucmzGbXeZIQklhF+fzaeR
ew15NaSWjoGjcoK6ontHDuH1Skg9cMUeTPX4VsMEjPCqalJM9chtyTYH29pvJ20e
ZaXusBzb5oWYz4C0qDrSGpp3y4BP8xeNQjGAFgkrE/qdxck64UQHw7Z4BfLAc2Rm
NtYMT2akZX3MBeE10Fn0hkGBbOKOP4ZD863AupHHFrWNa2xk5Rnl4YHWPy2wqpJB
oEKGW7CX04i1EaWiIH01zvSjZkI1saxPtulpNHeDEH4iVRn3CqAgYr4JWVueH6IL
jYdK6t873sM=
=TNxX
-----END PGP SIGNATURE-----

--Sig_/J6pzIXUGPbktN2ssPCYiYjX--

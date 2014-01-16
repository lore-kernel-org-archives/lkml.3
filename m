Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751403AbaAPWeg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 17:34:36 -0500
Received: from ozlabs.org ([203.10.76.45]:34279 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750754AbaAPWef (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 17:34:35 -0500
Date: Fri, 17 Jan 2014 09:34:26 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Len Brown <lenb@kernel.org>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the tip tree
Message-Id: <20140117093426.ee8e3d1bb2e95c9f67ec625b@canb.auug.org.au>
In-Reply-To: <20140116222536.GX30183@twins.programming.kicks-ass.net>
References: <20140116145829.5e4fcab103b1c5c77501ee77@canb.auug.org.au>
	<20140116121955.GQ31570@twins.programming.kicks-ass.net>
	<20140117074628.88698f59939c9002b7c12968@canb.auug.org.au>
	<20140116222536.GX30183@twins.programming.kicks-ass.net>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__17_Jan_2014_09_34_26_+1100_S1+uVWKy9DcPQKi6"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__17_Jan_2014_09_34_26_+1100_S1+uVWKy9DcPQKi6
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Peter,

On Thu, 16 Jan 2014 23:25:36 +0100 Peter Zijlstra <peterz@infradead.org> wr=
ote:
>
> On Fri, Jan 17, 2014 at 07:46:28AM +1100, Stephen Rothwell wrote:
> >=20
> > On Thu, 16 Jan 2014 13:19:55 +0100 Peter Zijlstra <peterz@infradead.org=
> wrote:
> > >
> > > I think the below ought to work
> >=20
> > To be clear, all you did was replace the body of mwait_idle() with
> >=20
> > 	mwait_idle_with_hints(0, 0);
>=20
> Pretty much, and add the asm/mwait.h include, otherwise you'll end up
> with a compile fail.
>=20
> > (and the comment above it)?  I need to apply in incremental patch in the
> > merge commit.
>=20
> I don't think I touched the comment at all.

Thanks.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__17_Jan_2014_09_34_26_+1100_S1+uVWKy9DcPQKi6
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJS2F52AAoJEMDTa8Ir7ZwVJd0P/jGPDChXvScQ0xLsL42IMdVq
8Z1/nAoDjI85yPnheQgreh75ia1SFN/l15LGk0yhxtI+H3WomIqrF0PDqhKjOyBZ
+Zwzwfvpug82XD6K7ArfhKeia8++fvTVZyIUt6CNV6b5yKRUILYwjY9AC1E1lj6T
hIGMpdrVPbqHyQU3HxPLpJz1BtRXKWmorfc9kJ8bVGCqPho81550Zysj98asjzMQ
7iw9jCcOsChUtttRXhxsFhPr4JrQ5d8Byi2bif2NLfxxSAeLjgzZNbZKmgV1R4hX
7Yl2eukq1BDbXAFhuy+AdNM93YfG9VTDG4FvHOo1KHKO2W71fG5hO71Y+tUEafGa
buv/DrrFEPZqTgJy6Gcid7E+qi9f45Y2a75sh1cuDXse67D1MyJ8LKOsUzuINGIP
eNzh0zB6Fj2KS0CKVGrRBnNbGvRA8jHyGqMnF79Tl59OyLBT/+bH1Mu7qLh+5BmB
fnTtM05402KuhglfHcOSqB2ALbW2ofR6/+5rF02JRi7/hV20mVNSennebBZ7N8cD
uzKoSjJaWH+TgcDWbwAdgh+PReKG3U/pEOCjaXN4hRWeHd8Ql9kFpSvkQ0JGk4+6
0dfJP7gOCdPifb8aMNJHAhnXbEKx8jvA5jKNfQjcdvUhnw7UBz3KjbHC+AGZtgln
Ef9WtTZhQUjPCQ+djZd4
=VaPg
-----END PGP SIGNATURE-----

--Signature=_Fri__17_Jan_2014_09_34_26_+1100_S1+uVWKy9DcPQKi6--

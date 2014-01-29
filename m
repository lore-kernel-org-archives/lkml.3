Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755350AbaA2C4M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 21:56:12 -0500
Received: from ozlabs.org ([203.10.76.45]:35063 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751834AbaA2C4L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 21:56:11 -0500
Date: Wed, 29 Jan 2014 13:56:03 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mike Turquette <mturquette@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] clk: changes for 3.14, part 2
Message-Id: <20140129135603.0e4ef75f701bff7f45ea8610@canb.auug.org.au>
In-Reply-To: <CA+55aFyXFJO_sMD+74F1sSmbxO-tKXGr-vetKYacUeLODBv-pw@mail.gmail.com>
References: <20140127214338.4167.57312@quantum>
	<CA+55aFyXFJO_sMD+74F1sSmbxO-tKXGr-vetKYacUeLODBv-pw@mail.gmail.com>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__29_Jan_2014_13_56_03_+1100_/Nfv3V/4cwDa63sN"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__29_Jan_2014_13_56_03_+1100_/Nfv3V/4cwDa63sN
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, 28 Jan 2014 18:44:31 -0800 Linus Torvalds <torvalds@linux-foundatio=
n.org> wrote:
>
> On Mon, Jan 27, 2014 at 1:43 PM, Mike Turquette <mturquette@linaro.org> w=
rote:
> >
> >   git://git.linaro.org/people/mike.turquette/linux.git tags/clk-for-lin=
us-3.14-part2
>=20
> I fixed it up in the merge, but I shouldn't need to. This should have
> been caught in -next, and even if you compile for ARM as your primary

Yes, it probably will be when I get to that tree today as those last 6
commits only hit here today.  :-(

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__29_Jan_2014_13_56_03_+1100_/Nfv3V/4cwDa63sN
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJS6G3IAAoJEMDTa8Ir7ZwVSCwP/0GuNBwtE2VNrwnZT/A1IO81
hvu/eBTERLk82plkjGPkNd8VHqAX2PbR3UbyIVC1O3V+c3G8F3tW5P1YiwKnYIH/
2RLmJ+WMmLsZ5cUCfHCt8F902RgbWJH8xv0OmjQ99PdVQH+v31jhIxo19c8yDdYw
ecYg/n9TZocUKZHRk/zUXid1udTNeNXhLfwF90V8hq9DGUneaDEVvzY/fo4FSh6w
HumYKEdPLuZsDMTDV09JBSna96vcaYuK3NZRsORcRRepNnApOmI0EMW/zJbBWnkF
+fh7AS4bqkMrNo3peZHpfdeOMCN2DxnUnrXZzNivJB8rO3CPDlAZrbSxPkKYFzN6
JBTd8aY2rvBSzRHbS/1D42y3xTZbrRchoKLZiawNJzivuxsWdyMYowgorG5aQkbB
rCm6Z5GEUPKI8xocvyqqGGCZpYFQArTwjIpJ8XZnDwbBHtH5HaeG9Az4dbdE8Uzm
j79KyrmkqkVIErq7On+V3/kBzKTtG9prv/UWJQMv3P5Hkc1iXtMBb1ux21OZrEOM
IJMSxM27E3th42S36tlyef939RBsaBy6C2d9wSNt0/3iJiqFIFMrTQf+WDiWAoHn
z3M1uFPpXpUy27LKcPaNXPYCNCr514hILh08bK46HgoIZlcNWjEupwD5NE0us/2b
JVlrfriek78Pcmblz033
=mGT6
-----END PGP SIGNATURE-----

--Signature=_Wed__29_Jan_2014_13_56_03_+1100_/Nfv3V/4cwDa63sN--

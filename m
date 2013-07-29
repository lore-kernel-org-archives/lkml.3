Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754784Ab3G2GsX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 02:48:23 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:42047 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752601Ab3G2GsW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 02:48:22 -0400
Date: Mon, 29 Jul 2013 16:48:20 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mark Brown <broonie@kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the spi tree
Message-Id: <20130729164820.38c47ee56d98d67debc77f97@canb.auug.org.au>
In-Reply-To: <20130729064028.GR9858@sirena.org.uk>
References: <20130729134223.bbae9d9f2a9cd6ca1717c976@canb.auug.org.au>
	<20130729050011.GJ9858@sirena.org.uk>
	<20130729155609.bb9d635427d8eef1da954e3a@canb.auug.org.au>
	<20130729064028.GR9858@sirena.org.uk>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__29_Jul_2013_16_48_20_+1000_mFCFC1U/L2D8V4Pd"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__29_Jul_2013_16_48_20_+1000_mFCFC1U/L2D8V4Pd
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Mark,

On Mon, 29 Jul 2013 07:40:28 +0100 Mark Brown <broonie@kernel.org> wrote:
>
> Yeah, unfortunately those issues are a good proportion of what gets
> caught by this sort of testing that wouldn't get caught in normal
> development so it doesn't seem worth doing something that won't at least
> give a linking kernel.

The problem is that you are impacting on other people's testing.  Even if
this stuff builds for me, it may well break for people using other
arches/configs.  These changes (adding dependencies on
CONFIG_COMPILE_TEST for devices that are currently only built for
particular platforms) are adding very little, but impacting on my time (at
least).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__29_Jul_2013_16_48_20_+1000_mFCFC1U/L2D8V4Pd
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJR9hA0AAoJEECxmPOUX5FErg8P/0c3decH0jiAAVkb5O05RbqJ
+ESyQ4f1C6Gx3nY7mt4Var6Byohjzk2yl6SA1zd1ncFRPb/Tkq9x6o6nm4v3BPwl
JsVJzSebOBwkyT4L8yXzADfCtmv0NbJjRxZCY1SWho/xWnsxTLM2QmpGJC+LREbp
DxxQcz0+gwj6kn2zUhMCmytXeR8YIuJZgc47WQe5Jt58yH/KNHb9JcCJQ6CnWX8P
vepjf4ZcYnYNbtF5QTqviEZeo0+EYlMM+koqRhdYst6x9Q1fXRjGNZZ+GJfI8iyQ
sdeGDjSuMCzLfmSE2CtcCq8dvolGXP/G9iQxX1HRVWhOjmGGTolflW0cGda64QHC
/ABuiOp01XMcAWuHKJeT0u3mQ0BVn9u/yfwQBawVBkUwPZGKO5RRdNg2a7ydn46B
9MJje1qbAfWdSaYS0a8X9bNWo51DiGQ2pwc0K2nstBUpCJxBVMPc7KfEauy7yKWV
GUwpC1fkEWzDjltVNMhuwc7AFxM7DbgOisMME/tuYs5Bl/O+bi0fwKBVk3kROugU
8EGfRAEUk9BE1fJtbPXaDSeB5XZGhyLrBPO1hSjAtQKiA8AcF5COH7Azds3PL2vL
hUhO5VrU3YtlOiYCtajiSuKJVnyUAOiZnLuSWdThrxUBQmgkleUsEJYszK/LZp+N
nLqYNgpP2VWL2RqhY9Db
=HzQV
-----END PGP SIGNATURE-----

--Signature=_Mon__29_Jul_2013_16_48_20_+1000_mFCFC1U/L2D8V4Pd--

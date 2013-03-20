Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753361Ab3CTWFc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 18:05:32 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:39417 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751348Ab3CTWFa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 18:05:30 -0400
Date: Thu, 21 Mar 2013 09:05:17 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-next <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ian Lartey <ian@slimlogic.co.uk>, Graeme Gregory <gg@slimlogic.co.uk>
Subject: Re: linux-next: build failure after merge of the final tree (gpio
 tree relatred)
Message-Id: <20130321090517.81475155bf48370157ceaafb@canb.auug.org.au>
In-Reply-To: <CACxGe6shQN=RgPF+TQvQmkBC7E6MsG6Vnisxtxeq3kWgh-XHXw@mail.gmail.com>
References: <20130306114452.a041ab0737783f9730c1486e@canb.auug.org.au>
	<CACxGe6sZKRjSnwa-CHC1OhJoGP-ZQe4H2YbMYjDjNYcSdSyuow@mail.gmail.com>
	<20130321022524.37baf9fedb1848cdbdfc0eef@canb.auug.org.au>
	<CACxGe6shQN=RgPF+TQvQmkBC7E6MsG6Vnisxtxeq3kWgh-XHXw@mail.gmail.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__21_Mar_2013_09_05_17_+1100_KjJXqV=jaGdDsd5j"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__21_Mar_2013_09_05_17_+1100_KjJXqV=jaGdDsd5j
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Grant,

On Wed, 20 Mar 2013 15:57:01 +0000 Grant Likely <grant.likely@secretlab.ca>=
 wrote:
>
> On Wed, Mar 20, 2013 at 3:25 PM, Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
> >
> > On Wed, 6 Mar 2013 09:10:42 +0800 Grant Likely <grant.likely@secretlab.=
ca> wrote:
> >>
> >> On Wed, Mar 6, 2013 at 8:44 AM, Stephen Rothwell <sfr@canb.auug.org.au=
> wrote:
> >> > Caused by commit 82d4d6637fdf ("gpio/palmas: add in GPIO support for
> >> > palmas charger").  I wonder if this was ever build tested. :-(
> >>
> >> Probably not. Looks like this driver doesn't get enabled without the
> >> associated option in MFD. I didn't go searching for it, so my build
> >> tests didn't catch it. I'll drop the patch from my tree. Sorry for the
> >> pain.
> >
> > I am still having to revert this commit ....  :-(
>=20
> Ugh, sorry. I reverted the patch while travelling, but never pushed
> out the fixed tree. Try it now.

Thanks.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__21_Mar_2013_09_05_17_+1100_KjJXqV=jaGdDsd5j
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRSjKdAAoJEECxmPOUX5FEfSsP/iCVMc1w9aw7MGI5Y6kvlxtA
a4h5eu6mlNWmYagOpwNOg4zg6sbXC1a8NX29IVgKa39QTOa4khBh85BFnvVU7Z0p
T8Og+MoY36467l9Qq2UaFdoqT1P/Ag6i6/7OUrRbnnWd/t53njnJWkgwBEItNfwy
3d/1aLKqZywh543Z2hlq/60tjiRvFMpIlgF7s9VcftqdpxSekrdVt+JR003k7iNO
3tGFSh76IotbjSHbNO2QfpGtVrDeckqNYMKEJUnz4IMN28SeIGS5FxRg8olKMgs+
rLJTKF/SFgbC/Rd6jkurAXS0U0t9Ckf9hIIPxJtOx648itZMA0TUnX2X/ig8SfkV
9Rqdufn/RuXfeJibUrx7QeFWncKT3SLR9uDjTexjQza47ljBrW5wbRiETJRVHO1k
sobQMZLILimUhOentqUZuz6r1P12N/kKldYmcFFn2V58nRA8/koeSe2Zs+D0MxZj
BdQBqH4jCLVviVAR8h0n7G5dlODdk5pCSYZ5aVcyf9qqRkOMZ8Bp6g+d0tV528c8
XPEOpIdFPZW9mqEW1zezF42kjpa8+fyi5pCwHYI7URq8xamfRRnp0MS+c4pGp6QI
yZYwTwWEbi9D3lsvSoXz7Cq9Lrk+4oo1tsH60P71VrZIakhn1K1SDCPOaxJQEo8P
XX0W5V2BDgx4QrdGFUZY
=TiMu
-----END PGP SIGNATURE-----

--Signature=_Thu__21_Mar_2013_09_05_17_+1100_KjJXqV=jaGdDsd5j--

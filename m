Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752183AbaHVWaU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 18:30:20 -0400
Received: from ozlabs.org ([103.22.144.67]:44574 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751882AbaHVWaS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 18:30:18 -0400
Date: Sat, 23 Aug 2014 08:30:09 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: Re: linux-next: build failure after merge of the pwm tree
Message-ID: <20140823083009.395b76ba@canb.auug.org.au>
In-Reply-To: <20140822221540.GC24037@mithrandir>
References: <20140823070737.371f09fb@canb.auug.org.au>
	<20140822220610.GB24037@mithrandir>
	<20140822221540.GC24037@mithrandir>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/MOGe435veQ=+x4MA_=C8=F9"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/MOGe435veQ=+x4MA_=C8=F9
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Thierry,

On Sat, 23 Aug 2014 00:15:54 +0200 Thierry Reding <thierry.reding@gmail.com=
> wrote:
>
> On Sat, Aug 23, 2014 at 12:06:16AM +0200, Thierry Reding wrote:
> >=20
> > Ugh, that's unfortunate. I have a set of scripts I use to build-test
> > before pushing, but I don't usually do full allyesconfig builds. It
> > seems like pwm-lpss.c might only be missing a linux/io.h include. It
> > will likely be Monday before I find the time to properly test and fix
> > this, do you want me to remove the commits from the pwm/for-next branch
> > so you don't have to revert it again?
>=20
> Just confirmed that adding a linux/io.h include fixes the build. Will
> push a fix in a minute.

The revert would have happened automatically, but if it is fixed I will
remove it, thanks.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/MOGe435veQ=+x4MA_=C8=F9
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJT98R2AAoJEMDTa8Ir7ZwVlkQP/iSTJqq6u2QKmyxanFkdKe/L
AcRM9Nc0puC4SlKaZrSMhsfKI80cC/+RQ+0Slr92qkZLaXPxh3FnXo7dYxQHd4EK
zmS+anS1sOIkEZzhafxRhMbIBMgm1678Y4FtDEdyceFfSiEBClp9N7OWehma3BrG
AZOWPeRAWXvguFJDKAAycZUG46KnUrNAb50ZYdexCOGPq/7idCVjI36dh5Ce8AIg
bpKj3VoHyo/N97pn2IIIZoymf5RuJU10CWgpio0hWsuLSwLVqQDTMVEOKU8r4fuE
xwuIYb0sA4arzmRDge9/duloqzOfPoQyonPOL2zi2oET1tswGUNhWh8oNXTSWrj5
k/LwGBATN7bKSnH1avs39huC+Z+XaWAJose7JJV1RcTSSPR4gDn8CF41A2XF4a2R
b5N+aojG+oNOvbqPGzUqv45sqsgHD5c0sx1MvGXMtb++1VEezrksyKqU+WsYNUeT
AoIhRsFd0GUJkL9OY9KofPogSdMaw8IoXT5z7bqeXrckXKdDntD1OyXITQouyTDf
p1GgQRrx7i/pEwntihJ0hrlI4o3yp1Ritnh1X29yhInF/J7OC4R3xVWJTZ5Ph+2y
x8nOL+ru4cb+hoN2eNV7zWmCJA6TpolanafvoQnH8yzUExnpdeeG/Ti1vKEz6Y92
JEOKTnTxSHQqtffmkd4z
=BsEz
-----END PGP SIGNATURE-----

--Sig_/MOGe435veQ=+x4MA_=C8=F9--

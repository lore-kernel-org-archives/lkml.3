Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935851Ab3BOOwM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 09:52:12 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:44033 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932635Ab3BOOwK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 09:52:10 -0500
Date: Sat, 16 Feb 2013 01:52:00 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Liu Jinsong <jinsong.liu@intel.com>
Subject: Re: linux-next: build failure after merge of the xen-two tree
Message-Id: <20130216015200.1e58bec1aff05592ac2ae98f@canb.auug.org.au>
In-Reply-To: <2185970.g9YrD945My@vostro.rjw.lan>
References: <20130215154551.d11e9d376d30d32b9673e6cc@canb.auug.org.au>
	<20130215132624.GB11777@phenom.dumpdata.com>
	<20130216005014.c8ce70e041f655d4c195c9fb@canb.auug.org.au>
	<2185970.g9YrD945My@vostro.rjw.lan>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Sat__16_Feb_2013_01_52_00_+1100_tOuoldo=vwq43dZD"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sat__16_Feb_2013_01_52_00_+1100_tOuoldo=vwq43dZD
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Rafael,

On Fri, 15 Feb 2013 15:53:34 +0100 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
>
> On Saturday, February 16, 2013 12:50:14 AM Stephen Rothwell wrote:
> >=20
> > On Fri, 15 Feb 2013 08:26:24 -0500 Konrad Rzeszutek Wilk <konrad.wilk@o=
racle.com> wrote:
> > >
> > > Thank you. I keep on forgetting - but would it be OK for me to take t=
his
> > > patch in my tree? Or should I not since this is a new functionality t=
hat
> > > Rafael is going to introduce in v3.9?
> >=20
> > It is an API change in the pm tree that is not yet in Linus' tree.
> >=20
> > > And if so, perhaps I should tack it on in my tree, once Rafael does a=
 git
> > > pull to Linus? Or just point Linus to this git commit?
> >=20
> > You should point Linus at this patch if the pm tree is merged first, or
> > Rafael should do the same if the reverse happens.
>=20
> Alternatively, Konrad can pull the acpi-scan branch containing the changes
> in question from my tree into his tree and rebase the new material on top
> of that.

Or pull the acpi-scan branch into his tree and use my conflict resolution
in the resulting merge thus requiring no rebasing.  However, Linus likes
to see such interactions, so it can be left up to when the latter of the
two tress is merged by Linus.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Sat__16_Feb_2013_01_52_00_+1100_tOuoldo=vwq43dZD
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRHkuQAAoJEECxmPOUX5FEN+QP/2HZo5F7cxoYEpdryG6K4H+r
WCxGdjZr9Aiozn8HMzrDOxmRAdhMG4gVteuyZg2uU2ThkYEz8Msk7QNX93E81b77
gXj1odcKU3ODmC5orgw3fwCcj52hK558T1ULTiZtxaPw1IqVQ0jEvyHQCWJYMT2l
c19281rjaaQscssakXlo7R2AwvxZ3L9vnZiJQ25kPaAUBw6HV83P/w0i1lHvBsSq
Mn7rM9y4nVCdX/b9DYrLu/KBEjeIT8KdZRH+cC5VrSXWA7ulMWOcoERIDR3tm7pk
YMwTUOWW/1fubBB1eX6VgDD5eVbZZNI02Fp8MCOW3Esl5YypuVQpWU4c6qfomcyh
DfpERSdnZDjr9qkfSHiqTd/vbZNwi5IxCWJwqgQdKaUnGuYNtiH0NX/uOc2G7SQI
tyXnnEYocLQriXx65JRpxCn3sWs3nO4JsgqOgMvqv9mrIhg+f8A4yRtld9gwnbMP
178lGo6hIvCbH2sOz4u3ToCTvIoLvyMNij/RRjuzwgMdvuU4yL11zoHob68hEFbG
ztGVXbAkQ820FDvGUIpCKU5kaT+YLIWb9b3AA9qk5sPDp94EwR0k7oZxfWL3oyrd
xkm6Y/Av0f4FXFCqvmEmQB1vPGfQCUJwsDoPslXfmI2iqbZHY1J9JOEXxq8FJTcn
+9p968UnxRUEsfAWble4
=2CfF
-----END PGP SIGNATURE-----

--Signature=_Sat__16_Feb_2013_01_52_00_+1100_tOuoldo=vwq43dZD--

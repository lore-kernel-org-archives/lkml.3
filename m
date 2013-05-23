Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757144Ab3EWAcf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 20:32:35 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:37878 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755071Ab3EWAcd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 20:32:33 -0400
Date: Thu, 23 May 2013 10:32:22 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Igor Mammedov <imammedo@redhat.com>
Cc: Greg KH <greg@kroah.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        linux-kernel@vger.kernel.org, linux-next@vger.kernel.org
Subject: Re: [PATCH linux-next] Driver core: cpu: remove not needed anymore
 hotplugable_cpu_attr_groups[]
Message-Id: <20130523103222.39a4bdd8240aa25d1086293d@canb.auug.org.au>
In-Reply-To: <1369230812-27375-1-git-send-email-imammedo@redhat.com>
References: <20130522140213.eb65bcc559088b199db1857f@canb.auug.org.au>
	<1369230812-27375-1-git-send-email-imammedo@redhat.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.18; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__23_May_2013_10_32_22_+1000_doXRP6FVdoKa=H5+"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__23_May_2013_10_32_22_+1000_doXRP6FVdoKa=H5+
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Igor,

On Wed, 22 May 2013 15:53:32 +0200 Igor Mammedov <imammedo@redhat.com> wrot=
e:
>
> after fixing conflict between
> 0902a9044 "Driver core: Use generic offline/online
> for CPU offline/online"
>=20
> and
>=20
> 1c4e2d70a "cpu: make sure that cpu/online file created
> before KOBJ_ADD is emitted"
>=20
> there was left some not needed remnants of the last
> commit, remove them since the first commit does the
> same thing in another way.
>=20
> Signed-off-by: Igor Mammedov <imammedo@redhat.com>

I have integrated this into my merge resolution, thanks.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__23_May_2013_10_32_22_+1000_doXRP6FVdoKa=H5+
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJRnWOaAAoJEECxmPOUX5FEEJoP/iiln4B4Y1eKxt1XO0Jf5fQI
7+Qv+rL98zAF5QFwzxgwNA4Tf2Ih0yVw9tHaRoOCKxwUKrToOYiHcGkO3YWB6gZX
SGxOhcOiTp74kw2ri2OLOty2NEoZ0TAEGJXER1JCLdDr/ydDVSuSXiuUvf0lpcUN
T1SesJDzdpmW6dnms2fF5wUCzYqlQIDVtQA/797NRPTqvjh0lO8UqC4KTSMpGr3K
xTXUePKwk5imxxgjEblXKyoU3mIsLreZcPGRNcZz/dAV3SqUsgD4C/zwTE8N6Usw
QxdTGAFyEZABkjmk5WcsCisfXDAJAvp46+5QO3EtBRexpC9s1MOowO+MCnUoiZtG
P5fIm7BpsFxaG1AMD3AVoHPNNsZcIuXzhQmtmbcMFW+JRwlQ/hij8/ae0Y/JPyFz
2T7BzgLGb3axL90HTq9+IsUiPFeJ8IwOoQ5aRFsKQF2a7wk2Rr8ZFoElhxVmAwU9
jyOQQwab6hjk6Dqk0DMRpK55pT1NYKxys3oGxPqW2h2og9ymXCxJUzrwzHDHqP4C
FifL8QNqvIPc9Bh0UzTTxysN2vCS6LofhUkPTOJw8NOuGANSp3xM/86F6rWM1tFm
oZrZ83uxXk286I9Lx37rgW0R5rS9QY2GZ0YzDkRx5ExCV+//xL2lvkw2jPQShPqe
Dn0bErYpn9s4C2ZSD26I
=rhBp
-----END PGP SIGNATURE-----

--Signature=_Thu__23_May_2013_10_32_22_+1000_doXRP6FVdoKa=H5+--

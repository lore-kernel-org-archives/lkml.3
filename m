Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754510AbaB0ClG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 21:41:06 -0500
Received: from ozlabs.org ([203.10.76.45]:41631 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754393AbaB0ClD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 21:41:03 -0500
Date: Thu, 27 Feb 2014 13:40:57 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Josh Triplett <josh@joshtriplett.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the final tree
 (akpm-current tree related)
Message-Id: <20140227134057.6492e7e2bcbb592f71bef8d5@canb.auug.org.au>
In-Reply-To: <20140227022128.GB23659@thin>
References: <20140226191627.9adf3c8e1548e2016c16557c@canb.auug.org.au>
	<20140226100234.GA23064@thin>
	<20140227100026.1cc909f2722b16b6d11a7b91@canb.auug.org.au>
	<20140227022128.GB23659@thin>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__27_Feb_2014_13_40_57_+1100_KA2e/wG2MF3Gigtr"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__27_Feb_2014_13_40_57_+1100_KA2e/wG2MF3Gigtr
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Josh,

On Wed, 26 Feb 2014 18:21:29 -0800 Josh Triplett <josh@joshtriplett.org> wr=
ote:
>
> On Thu, Feb 27, 2014 at 10:00:26AM +1100, Stephen Rothwell wrote:
> > Please check the build results overnight tonight (for next-20140227 at
> > http://kisskb.ellerman.id.au/linux-next) and submit any more fixes for
> > the allnoconfig build errors.
>=20
> Checking that site, I don't see any other instances of failures caused
> by allnoconfig.  If I'm missing some, could you please point me to the
> page on that site I'm missing?

That is because your patch was reverted in yesterday's (next-20140226)
linux-next.  You will need to look tomorrow (next-20140227) sometime.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__27_Feb_2014_13_40_57_+1100_KA2e/wG2MF3Gigtr
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTDqW9AAoJEMDTa8Ir7ZwV2NkP/AmwI3jwVfpVvjkEK5DmAc8Q
bGSVX+wCTkC6gyxXm/3wyHei8Fufl23OirshipZt9c2fVo+o8az72UOdz+sBzN3m
eateVOejXhd2QSYI/Z0YQFDhjOXd6HCQ46t+aX/AI31AWDwe1T2cyiNfSBEnewYw
8SvM0+ZwCmJOj9khzRoadnIXI1xkzhC72fDp+VCOuAhvJ+oEbI4RksQt/Inc5hq5
dkALy2Wj2JpMIry6+l2jMk1ICFN0t60Zk6PD4QH9uo4lD6rAbIILn8mEDjnsduYY
t26M77CNWCc4gGEoHSdT0RLH1g6Q++KL1h5Vy26KDR7teL3aFGZ8MPe4cAIzR1Zg
LBlrdwwP/7n6F3Sa57GJoBEt17SkOCWos+8WrKwnCjilXz3XfuTd58SSq+SUdur4
e6ioFRmAFEqKv9wT1/rdC9KJHoU/NOoHSC+sIo3T1zZGu7wszgTCnesJPxTmgRNg
zJU8Lc+Hpnv3j9X7cP5OsOc2bkf7kGT6iJetfVzy/ev3q6V2z50+ABnOesDOmb8v
TBw6rXvS1YCA0jciV9S2oZk+3aUmhJliioeF3XtIHXFmHp301a8jf8XROjVgkOqV
p3GSxqQ2EiTcKoXPtqPdCYFpYNYL1M8P4KEhld0aLw3EVj+J1epV+T1grR9k5ycO
jAM35WZZEMzXP351Ssyd
=LP1A
-----END PGP SIGNATURE-----

--Signature=_Thu__27_Feb_2014_13_40_57_+1100_KA2e/wG2MF3Gigtr--

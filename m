Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754670Ab3H3Iz7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 04:55:59 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:56772 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753651Ab3H3Iz5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 04:55:57 -0400
Date: Fri, 30 Aug 2013 18:55:46 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Ingo Molnar <mingo@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: Re: linux-next: build warning after merge of the tip tree
Message-Id: <20130830185546.69a289c2bef2173cc1ededf4@canb.auug.org.au>
In-Reply-To: <20130820064209.GB9518@gmail.com>
References: <20130819142633.82fb06bfa3bc0276fb09cbea@canb.auug.org.au>
	<20130819065817.GB23742@gmail.com>
	<20130820005234.GX19750@two.firstfloor.org>
	<20130820064209.GB9518@gmail.com>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__30_Aug_2013_18_55_46_+1000_a0fguXyJr.tb2=c2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__30_Aug_2013_18_55_46_+1000_a0fguXyJr.tb2=c2
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

On Tue, 20 Aug 2013 08:42:09 +0200 Ingo Molnar <mingo@kernel.org> wrote:
>
> * Andi Kleen <andi@firstfloor.org> wrote:
>=20
> > > > Introduced by commit 9a55fdbe941e ("x86, asmlinkage, paravirt: Add
> > > > __visible/asmlinkage to xen paravirt ops").  The 2 definitions used=
 to be
> > > > identical ... maybe there should be only one.
> > >=20
> > > Andi, please send a fix for this build warning, against=20
> > > tip:x86/asmlinkage.
> >=20
> > I resent the patch. Thanks for the headsup.
>=20
> I suspect hpa missed it because the patch was opaque and=20
> non-descriptive: the title talks about a 'warning' that is=20
> supposedly fixed but the changelog does not explain what=20
> warning it is and why the change matters.
>=20
> Please use the customary changelog style we use in the=20
> kernel:
>=20
>   " Current code does (A), this has a problem when (B).
>     We can improve this doing (C), because (D)."
>=20
> I've seen this pattern of deficient changelogs a dozen=20
> times in your patches this year alone ...

Ping?

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__30_Aug_2013_18_55_46_+1000_a0fguXyJr.tb2=c2
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJSIF4WAAoJEECxmPOUX5FE0wgP/1pdTFAe+sVoGnxbwkqvqcPk
MFRCVqYQcyp26ago7b9nstVL+vOL2UpXOMAMnv8Sgs9X2RY0SaYrgMJeHio15hTJ
8Pk73d7ry8mzmHc8az7OPPbbngw1GeMh+WKEgv/bsO5aLOjKDrw8+hVoMwn8bl8P
cUkytMm5tCPSBXSMCEVqrnJOf/X2rBmPpnunWgDGvusRsMy10VM7meWMMsxxB9pr
xQjzKeiY4HxHe1R087+MQ03K1bd/ZDFhp0Cawjdce6EX6F+8bjFcjO++l8Ut+uia
xHvzQO2UHr844VHFqJjk1RJ+4AZff0RcTvnrGRk+2KclKs6q9mUUCdIZqThGneFW
2dNAiivZEg0Q31/Nv+S0SKIvciHcEiIkRns3VioUF3Cd8RbTniDxJRskUlGW0DXR
DqlOXU5cSqNzAfOG3OyHSeN2rAC5ywNtrF4P6L5uNV0gzOk4cSXtkMwg1OrYt1Gz
jAJpzXfz8cY4n3KHT6osShMRFI3ttpuYVmBAWNfdPK6T51491d20Cd+Aam5At7Ar
64fMGAPoZ0EF26dFSmfjOo2BzZ0V6NQI/bF1ZmHbdQ47+gVgTiu+sTFtk1Nv9OzU
PXD4SVwYqx3233FD0MEke3UlbHahDQeWCX5c/R6/G/Hj+Pc6Vv2EOSw/hApRA3iP
s2/kpxzP8H0t5pAMsdSr
=yMIG
-----END PGP SIGNATURE-----

--Signature=_Fri__30_Aug_2013_18_55_46_+1000_a0fguXyJr.tb2=c2--

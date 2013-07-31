Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759139Ab3GaHXU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 03:23:20 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:35272 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758847Ab3GaHXS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 03:23:18 -0400
Date: Wed, 31 Jul 2013 17:23:14 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, xen-devel@lists.xensource.com,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        david.vrabel@citrix.com, boris.ostrovsky@oracle.com,
        linux-kernel@vger.kernel.org, linux-next@vger.kernel.org
Subject: Re: Replace in linux-next the xen, xen-two, xen-arm with
 xen/tip.git tree instead.
Message-Id: <20130731172314.da8bcd6788eaa944a32fc268@canb.auug.org.au>
In-Reply-To: <20130730195316.GA12124@phenom.dumpdata.com>
References: <20130730195316.GA12124@phenom.dumpdata.com>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__31_Jul_2013_17_23_14_+1000_zY3BJZgwq9NuiIZC"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__31_Jul_2013_17_23_14_+1000_zY3BJZgwq9NuiIZC
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Konrad,

On Tue, 30 Jul 2013 15:53:16 -0400 Konrad Rzeszutek Wilk <konrad.wilk@oracl=
e.com> wrote:
>
> I was wondering if it would be possible to remove from linux-next
> the three xen trees and instead use a combined tree, similar to the
> x86 tip (so the various maintainers share it)?
>=20
> The ones that would be removed are:
>=20
> xen		git	git://git.kernel.org/pub/scm/linux/kernel/git/jeremy/xen.git#ups=
tream/xen
> xen-two		git	git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git=
#linux-next
> xen-arm		git	git://git.kernel.org/pub/scm/linux/kernel/git/sstabellini/xe=
n.git#linux-next
>=20
> And instead it would be pulled from:
>=20
> xen-tip		git	git://git.kernel.org/pub/scm/linux/kernel/git/xen/tip.git#li=
nux-next
>=20
> I presume you need Ack's from all of us (so Jeremy and Stefano) so CC-ing=
 them here.

I have replaced the xen and xen-two trees with the xen-tip tree today.  I
will remove the xen-arm tree when I hear from Stefano (as that tree has a
commit that is not in xen-tip currently).

The contacts for xen-tip are the contact for both those trees above
(Jeremy Fitzhardinge <jeremy@goop.org>, Xen Devel
<Xen-devel@lists.xensource.com>, Konrad Rzeszutek Wilk
<konrad.wilk@oracle.com>).  And I will add Stefano Stabellini
<stefano.stabellini@eu.citrix.com> when I remove the xen-arm tree.

Let me know if you want changes.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__31_Jul_2013_17_23_14_+1000_zY3BJZgwq9NuiIZC
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJR+LtiAAoJEECxmPOUX5FEmuwP/1v1PLrVbtKDHN5EfmPFS9gZ
+A4ZimFGat0050t7yxD2qmGPp3FfKdZa6zNqLtA8q9BLPnv8alNHTXHHqZKYcF6w
3PTU+EIJ+ZGvCJ7HKWwEsKcmZt20TShaHf54D/RpB7Nm9oIua5vMKh3zCN+EUyFO
EWQ0jLrT+00VWn5DOgQpzzk1iKKKeBnqyO/4RFMgrpDUsNhVc3jgK/Gnu++QW5wU
ikcxQA6IfMpZoP1BHn1UsCeamTjHcu293EWH58e7q0z/82XOnMeZkr359XEHTQSs
m4khcAcrgu1Ps2G5A6LOqygzaP3OR8Zth2B4YDk8JXIYE7ydT92GM0FZvZ5v4btP
bpHx8JRqaurYStUINa7fjTKkbfMAwCYE0PrIq5YUb21rrUC2hlN0yzm5TWG2B2KT
tIN0qUQqPEebEgQUg6GbaDUxI8dKNkhaG7xHjQSLFhQ7xhCNIETHBKEjtuYooz7C
sxsHCzKqY6dtfHTRgp2FFRchYStn5J9nqWbpbb/MOpcEJCkw7MX2MlngMbwxzSqo
v4rnkCV43e6pwaXABpMwmvIpQPVqAdR4238S83n7dPdA4B0au8fza3Rj5u9Evgd4
cPwOBzzlFAvCGzpQGxi3is0BNmiwEdt5izvTgvLNfK/m4WoMX0sieeUZ2OH7AvD0
Ik0zHtzpiDx0iBLVL1Zb
=gagu
-----END PGP SIGNATURE-----

--Signature=_Wed__31_Jul_2013_17_23_14_+1000_zY3BJZgwq9NuiIZC--

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759724Ab3DZDu0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 23:50:26 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:35478 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755892Ab3DZDuY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 23:50:24 -0400
Date: Fri, 26 Apr 2013 13:50:20 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>
Cc: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Roland Dreier <roland@kernel.org>, linux-rdma@vger.kernel.org,
        Vipul Pandya <vipul@chelsio.com>
Subject: Re: linux-next: manual merge of the net-next tree with the
 infiniband tree
Message-Id: <20130426135020.1f504f56b6c3412201f4fb9d@canb.auug.org.au>
In-Reply-To: <20130424175304.GA701@oc0268524204.ibm.com>
References: <20130418131843.bfeb6b1ad5fba1b0f706076e@canb.auug.org.au>
	<20130424175304.GA701@oc0268524204.ibm.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__26_Apr_2013_13_50_20_+1000_zlQAPrdRZwOHWPGC"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__26_Apr_2013_13_50_20_+1000_zlQAPrdRZwOHWPGC
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Cascardo,

On Wed, 24 Apr 2013 14:53:04 -0300 Thadeu Lima de Souza Cascardo <cascardo@=
linux.vnet.ibm.com> wrote:
>
> On Thu, Apr 18, 2013 at 01:18:43PM +1000, Stephen Rothwell wrote:
> >=20
> > Today's linux-next merge of the net-next tree got a conflict in
> > drivers/infiniband/hw/cxgb4/qp.c between commit 5b0c275926b8
> > ("RDMA/cxgb4: Fix SQ allocation when on-chip SQ is disabled") from the
> > infiniband tree and commit 9919d5bd01b9 ("RDMA/cxgb4: Fix onchip queue
> > support for T5") from the net-next tree.
> >=20
> > I think that they are 2 different fixes for the same problem, so I just
> > used the net-next version and can carry the fix as necessary (no action
> > is required).
>=20
> Commit 5b0c275926b8 also keeps the intention of the original patch which
> broke it, which was to return an error code, in case the allocation fails.
> Commit 9919d5bd01b9 fix will return 0 in case the allocation fails.
>=20
> We should keep the other fix or fix the code again to return the proper
> error code.

OK, so today I switched the conflict fix to use the version from the
infiniband tree.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__26_Apr_2013_13_50_20_+1000_zlQAPrdRZwOHWPGC
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRefl8AAoJEECxmPOUX5FElWYP/0gd5bzIlZAhq1HBEAp4Sv6n
7OfvDC/0brGRrfRPg7flwVEuzftUmTkFjtQHmntYvw+omke6/Bc55z9u13Z0CnFu
QYJv2YYgjKiZ4MtXiyZ7yYg/Y4ppIXMalbzTZ3VTx4InXkoDTZUjBd3wghHrD+lP
eghwlvH2ar2Z6XyKP300fbOGWJLIk+klC8Cr42W/s6DxMgBVUa42vovLo/2XDuNT
YEoOEGOiEcDHB5sOaFKoKTFQJoxR+J/bbpDDRzfUVMubXiZEvtxmQs1FMDpCBkBD
o3FGlCYwXqb/Lmxh1lzoSQb538vQrg4XfyDUGU/1eRuRy0aBYIYaq5jVLHfsmNvt
eHQf9TOUEV/mtJmUyF546UUEp/TNafbVqWdLIHxw2irr/oPC04oCJTx2Sy+lfgju
k5CRXzZB55NY6+G9qzCUn7UnrFz8Tm0cwHBm38f84LE2U+HuYP15KsurDJfAXNb2
VCeMk7tSPbldFsSeBov5NUpPz0qGHsw13hgBFySdhY9vmsAAMIPR88dudwyiVLWS
0QENerBIbcNqDevZnZaQK6l1B8avOzlJOjwzJaQP7YolDhkxxlYdJ15kcHUEtBNY
XCc3mYlbz//kUnQsQjSWw1MM3AE8STMCjSJbAkWEIWtUqMANaS5cuSVsNt03qMjy
SgivZhqJsoMhC/1/HCBj
=25rY
-----END PGP SIGNATURE-----

--Signature=_Fri__26_Apr_2013_13_50_20_+1000_zlQAPrdRZwOHWPGC--

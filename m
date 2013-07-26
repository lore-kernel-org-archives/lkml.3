Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757502Ab3GZHjL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 03:39:11 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:51456 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756515Ab3GZHi6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 03:38:58 -0400
Date: Fri, 26 Jul 2013 17:38:49 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Quigley <merlin@countercultured.net>
Cc: Eric Paris <eparis@redhat.com>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Quigley <dpquigl@davequigley.com>,
        "Matthew N. Dodd" <Matthew.Dodd@sparta.com>,
        Miguel Rodel Felipe <Rodel_FM@dsi.a-star.edu.sg>,
        Phua Eu Gene <PHUA_Eu_Gene@dsi.a-star.edu.sg>,
        Khin Mi Mi Aung <Mi_Mi_AUNG@dsi.a-star.edu.sg>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: Re: linux-next: manual merge of the selinux tree with Linus' tree
Message-Id: <20130726173849.4dabf5c94991228efa0bf03b@canb.auug.org.au>
In-Reply-To: <06EC4DE7-7DC5-4C80-BA1D-2A96527CA7BF@countercultured.net>
References: <20130726134823.e4c0a1b7bad087c12b3ce782@canb.auug.org.au>
	<06EC4DE7-7DC5-4C80-BA1D-2A96527CA7BF@countercultured.net>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__26_Jul_2013_17_38_49_+1000_nM1yr97zIma+S1Tr"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__26_Jul_2013_17_38_49_+1000_nM1yr97zIma+S1Tr
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi David,

On Thu, 25 Jul 2013 21:22:48 -0700 David Quigley <merlin@countercultured.ne=
t> wrote:
>
> I guess my signed off got stripped somewhere. Originally I maintained tho=
se commits but Steve Dickson from red hat picked them up and they then made=
 it into trond's tree and then into Linus'.
>=20
> I unfortunately don't have my davequigley.com identities on my iPhone
> but you can add a sign off by dpquigl@davequigley.com for the commit.

Noone can, it is set in stone in Linus' tree, now.  My comment was just a
heads up that something went wrong in the process.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__26_Jul_2013_17_38_49_+1000_nM1yr97zIma+S1Tr
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJR8ieNAAoJEECxmPOUX5FECQYQAI5ZyyA8ba1B7Aolxk2y6JMP
Dy5FAe27Jgj/TK8sThUsxNyDzWQtmecLqQdD8AfJX4pmlK5eGP5s5K8g5bhlx2Q3
9Fxs55PgbKRI/vrabzzLVp93371gGRXgU4mxG24kSzg+JraFOg9Yh47mCAbXrsGg
Ao4do5at6TE2SfxAFhaCc7mC2cU4wCrPukykBlSF2J62t7XV1t80SyszPtAG6PFQ
CnBDFOd0v7ePxJJT7exrD4h8FaNq9M9oPDpy5IprEkdCaZBf1/h3anU/oiXjb/0f
rU08OKqOh+eHa8CnI+F12Jh2TNPkwTSSDSzVn1KmbrzPRsDcCcpu0Wbme0PH1mWe
Cta1GG5cE+CrXTqJSSFA8sdnk9gmF3mzOnYMeSXzwaPzySSty0UFWXHF49B1V3lL
kSKGZdPE2e/cJZW8fdxlj5nTJREZPsjNqpnRda/imUpS5JzUp81CP95HWyL7YpjA
HKBrX3IxVKpuX2Icfy66vc+NEXeVncBdYL3Tb6UJChJIxFdVrRa3Fgk2FtDUKsBV
QTQOloFrBdbQb8zxUqkuYTMWkr5Uso640pL6YA4gktHh39SiAcTNi8Xn8kmfUqcs
bAZIKFBWHu3RKJbTW7TPbYqtiNooqBoLSntgX7Qf3oopLiuT7AuZjhiOXFLj8dAI
EbrEPfDBklBj7eXMb03x
=a8qC
-----END PGP SIGNATURE-----

--Signature=_Fri__26_Jul_2013_17_38_49_+1000_nM1yr97zIma+S1Tr--

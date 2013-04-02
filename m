Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759649Ab3DBCFr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 22:05:47 -0400
Received: from mga02.intel.com ([134.134.136.20]:39222 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758774Ab3DBCFp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 22:05:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,390,1363158000"; 
   d="asc'?scan'208";a="287964920"
Date: Tue, 2 Apr 2013 07:08:26 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the slave-dma tree
Message-ID: <20130402013826.GK10326@intel.com>
References: <20130402125711.02c750493475fc6a119ef3d8@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GyRA7555PLgSTuth"
Content-Disposition: inline
In-Reply-To: <20130402125711.02c750493475fc6a119ef3d8@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--GyRA7555PLgSTuth
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 02, 2013 at 12:57:11PM +1100, Stephen Rothwell wrote:
> Hi Vinod,
>=20
> After merging the slave-dma tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
>=20
> In file included from include/linux/netdevice.h:38:0,
>                  from arch/x86/net/bpf_jit_comp.c:12:
> include/linux/dmaengine.h:973:1: error: expected identifier or '(' before=
 '>>' token
>=20
> And many, many more :-(
>=20
> Caused by commit 896b29f155cf ("Merge branch 'for-linus' into next").
>=20
> Please at least build test your tree *before* publishing it :-(
Sorry, I had fixed it up early today but looks like have push didnt happen.
Its pushed now

>=20
> I have used the slave-dma tree from next-20130328 for today.
> --=20
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au



--GyRA7555PLgSTuth
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJRWjaSAAoJEHwUBw8lI4NH3MMP/ArI80+Ad3Wp3wUUsfaZH2zk
VGL9p2TAzHV/DFkgtTKpfVQYC/g8s8G3fjwm1Go2U7HrFyW+WnwjZW7KzxoRB2ho
KTj4sM9nhHPmGCYP4gDGPeTVuDwQGJ/VkW8QvAAaAp11RfAEQ82PV/OMQ3OgwKSE
SU1l69ej7+lofkj02IHRNBEtbCN9unESY3jWRBOikIzxFvmtACLJ7ry+LytoDVIP
BQfCaSiLvUya54RG99yN6iQRkt0pH3TZmCLv8upwhKmM3V9HFxXkQz+SBZqPP5Po
f+eO1+cexK137jgTQbbzhw7ugGtrRBDle1I4BIPFOpbPqaTkRtB8kTNlw3Vtx6NS
cfBq95//nBOMzjJcx/TUHnSjuN16O0Eg2bNCkvCRLlKviRagC2dI3e9qmCfRFjoI
hfLCyFxIwpUqVd+5dL1vqsI907SYpQYxjejGHJjOy3VwhIauckkvuae5pe948oux
XCBrB/mdYWME0xv7C/+lAYjy8joZd4UjzlpzJ4ZBICsxaZ289g/xCHuDEAjMgUeh
02iUD9NWFuj8wIeAL8QRiCfrWlGvn/UQgL/aRqYOR38GypEbuiP2xV9TARNelkOv
SdyVsNWDHYgUDhcNdVbGXba6vX1uOZXL4h+obLBgi1MsLffPr22IiSKEAkR4JVCB
vMp2CujddpYpPvQ+gJ9L
=tlt4
-----END PGP SIGNATURE-----

--GyRA7555PLgSTuth--

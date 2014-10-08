Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756566AbaJHNhM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 09:37:12 -0400
Received: from ozlabs.org ([103.22.144.67]:40221 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753159AbaJHNhK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 09:37:10 -0400
Date: Thu, 9 Oct 2014 00:36:55 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dan Williams <dan.j.williams@intel.com>
Cc: "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Miller <davem@davemloft.net>, Vinod Koul <vinod.koul@intel.com>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] dmaengine-3.17, close my dmaengine tree
Message-ID: <20141009003655.5489501a@canb.auug.org.au>
In-Reply-To: <1411922704.3156.40.camel@dwillia2-mobl2.amr.corp.intel.com>
References: <1411922704.3156.40.camel@dwillia2-mobl2.amr.corp.intel.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/wB7uWC=j12.Gc4=u6tp6JC5"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/wB7uWC=j12.Gc4=u6tp6JC5
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Dan,

On Sun, 28 Sep 2014 09:45:04 -0700 Dan Williams <dan.j.williams@intel.com> =
wrote:
>
> Stephen: please remove the dmaengine tree from -next:

I have done that now that Linus has merged it.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/wB7uWC=j12.Gc4=u6tp6JC5
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUNT4DAAoJEMDTa8Ir7ZwV3/UP/1ekMQKQjNAWcU2ZXzItdyCA
tPD4wctqBYM3wO7IN3LA0nua7eKDaFUtOh4Ui91RaoONaYLzIfNQ0W3rQMTwBvFj
Koqb0VWmcJgJ6Y2pL6gxDm59nb1U4cfyBX5Bxbj3rAX6yPWPMfMAy8sipqF9uQ4i
ugciIKD04jEMViDAb4yxFlmN1C2iYCnhWJrhiMSdM+XHfR6D7emvmSVDak5Iou3P
90FDB1oG6oimtQ92xgv2kaoAeGzhpzXS5iSo2XQmIQJTAFqIqGkNstFWTzM6J6QP
ES9jHApz8kGba7X6X/qzzJ3qD15kH04NDHUNInl+fp3msiXQ7QQRH82cHiwADtC0
KIVpRS0cLmQE6E2652wqi3UP045ZH6c+CfUrWw19OBQ18FGZg9BG00F78+OY51Oq
zxUez70ZCMe0fxPib94IfOFx+CJX3MVU1RI3IT1zhD5S1OO6rgZZqOv5Rv5gsQn5
RcYVt+CbAtJS+byWA0hCrddAkhv4m/dRarB2rx53kxA3O7jfLVTxIfGicThiChtH
O88xQkZnuLvALsG7vAgKV7XOcLUNG+Z8cOpqKFek6D7rse8RTHC5t9AnHcBqC5k+
OsbDAfvBfhlPWQl8Q8hGniOveUEHhP7gIt/p5YhZex4Ph8zEiVgw/mgk7HcwpqCS
+RzSSggnEXrAcOTOjR+a
=fDEa
-----END PGP SIGNATURE-----

--Sig_/wB7uWC=j12.Gc4=u6tp6JC5--

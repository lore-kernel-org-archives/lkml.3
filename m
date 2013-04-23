Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757251Ab3DWSaq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 14:30:46 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:52655 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757230Ab3DWSao (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 14:30:44 -0400
Date: Tue, 23 Apr 2013 19:30:42 +0100
From: Mark Brown <broonie@kernel.org>
To: Wenyou Yang <wenyou.yang@atmel.com>
Cc: linux-arm-kernel@lists.infradead.org, grant.likely@secretlab.ca,
        richard.genoud@gmail.com, plagnioj@jcrosoft.com,
        nicolas.ferre@atmel.com, JM.Lin@atmel.com,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 2/8] spi/spi-atmel: add flag to controller data for
 lock operations
Message-ID: <20130423183042.GW5019@opensource.wolfsonmicro.com>
References: <1364968581-23700-1-git-send-email-wenyou.yang@atmel.com>
 <1364968716-23848-1-git-send-email-wenyou.yang@atmel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PyWBHxIrsGpYNMFw"
Content-Disposition: inline
In-Reply-To: <1364968716-23848-1-git-send-email-wenyou.yang@atmel.com>
X-Cookie: Caution: Keep out of reach of children.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--PyWBHxIrsGpYNMFw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 03, 2013 at 01:58:36PM +0800, Wenyou Yang wrote:
> From: Nicolas Ferre <nicolas.ferre@atmel.com>
>=20
> Will allow to drop the lock during DMA operations.

Applied, thanks.

--PyWBHxIrsGpYNMFw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRdtNLAAoJELSic+t+oim9r6UP/2k+VlZB39nSmiGYpMlRZUug
TL/vGa+PB0TMhCxWC0qmvdRN/1JoTnt5uEYmCV/pPkcrUftLsY0+PIVSQr/E4BzW
YnVCrm0xzhhH4DYGEeO47IZPphhnmOnoJyrhGpgTVd/+RjbpopAIPe1jelIkFskG
qvSsycpV7P2sOo2FAiKWL31QtNN1rggiA13fKr3HBa4TnlvfkKTPYOSU+63gxhCs
s44wmbRDcHw6VUj78wC9dbcTYCjB7Z6yxe25SMChwx2pMFLLgFdUBI+UKWiUk8i4
6PaPbgC7QukAx73+M/6OgHQc76ymb28NrJp6sCmL4AbwOS7agdsVCaNaD6JXFI0T
Wi4s5MDpHhkyEgR0d5fTiYUqZ1Kp7aO16w/cqgyoiyZGhzNe54gcI/vafyd9eUPL
KTKKIgpYfzshrtgy+HPozZegNwiYjnlO/ldtvnXpMszVVfAD4tEVigk600H51xHj
uvl4CNON0sUIoqLi6hIBa+3TeQsb5y1t0CLccbisGxy1npcsQFCN0Uhg1dpydkrN
r6aMhuANeNnrdn1dIXdmBJtNNB2LZkuq5eBaUcYgBQH8Uu8hcBeOQPagTxiXPVkI
r4hyHjxaxGaYJUv+iEHYgj3ZC5XUnQD2ufVIy0VMkzqrteQfj+aMTSd0gmTG3y6Z
Yf6wPAyGXMJfEXWxdEfb
=zu89
-----END PGP SIGNATURE-----

--PyWBHxIrsGpYNMFw--

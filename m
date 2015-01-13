Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752131AbbAMMIS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 07:08:18 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:54820 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751485AbbAMMIR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 07:08:17 -0500
Date: Tue, 13 Jan 2015 12:07:51 +0000
From: Mark Brown <broonie@kernel.org>
To: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Vinod Koul <vinod.koul@intel.com>
Cc: kernel-build-reports@lists.linaro.org, linaro-kernel@lists.linaro.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Message-ID: <20150113120751.GQ4160@sirena.org.uk>
References: <E1YAwSG-0000zm-Cs@debutante>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="Bi+HF1AHjw0mn3zx"
Content-Disposition: inline
In-Reply-To: <E1YAwSG-0000zm-Cs@debutante>
X-Cookie: Keep out of reach of children.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: -next build failures in k3dma.c
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Bi+HF1AHjw0mn3zx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jan 13, 2015 at 08:04:00AM +0000, Build bot for Mark Brown wrote:

> 	arm-allmodconfig
> ../drivers/dma/k3dma.c:823:12: error: conflicting types for 'k3_dma_resume'

For several days now k3dma.c has been failing to build in an ARM
allmodconfig because the definition of k3_dma_resume() introduced in
db08425ebd51f (dmaengine: k3: Split device_control) taking a struct
dma_chan * conflicts with that which has been in the file since it was
originally merged taking a struct device *.

--Bi+HF1AHjw0mn3zx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJUtQqWAAoJECTWi3JdVIfQSoUH/1sj50hOaBrYTu8poPNwPRk3
u/QQIMp3b4UU6i8qI7eugR2xzV8DdBYE4mQWUMznGeBpL/7Msh8ShpcYJ1SX1hab
vWmpvtFx6YgVt11Q9J5HktbIVChKdSUhOHzSsAG8/WxbTc1yjUtZd+WO2WjQ/fmj
/lPULbbZUBH3ZXSmM56yvlDDk5owvFydDMaVUl35v44LvFZqj+pjhUBGG1r8EpYe
Jlb3uvMO6EXy1PwdNOldjNcGjcKc5bYmTFQs65FcbbwCEe+9HPRcDL9w2k8ay2Wb
xIjS9Ep5w4oZiV1XHJYs+8WdS4rqr98HPCP2uYrk3E1Nuce4lktKIShKPvTerZM=
=cCvM
-----END PGP SIGNATURE-----

--Bi+HF1AHjw0mn3zx--

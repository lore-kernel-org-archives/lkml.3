Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752955AbaDAL5T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 07:57:19 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:49869 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752476AbaDAL5O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 07:57:14 -0400
Date: Tue, 1 Apr 2014 12:56:59 +0100
From: Mark Brown <broonie@kernel.org>
To: Nicolin Chen <Guangyu.Chen@freescale.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        alsa-devel@alsa-project.org, timur@tabi.org, Li.Xiubo@freescale.com
Message-ID: <20140401115659.GQ2269@sirena.org.uk>
References: <1396322227-482-1-git-send-email-Guangyu.Chen@freescale.com>
 <1396322227-482-2-git-send-email-Guangyu.Chen@freescale.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HcsbBFLnFtTJqgUw"
Content-Disposition: inline
In-Reply-To: <1396322227-482-2-git-send-email-Guangyu.Chen@freescale.com>
X-Cookie: Printed on recycled paper.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH bisect 1/2] ASoC: fsl_sai: Fix buggy configurations in
 trigger()
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--HcsbBFLnFtTJqgUw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Apr 01, 2014 at 11:17:06AM +0800, Nicolin Chen wrote:
> The current trigger() has two crucial problems:
> 1) The DMA request enabling operations (FSL_SAI_CSR_FRDE) for Tx and Rx are
>    now totally exclusive: It would fail to run simultaneous Tx-Rx cases.
> 2) The TERE disabling operation depends on an incorrect condition -- active
>    reference count that only gets increased in snd_pcm_open() and decreased
>    in snd_pcm_close(): The TERE would never get cleared.

Applied, thanks.

--HcsbBFLnFtTJqgUw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTOqmIAAoJELSic+t+oim946MP/iXSUpw+dx2A7yXMkq/swc7Z
D7A0Nr0YZjM7MvTjo+rbtHCPXCSbST9P0SUEKMJUc8dRzqklAJNJ5um/gUpY+4le
DtalVp3+h8R+kgY92sOoK2Qh0kN29UEo+MUf1E0fS1f5/xQi/uGDmmCWEdjbjeNB
ENCM6ByrtI4vuiV051Wj9UQcSU2ppdJiDE/ijCuNQjeb8aE0U0Brznx7f1mX4m0Z
b4zhhsCIwQiDxA7BWtBjTy8YDiEGtMNYZkeMYMtNgElwYmISsPnXoQ9I806Whm2f
hqONkJSBrQY6cfsXbJqkcLTpP/FaWq56Dr3oPFCsudI3U7FOyUACGnJjGMF8k2Xq
WfzHhW4aMQRSLoCzUmS4Lch7Y0AqXenMz0ikW5mqh1ZuHHCwh1w+4Xnr/mr55D6/
OHGTa+uveC/KiRFPun9tahi3d572GMJg0uBd5LBUgOBOLKp7EBFWKywOyoljQyKQ
DxMNLM+1TQDFJCYvEwnqCUcBRCyHtdNU0W0Ursqb/IT7z4V1rWxF4zFMC42BdFk9
s2w4hRqJk1wOQEOtydSwA97zlsTdSZPfoOeE4mQoWwmgNB198CfdUsR0UpEDx1+v
75nimuF/NgCSzy2Q8l3Co7XzU5z1YhSH32O3Vya8RQ2Fs4zT7x5I2HANR26nTLCW
eR2Rq4hHW7NRGPNwUwOZ
=KNUf
-----END PGP SIGNATURE-----

--HcsbBFLnFtTJqgUw--

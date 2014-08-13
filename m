Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752945AbaHMSyh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 14:54:37 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:33816 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751973AbaHMSyf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 14:54:35 -0400
Date: Wed, 13 Aug 2014 19:53:57 +0100
From: Mark Brown <broonie@kernel.org>
To: Guodong Xu <guodong.xu@linaro.org>
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux@arm.linux.org.uk, sameo@linux.intel.com, lee.jones@linaro.org,
        lgirdwood@gmail.com, grant.likely@linaro.org, khilman@linaro.org,
        haojian.zhuang@linaro.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Message-ID: <20140813185357.GH17528@sirena.org.uk>
References: <1407929624-8737-1-git-send-email-guodong.xu@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="fhI9yMnVGIkyVtZW"
Content-Disposition: inline
In-Reply-To: <1407929624-8737-1-git-send-email-guodong.xu@linaro.org>
X-Cookie: 98% lean.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v5 0/7] Add MFD and regulator drivers for Hi6421 PMIC SoC
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--fhI9yMnVGIkyVtZW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Aug 13, 2014 at 07:33:37PM +0800, Guodong Xu wrote:
> This patchset adds an MFD core driver and a regulator driver for Hi6421 PMIC
> SoC.

The regulator patches here all look good but I'll apply them on multiple
topic branches so I'll wait until after -rc1 is out so I don't need to
rebase.

--fhI9yMnVGIkyVtZW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT67RBAAoJELSic+t+oim9+pYP+gK1+xZ5Yes5kwO8ElKv0Nu8
Jq2S5SFPfywSJnr3h/3/ltUVaVd/7JNN4VA7rycZh+PeMt4S2bfSOKHnX38cfvNP
lBsN/TFwGf7VRUAtYIgr3XD2htwR9B1z4yviV90HJ9i6omb0r8BlxOP/4rKNvtKg
RvapXauB/BKZpVHvLpSGV40A5Cd9JZN/SJ6AExcO4DmPcSLreuFOezAzB64BOkNq
AhOXj7OIDUZuTzWNOK4zKLTa0wtBrE+pV5PUqJOASYaGjzEiAIiWvMQ0mQ38s7QS
FUkYTtFxXsrD85hMnfzRf9xtWLo7qcWo8b9PIB3jJYm0+m/tGff9CUJRIIvbMGR5
WIfPmS5YY43se87nEKfUtVxwqkn5EtTlA4agdPZVr0sUDcDS9ZvBvi3o8Ev6Xudz
q5X2MaQMx29zEChiXZmaPuYmfRWeBedtuNyrlPjJu7JRxb078e4q5LHRT7QPV5hD
PnYsaH3mq8Z8Z8jhk2QCY80c5+XnRYdMESS6bC9Z4sEHGAMw/jkY87FC6p2ZXRhU
5m5GQ+JsF4ICihdJaCCYC2yoXoRHnxvfAaN3gBRFfW9BRxLUyzZVyiTgt57mPdkQ
8VmxJnzOZ6vjZ7lMH/FDbiHYKOBK75bJ6glNzyDKaI0XW/fzr3qZAMhnYBLJrD0P
GWXn6m/hFlxj1Qm49cWX
=4DZo
-----END PGP SIGNATURE-----

--fhI9yMnVGIkyVtZW--

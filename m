Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751524AbaHITcf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2014 15:32:35 -0400
Received: from sauhun.de ([89.238.76.85]:56061 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751069AbaHITcb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2014 15:32:31 -0400
Date: Sat, 9 Aug 2014 21:32:26 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Pramod Gurav <pramod.gurav@smartplayin.com>
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, Grant Likely <grant.likely@linaro.org>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Andy Gross <agross@codeaurora.org>,
        "Ivan T. Ivanov" <iivanov@mm-sol.com>
Subject: Re: [PATCH] i2c: qup: disable clks and return instead of just
 returning error
Message-ID: <20140809193225.GA3411@katana>
References: <1407328405-25170-1-git-send-email-pramod.gurav@smartplayin.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="CE+1k2dSO48ffgeK"
Content-Disposition: inline
In-Reply-To: <1407328405-25170-1-git-send-email-pramod.gurav@smartplayin.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--CE+1k2dSO48ffgeK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


(Ooops, this mail got somehow into my postponed folder. Sending
anyhow...)

On Wed, Aug 06, 2014 at 06:03:25PM +0530, Pramod Gurav wrote:
> This fixes a error handling scenario where clocks were not being disabled
> when QUP_OUTPUT_BLOCK_SIZE returns a size greater than the size of blk_si=
zes
> array. So this patch adds a statement to jump to the fail lable to releas=
e the
> clocks.
>=20
> CC: Wolfram Sang <wsa@the-dreams.de>
> CC: Grant Likely <grant.likely@linaro.org>
> CC: Bjorn Andersson <bjorn.andersson@sonymobile.com>
> CC: Andy Gross <agross@codeaurora.org>
> CC: "Ivan T. Ivanov" <iivanov@mm-sol.com>
>=20
> Signed-off-by: Pramod Gurav <pramod.gurav@smartplayin.com>

Applied to for-next with Ivan's ack from V2, thanks!

Please use "[PATCH V3]" and alike in the future to make it more obvious
which version is the most recent.


--CE+1k2dSO48ffgeK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJT5ndJAAoJEBQN5MwUoCm2ZswQALF2sVJlHFitV1wb655BbodX
R9jD2ysOX+C7IwRLDuH3X4EptUXv2To3Ewav3q3UD5t8tjIdqY8UM4+v9pD4OFMt
gTZUNes84xOdoPfMBhNPpJCKmvWKhaMSyghXWk0Hrg9xl5h8oWPmE15XH44GLG/Z
xBKoxFid1DJCCYs1QCJTD7ld1jyLNWcuwDUsKrL6k50H4uS04g4ul6HhmTc7lxNx
vxJdsHcnWAVfzSHEKdcD2VlwuPOcNFzxJPQgO25Q/D+XfyfWFRgvbZWaRNnFi5Ou
nWWj2lhCeettP6LMYqs3gGD4GbdoW1JEzaNFPdxR+kFXNtn04Ux5O0Kd/PNP3AjQ
2U0AFRbnHWf15M0JLcW41JPXrxS3LkUpbECPcZ0JTKQmSNaH8bfLkPG+7MTYhijD
bEFxQ2oQMSqytLi1V2Mx4bOTAxuDz9hjg6UA+aml4ZyS0+3C0x3d0YywasbxGEyq
MeGmoFJnfBSbx8SIv60T/OZGddd1g8JIpv0TO9qkBa3HHaQz3caF0GJhrejU220x
L9orKQQanAm+B0bU+HFdOQdH4EW5KtMFOwN5eM/7JOOXKeq9AEBb2hXCqVt0F5VK
VbzgQxn3bNTMOOLRitk07Rn0E+eImyhmJkSHtFMc10viqfKxPcpqt2vkEM5RcXyu
Vxr6d3DFWei5HzPJ0zOm
=euKv
-----END PGP SIGNATURE-----

--CE+1k2dSO48ffgeK--

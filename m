Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752416AbaJCBVH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 21:21:07 -0400
Received: from sauhun.de ([89.238.76.85]:34767 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751690AbaJCBVE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 21:21:04 -0400
Date: Fri, 3 Oct 2014 03:21:38 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Andy Gross <agross@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        "Ivan T. Ivanov" <iivanov@mm-sol.com>, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] i2c: qup: Fix order of runtime pm initialization
Message-ID: <20141003012138.GH1323@katana>
References: <1412028051-21774-1-git-send-email-agross@codeaurora.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rCwQ2Y43eQY6RBgR"
Content-Disposition: inline
In-Reply-To: <1412028051-21774-1-git-send-email-agross@codeaurora.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--rCwQ2Y43eQY6RBgR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 29, 2014 at 05:00:51PM -0500, Andy Gross wrote:
> The runtime pm calls need to be done before populating the children via t=
he
> i2c_add_adapter call.  If this is not done, a child can run into issues t=
rying
> to do i2c read/writes due to the pm_runtime_sync failing.
>=20
> Signed-off-by: Andy Gross <agross@codeaurora.org>

Applied to for-current, thanks!


--rCwQ2Y43eQY6RBgR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJULfohAAoJEBQN5MwUoCm2qaIP/1H0wlX9Fe+0xy2IB3MnX5Ya
jlgiCl2ixzSy3Q328pDjwaNgt6uSjSC/ZD6kWkZ5p8ReLb9mb+tFT9GgDRZXrCnZ
f2n1kSsOBjwrXEUE6PliIHga0FRWgZziNku5d4QtsxVPbynH3Bm6S7UUrhdYg6gX
PLR4oL1SKTW5HDFxfIjD0rHSTqQ6doPEbewow1CvTGR2eFC7MlNBGaoSkk6abQai
n8EmMCWLdovKQrMc5aXLydhEx6HuUh3Pi0brEaXvUeiB6RKnBidgJIDfMQjudUIA
zIOTLnHWbphpbT48iHKUp2oe8DgDL4yyf3rjEBsgDvxz/A5rAODtXH9my5T+//NH
1EfNvPsN+LicEwk6epTnAq5vb6W6nRpVSVjHDYSldxc/FaWqNgphtbeRlfG9XE51
FHPT5N8UytcCjMXMwaEDIFn1u4OBv0vO358NW1x31wD5G0MAku3t0o2EY4GrmCoz
UWYroII3Pc4MEy2G/2mJDilnxpDR43GqRdlZDV6lI3sLwF2IFC/J1Cdaak28SK19
n7bvdvhfKL0znfoROkPRaymjkUhVUlxeR7LgAlN8lL+zHdx5DZdZjGRjkfHk9dJ8
hJPOQGyQHUNbnE/snuddqVL0GNHc0TuVMqimcDD+Y0DW3YZwO4mk6hfNDeDzOmNQ
URPYDG6QyR3ppNjzqbi0
=nZj/
-----END PGP SIGNATURE-----

--rCwQ2Y43eQY6RBgR--

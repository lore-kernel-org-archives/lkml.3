Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752066AbaCXXCL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 19:02:11 -0400
Received: from mail-bk0-f49.google.com ([209.85.214.49]:50398 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750972AbaCXXCJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 19:02:09 -0400
Date: Tue, 25 Mar 2014 00:02:06 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: Ben Skeggs <bskeggs@redhat.com>, nouveau@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, gnurou@gmail.com
Subject: Re: [PATCH 09/12] drm/nouveau/graph: pad firmware code at load time
Message-ID: <20140324230204.GH17218@mithrandir>
References: <1395650554-31925-1-git-send-email-acourbot@nvidia.com>
 <1395650554-31925-10-git-send-email-acourbot@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dMyqICaxQaaUjrCL"
Content-Disposition: inline
In-Reply-To: <1395650554-31925-10-git-send-email-acourbot@nvidia.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--dMyqICaxQaaUjrCL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Mar 24, 2014 at 05:42:31PM +0900, Alexandre Courbot wrote:
> Pad the microcode to a multiple of 0x40, otherwise firmware will fail to
> run from non-prepadded firmware files.

Perhaps this (and the comment in the code) should mention a unit. In
this case it's 0x40 words. Also, I think using a decimal number would
read easier here and in the comment. Furthermore, perhaps choosing a
byte as the unit would be even more intuitive.

But either way the code is correct, so:

Reviewed-by: Thierry Reding <treding@nvidia.com>

--dMyqICaxQaaUjrCL
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTMLlsAAoJEN0jrNd/PrOhk7QQALNtccTf1u0Bn0ePaXsBV3NE
XdvlaXEgb672RSdouic04izlbQz6FDJlxm8jhw8n9E5tKYwnqrG68w5p1X2oz8uR
tXf+fVGwmBtBNgH54efoIB1pxqxYJWiKon64ag8FRBfCE3N7ItJ43NWodvISBaQ8
HHwZJ6u+JGQtSSGOQ+6+NxuEHy8R02gB9BKx36AXE+EaAZmnbLT6suxLrfoujdDk
gAcFE+ETdOKH1nuhjcYZNLBiGd+gm9H2yHE3/5BPSoMmmllJeUx23bcM30AaK1W0
f04rzMERRfcUMTNS7Mg3jaOV7MthycdJL0sAoBLyD+3mEPEv06DsrNGbsRQa3K+8
vbXjPKwbzTMbl8CuPyHc3RfuB0cZP4w6pchjUhy52f8mxmeuZXou86t3FbYQCBq6
9iUJWVAILhkDk/Q7jSNfURQpj01kC4WiFML33uNfjbxxkTMFH36Gv1lWC3/JOxnX
YXSWa99mUxXv0npayGG6JfPsfha07olY7b2WruBc84Nc2b40TJYYT1J/XSST1tJc
wxS6PjTrDWNYiLLyw+Y6C5ydiSQfTTopUIZHAYXI16WfBp1LPqDaDx0HtbBiPv4L
XyBR7oqE3wNGbj/enkFrjrcPuxZQlXLhvnX6yaxpjcZxNQR21hlNFbxAIPDQCmBO
rvipgCZ35CPpswfJpPXo
=xHpR
-----END PGP SIGNATURE-----

--dMyqICaxQaaUjrCL--

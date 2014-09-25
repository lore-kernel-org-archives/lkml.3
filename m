Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753009AbaIYNEU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 09:04:20 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:40314 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752520AbaIYNEQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 09:04:16 -0400
Date: Thu, 25 Sep 2014 14:03:56 +0100
From: Mark Brown <broonie@kernel.org>
To: Vinod Koul <vinod.koul@intel.com>
Cc: linux-kernel@vger.kernel.org, subhransu.s.prusty@intel.com,
        linux-spi@vger.kernel.org
Message-ID: <20140925130356.GL27755@sirena.org.uk>
References: <1411575342-31048-1-git-send-email-vinod.koul@intel.com>
 <1411575342-31048-23-git-send-email-vinod.koul@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DXIF1lRUlMsbZ3S1"
Content-Disposition: inline
In-Reply-To: <1411575342-31048-23-git-send-email-vinod.koul@intel.com>
X-Cookie: You are magnetic in your bearing.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 92.40.248.7
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 22/27] spi: orion: use
 pm_runtime_last_busy_and_autosuspend helper
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--DXIF1lRUlMsbZ3S1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Sep 24, 2014 at 09:45:12PM +0530, Vinod Koul wrote:
> Use the new pm_runtime_last_busy_and_autosuspend helper instead of open
> coding the same code

Acked-by: Mark Brown <broonie@kernel.org>

--DXIF1lRUlMsbZ3S1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUJBK7AAoJECTWi3JdVIfQ8H0H/jzoij3c5gozMmHMuSztroEy
Po3Ax9s9AL5/vjsRmxkHzrw47/FDd7qa6qF3vjz3j5wBY3WoPB3ZmgMMoRgG2GMo
FVI1GgrIbZmfyJXwYi6Ols6Sroqi7dghv2mAP8E6MkKbe7Avyt5RDBzThl/2oGxh
s5RdNn2mjtqm2ExUjpgTx19o01CHoUDbIRqDAAiUgf6G9JTGBX/sRFKFSLNU02Ki
1KjLVMC07/uPNA0hXeBFw7ah5zsgoGtrcRXQGAwsTDgXph7AqoEVZfeCULUFl/E9
V+5iYbT4wYE2edx3SmIwFVciy3cLJC18rNJm3GBdhffOnJyyC7ruNz7lAw55c6c=
=fO1b
-----END PGP SIGNATURE-----

--DXIF1lRUlMsbZ3S1--

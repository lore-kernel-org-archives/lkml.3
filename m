Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932603AbaIRSOn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 14:14:43 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:50999 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932117AbaIRSOm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 14:14:42 -0400
Date: Thu, 18 Sep 2014 11:14:36 -0700
From: Mark Brown <broonie@kernel.org>
To: Kiran Padwal <kiran.padwal@smartplayin.com>
Cc: linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <20140918181436.GF7960@sirena.org.uk>
References: <1411025267-773-1-git-send-email-kiran.padwal@smartplayin.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oMvEetrZIm2PFzDm"
Content-Disposition: inline
In-Reply-To: <1411025267-773-1-git-send-email-kiran.padwal@smartplayin.com>
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 70.35.38.154
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] spi: pl022:  Add missing error check for devm_kzalloc
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--oMvEetrZIm2PFzDm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Sep 18, 2014 at 12:57:47PM +0530, Kiran Padwal wrote:
> Currently this driver is missing a check on the return value of devm_kzalloc,
> which would cause a NULL pointer dereference in a OOM situation.

Applied, thanks.

--oMvEetrZIm2PFzDm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUGyELAAoJECTWi3JdVIfQpqwH/32Q78L8lCwnvo45H8eiPt1Q
bJ5sU4Xn8FhtkT270GitYvl3mMV57eU8b1PuAHGRVTQordnJORwzPRlXjKmNNTz3
jvWsBUQSawdm2XirHEA9AS3S7jGqooryEEeA6cGB041pyeIQoL9f8FwXdT5XO0zL
W7zEh6/YROiX6dbHvdljkki8QjTMNAswyY8kdzM05SHQwh14T2t/XRT48x6Ltw9j
CodMLE+MiI3ekNjKlZm3Fcc+AQhsj5/OSi6dE2/oPT5XTJQi7dQxZnbetHCgeh6m
LtntYdcMHUZMJBGTASUq7wIrRQbe5VViRkgXl2G9aVkI0nxivwrTN++kY3IDs0c=
=zbTI
-----END PGP SIGNATURE-----

--oMvEetrZIm2PFzDm--

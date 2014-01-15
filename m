Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751806AbaAOLox (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 06:44:53 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:54628 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751694AbaAOLou (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 06:44:50 -0500
Date: Wed, 15 Jan 2014 11:44:35 +0000
From: Mark Brown <broonie@kernel.org>
To: Arun Shamanna Lakshmi <aruns@nvidia.com>
Cc: lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.de,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Message-ID: <20140115114435.GH15567@sirena.org.uk>
References: <1389742314-20125-1-git-send-email-aruns@nvidia.com>
 <1389742314-20125-2-git-send-email-aruns@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="G1IH56i3DES2a+WZ"
Content-Disposition: inline
In-Reply-To: <1389742314-20125-2-git-send-email-aruns@nvidia.com>
X-Cookie: Marriage is the sole cause of divorce.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ASoC: dapm: Change prototype of soc_widget_read
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--G1IH56i3DES2a+WZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jan 14, 2014 at 03:31:54PM -0800, Arun Shamanna Lakshmi wrote:
> soc_widget_read API returns the register data and it is possible
> that a register can contain 0xffffffff. Thus, change the prototype
> of soc_widget_read to return only the error code and pass the reg
> data through pointer argument.

Applied, thanks.  Don't send cover letters for single patches, if there
is anything extra in there put it in the changelog or after the --- but
otherwise it's just an extra mail to read.

--G1IH56i3DES2a+WZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS1nSgAAoJELSic+t+oim9tewP/3bZ+4Nn+DO69bR/iB8Voo7h
F5Lg8GCa4UO70rdYep5WOgOyXpKm0RbeND+wqyuTpng7v9ZfN9mAAz9SbTzRAUpr
K9C3Q6H8ONEVQNLHcbXGLORCUQrPC5Sd4opsl0STNI0hzsLsVbcjxtL/N9A7605m
AkE2O+P2cu9tGccJQgTW5hsQE13zLiFstPT23WdqnoDCmbjxnTui4biBk4siuQOy
7Ax6lJ2FIGUBFow/FlU25j8tYefUB+W7yClXYPya5Ea42INA6aO7iwXav9HyOsMB
wtLKgK9JrID9vZJmUT5emchyi5QqTIgbdS2D/RYAfP+i0d6eWPk18idqUIk+ec+0
JEMgSoH5QtwZfgwpWl+T9EWi+dkVJg7FvRZCSkWLOJEQ19NiYK7gGOfehqzenaKr
kKsMyA3gMPQgKOwM02QNxCwk+B7aF9NN40J6m52JJNiIR/hZlP0h7xzpk5wJox7f
6JnJsGVSrAAcM3ySbXLteSZfT0qSqUnxxYkBNB4BqWnJxRyyqwKZf3usjaSVj5dt
/1uh+RetWIXAtvXZxIaP7r1HpvTaCF+hFSpZ0cBrB9YSXLQsasGtuoh6mA60AXjj
ou7zK7693ngh9QCmNfDiWXR755zL+Iwrx916yH3DW/MY8gd+onIkqxx9/kie3i+H
jeCryzjbF2MAJQqIiMSN
=YIVh
-----END PGP SIGNATURE-----

--G1IH56i3DES2a+WZ--

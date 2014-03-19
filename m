Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965175AbaCSNLt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 09:11:49 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:36916 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964995AbaCSNLr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 09:11:47 -0400
Date: Wed, 19 Mar 2014 13:11:42 +0000
From: Mark Brown <broonie@kernel.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org, lgirdwood@gmail.com, sbkim73@samsung.com
Message-ID: <20140319131142.GJ11706@sirena.org.uk>
References: <1393912018-15780-1-git-send-email-sachin.kamat@linaro.org>
 <1393912018-15780-2-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="b0T1S56dfvmV3Vu7"
Content-Disposition: inline
In-Reply-To: <1393912018-15780-2-git-send-email-sachin.kamat@linaro.org>
X-Cookie: Turn the other cheek.
User-Agent: Mutt/1.5.22 (2013-10-16)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/2] regulator: s2mps11: Add missing of_node_put
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--b0T1S56dfvmV3Vu7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Mar 04, 2014 at 11:16:58AM +0530, Sachin Kamat wrote:
> Add of_node_put to decrement the ref count.

Applied, thanks.

--b0T1S56dfvmV3Vu7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTKZeLAAoJELSic+t+oim9AVYP/3cxa7T4NUFeFEU81ekQCGDj
XGQRcYlmlUu22oXzavAGKqamzyeONRdaq/OvjQO+LHbtx4sClnGZ1rHxd6iBSbDK
rAPR7MrReXgVtXx97w2BKcIodF81WRLrzhGRIrcviUiRGVXEXmNGYn1QNXiRWu3G
uDZ+tTx/yl6YKbGrYY35ZhpYlGX03/P/Bx5pc3gIrb+va+SfilsZ10DMirzUrw41
0l4wihZoFvHvYqlOzw3ST8TaEkZd7VfuHxXtZlEYLh9ugoL6XsZ9mC1EFQtdqtig
KJvsi8tjQX9U7o9VVM9qfacupySUOMU4DXkg4mW2bwAWnmi8cWkRGpXva5NwLpjg
6Vu/gh4FAZQy7wwiDri1MpvG57kg/VrTDcjGB3LpZLNjuMk08Yp/c9tESTBFU7Cw
5GWV+Pwh+BTJkXqdJkL5ThGbgtONtJfu0DFYKGlxsks+jV1/8BWSgq6Cnp5Hu3pM
LIZ/JBf7ykCRrZLI7ABxxNfLN+MiDzdNc/9EKTPyqGSIjPEimiZy5EUXvxRD5K5c
4DG0JSxmAiBFrQ26LWVq/tDJIIVDIK3ONzbxhPbOugSQCmjoKvSFoPWF2wwB9H7r
sA0WN5DYAGj70eU9mMgrULDV6MgYQ0gSya+fMWtVV33yzVshe1/5xygGoS0701IW
hZj+E2FgNa+/Thw6jeIq
=/SWM
-----END PGP SIGNATURE-----

--b0T1S56dfvmV3Vu7--

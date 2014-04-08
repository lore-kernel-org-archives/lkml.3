Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756578AbaDHLKH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 07:10:07 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:45143 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756520AbaDHLKE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 07:10:04 -0400
Date: Tue, 8 Apr 2014 12:09:48 +0100
From: Mark Brown <broonie@kernel.org>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Kumar Gala <galak@codeaurora.org>, David Brown <davidb@codeaurora.org>,
        linux-spi@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-ID: <20140408110948.GD6518@sirena.org.uk>
References: <1396784733.30640.25.camel@x220>
 <20140407130853.GG14763@sirena.org.uk>
 <1396880145.12738.6.camel@x220>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MAH+hnPXVZWQ5cD/"
Content-Disposition: inline
In-Reply-To: <1396880145.12738.6.camel@x220>
X-Cookie: This report is filled with omissions.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] [RESEND] spi: qup: Depend on ARCH_QCOM
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--MAH+hnPXVZWQ5cD/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Apr 07, 2014 at 04:15:45PM +0200, Paul Bolle wrote:
> Commit 8fc1b0f87d9f ("ARM: qcom: Split Qualcomm support into legacy and
> multiplatform") removed Kconfig symbol ARCH_MSM_DT. But that commit
> left one (optional) dependency on ARCH_MSM_DT untouched.

Applied, thanks.

--MAH+hnPXVZWQ5cD/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTQ9j5AAoJELSic+t+oim9iv0P/0UrzcpGobx2dXcoM4Jg/Wpq
401KqoGp2IUlk+ngaVVFj1Lplm4RVvPhYE4V+95tdeXKAFeHXuJVmBS7uOeGdOA5
uDxLcV8NfD3qg2mPsIYVg5K/cVL7XD2uttXbzXh6VHEzoSiA9JvCzjoQjy7FS03h
x5qgeQvPB7BTw7gJ2uaBpCkMGocyIKJjpyFKMoHEOFzFq6e0KNvvfAw0t9sTuiSh
YSStrnmy1UdMxuFCmlWgekXcCuTbhGuTqcFe87o2VTl3q9UJu3/0zx7arGuzmiDn
31QHdLmxdqcanesRTO1NhiDxae8OiHPNPkw0skCiArb2+zCqLE4KvZQbc6JQmbr4
SqAIjOcwAen4P5uoOx8vM6lN7sk0UucQV3Ex+0l4J50X4JeOtPLqaqXGYW/k9otH
g1R3OOqd7uVs4g0FPxr/Ae2Bj0ZE4G4I/vDeqpvsegWbMLzkJUtmYuulzoMMnffo
hwmKpZWqWq9H8kTQzkR1lJTNZuGmDJhwFXkeI9Rl+7DT1saXHA4ym5rjfwCM9sD+
PGLhRdkB+wbKLBIysj2zRL4ATyO7vT2KPqfF/TvVKuK+UTGlNqAJzN27y5P852te
F9Xsxf8Crc0QIoAR/bmtVsCzN5dSoIxxdGaOc2o5/IknM8+lK6OCWM56m0YfxZLQ
fuNL+tFYklfFhz7zgs4g
=pjPv
-----END PGP SIGNATURE-----

--MAH+hnPXVZWQ5cD/--

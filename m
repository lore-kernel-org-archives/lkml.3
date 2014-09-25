Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752893AbaIYNET (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 09:04:19 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:40317 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752539AbaIYNER (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 09:04:17 -0400
Date: Thu, 25 Sep 2014 14:04:07 +0100
From: Mark Brown <broonie@kernel.org>
To: Vinod Koul <vinod.koul@intel.com>
Cc: linux-kernel@vger.kernel.org, subhransu.s.prusty@intel.com,
        linux-spi@vger.kernel.org
Message-ID: <20140925130407.GM27755@sirena.org.uk>
References: <1411575342-31048-1-git-send-email-vinod.koul@intel.com>
 <1411575342-31048-24-git-send-email-vinod.koul@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yklP1rR72f9kjNtc"
Content-Disposition: inline
In-Reply-To: <1411575342-31048-24-git-send-email-vinod.koul@intel.com>
X-Cookie: You are magnetic in your bearing.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 92.40.248.7
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 23/27] spi: ti-qspi: use
 pm_runtime_last_busy_and_autosuspend helper
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--yklP1rR72f9kjNtc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Sep 24, 2014 at 09:45:13PM +0530, Vinod Koul wrote:
> Use the new pm_runtime_last_busy_and_autosuspend helper instead of open
> coding the same code

Acked-by: Mark Brown <broonie@kernel.org>

--yklP1rR72f9kjNtc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUJBLGAAoJECTWi3JdVIfQ93UH/0Q77ezZ7u8WTStyFUfdDjqT
azulxjSmrDra8ZvymPrjRSfdABorXErBDEMZQhPA7A/y/7TvmWn8yTnexRe8+7gH
+EWALgzIVv8ZSxGSz7a9f9XND0ZEtrbcEpLHslDIORtDMe7QyQ8Mt/Fk0oynYbQp
KbkUrKHaEAhQqDlXtm9KuaT26VjsBWnJmVk54UUjEO5/EDUpfzUE+iO9eNvmRqAU
4kwKwW2vXuqv5LW/aKeLhEqplbUGT+AmkijxM//efq1KbwRERrHi80hgNzwvasRH
ODOcbcSyOok2tcKVptHVYkhnXJGNPNcNm7LgsdH4XlTmUBkKe+bf/0IeweOeRuE=
=34Kj
-----END PGP SIGNATURE-----

--yklP1rR72f9kjNtc--

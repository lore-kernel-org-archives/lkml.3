Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753991AbaFXPKO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 11:10:14 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:55734 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752608AbaFXPKM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 11:10:12 -0400
Date: Tue, 24 Jun 2014 16:10:04 +0100
From: Mark Brown <broonie@kernel.org>
To: Sachin Kamat <sachin.kamat@samsung.com>
Cc: linux-kernel@vger.kernel.org, ldewangan@nvidia.com, lgirdwood@gmail.com,
        spk.linux@gmail.com
Message-ID: <20140624151004.GL23300@sirena.org.uk>
References: <1403598283-21099-1-git-send-email-sachin.kamat@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="V3eawNQxI9TAjvgi"
Content-Disposition: inline
In-Reply-To: <1403598283-21099-1-git-send-email-sachin.kamat@samsung.com>
X-Cookie: But it does move!
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/1] regulator: as3722: Fix incorrect parameter
 initialization
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--V3eawNQxI9TAjvgi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jun 24, 2014 at 01:54:43PM +0530, Sachin Kamat wrote:
> 'name' field was re-initialized and getting overwritten in some
> cases possibly due to a typo. Code inspection says the second time
> it should be 'sname' instead of 'name'. Replace it.

Applied, thanks.

--V3eawNQxI9TAjvgi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTqZTJAAoJELSic+t+oim9YXMP/iOS20CAbQx4Fm1Nebjx9H9e
DcmlmJAiaMJIyrhCvPRROUQAjFpWAtg1cl5iM39VOSBT2MFUYhk8MsWmqkfWtrgI
9TNr1JTrICsmwWFd0tLXxzmwQlaMldUTg9+PL7TFtX+i5IBzzQ91fyXfP3bag93d
oA8kSdr5raEKYYuFtaHPauoAalR4JOWrsdoR+paCtqa01brXvcBceVucgh6inXBi
J9Klv6t7fUdeCSFG8B0qR8tO7IKpomX9GUUHknsmlp4RSO4QTFqpZdw72WFS1qrG
VZwHLxXz6PwnODrFPpjkEwWlXzQ9e7KNx16jCsK3LT+EFWYUlEqIO4T0mJbrdahC
eKRgeBNP246lSGF/Rt+V1ko/MF419MT/DMjMrqryotS9mUVsA6xhV2AEJzmwWfbU
im9OQdRg4NxJhpVPpt3pXsJV8uXajXqx+YQ6DtedAUhvAvuUNxLBftDpO8aqGa4H
DvpbSYiGS5d9QPOugeOBgiTTX68+PIFQqCwIkQtJYVgh4EhNcRzUpHIoVEmXdntN
SY/h2aOzypW5UQaj5QRU5AnSxsCvt/jgvEfpx4XG5Ob6KO1nUQt30NMmNNIbJ/xA
Zt0PtjopOx1pzF+j+V+fuR6FVoP4Y/K77WllaMebv1xrNVS49fHgclXAANs30So5
AlDhtX6o8sY9so14dfJp
=DobM
-----END PGP SIGNATURE-----

--V3eawNQxI9TAjvgi--

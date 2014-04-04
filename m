Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752662AbaDDKF6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 06:05:58 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:51100 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752193AbaDDKFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 06:05:55 -0400
Date: Fri, 4 Apr 2014 11:05:32 +0100
From: Mark Brown <broonie@kernel.org>
To: Nicolin Chen <Guangyu.Chen@freescale.com>
Cc: Li.Xiubo@freescale.com, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, alsa-devel@alsa-project.org,
        timur@tabi.org
Message-ID: <20140404100532.GN14763@sirena.org.uk>
References: <1396595387-4371-1-git-send-email-Guangyu.Chen@freescale.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="kY0AMSsGPnDJoAXR"
Content-Disposition: inline
In-Reply-To: <1396595387-4371-1-git-send-email-Guangyu.Chen@freescale.com>
X-Cookie: To make an enemy, do someone a favor.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ASoC: fsl_sai: Fix Bit Clock Polarity configurations
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--kY0AMSsGPnDJoAXR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Apr 04, 2014 at 03:09:47PM +0800, Nicolin Chen wrote:
> The BCP bit in TCR4/RCR4 register rules as followings:
>   0 Bit clock is active high with drive outputs on rising edge
>     and sample inputs on falling edge.
>   1 Bit clock is active low with drive outputs on falling edge
>     and sample inputs on rising edge.

Applied, thanks.

--kY0AMSsGPnDJoAXR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTPoPoAAoJELSic+t+oim9cqwP/0eylndow3ZrNrhmze/mgQHS
SQmqXMDPwLQEH3Jb3i+s1KdvLwS318DgsFNfX9pCYNWeDlP/IkTMzNKxSjrEY69V
z+0N5QUkYfUkWkjnAStiWKj40/2Vl/oN1g557czLa6H+1iREbrxS9aOhNj+i7gBh
XgpFSbK84VRzQntlg75Iv5yfbfJ0zW3d/cV+CsJ8IRekGey6hd+r3riaWouUJ4BM
ViflC6ypTht3ahLKPSrOXtI5Y5f+l4ueCdt8xtuv1Aj3EZf8hRaFJTzveDJce+7F
bnIOx/bZv91yJSErE/+28bDcxJN7IkuXJMEgC1x3ktzgOfKACumaQjRfw6qMsaPK
LUDzmT6NXn7ausjWFuFOG45UxOIZiPjUJMqs197hy+opbQRUW03SbHEdlrbO6eNa
kLdCOSJIbjGBxPzx9Q+eXFsmQv7jXcLz464YyQVSTBuPFstF3WliQXpi6VqLXG/9
+NzAmzdhN3j66A1REYK4/B9S+JrwUwo1nPXpp4hOwwQeQlZpwd0q6gmO4wJ7SyHB
kA4CdMuaKBlvulYGXgYytdr8PyVu0/arAWaBgOcECk549z/4T+UHucQI22xchsAG
+R8c43fkxcDMPZRbMgXlIoMeZbZkz0XXicsuV9CXn/iIe69d/Gdq1rj1jKAMaun+
3Fe2Kz9TWQRojvvD8/ba
=HM9U
-----END PGP SIGNATURE-----

--kY0AMSsGPnDJoAXR--

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752712AbaJQMkq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 08:40:46 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:33195 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751446AbaJQMkd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 08:40:33 -0400
Date: Fri, 17 Oct 2014 14:39:37 +0200
From: Mark Brown <broonie@kernel.org>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Lee Jones <lee.jones@linaro.org>, Doug Anderson <dianders@chromium.org>,
        Chanwoo Choi <cw00.choi@samsung.com>, Olof Johansson <olof@lixom.net>,
        Chris Zhong <zyw@rock-chips.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Abhilash Kesavan <kesavan.abhilash@gmail.com>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Message-ID: <20141017123937.GM1820@sirena.org.uk>
References: <1413478133-2577-1-git-send-email-javier.martinez@collabora.co.uk>
 <1413478133-2577-3-git-send-email-javier.martinez@collabora.co.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UUMz/kfoogzZ9WLZ"
Content-Disposition: inline
In-Reply-To: <1413478133-2577-3-git-send-email-javier.martinez@collabora.co.uk>
X-Cookie: Excellent day to have a rotten day.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 62.156.150.204
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 2/7] regulator: max77802: Add set suspend mode for
 BUCKs and simplify code
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--UUMz/kfoogzZ9WLZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Oct 16, 2014 at 06:48:48PM +0200, Javier Martinez Canillas wrote:
> The max77802 PMIC has a special enable pin (PWRREQ) that can be used
> by the Application Processor (AP) to power down and up voltage rails.

Applied, thanks.

--UUMz/kfoogzZ9WLZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUQQ4JAAoJECTWi3JdVIfQXMcH/RCRHKr8sop8a40AAPZ1DBIm
K0vg154jcXlaa9iP2fWoTQ/4ZDF+NYaNJqtVTF6gotDNOnoEYinLOhqOFN8N9Qxb
GDu2B/53JkSTX/wsZQ7TAv4AX8aUJskWyZbvuJFO61jrelHrlzbw7sn6Y2w3U9by
pxSEchwTp9acWcbds5b+4t0h8WcHP0VNDwBrHagvdwCYPDx8idab4LDqwS34p7kX
zqV1ZWyFaNS4ziRLuHv2NBGTNcuxHC2fcJPi7d9Dnr66PY2VZoDY296ItYTByePM
MWH8CgxEBI+2eNbTfDCKWCm8r4axL9Xx8Ch1UvqdAtWVcwxqvz5MHXJbXwBZnXI=
=cz7v
-----END PGP SIGNATURE-----

--UUMz/kfoogzZ9WLZ--

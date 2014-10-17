Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752774AbaJQMpo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 08:45:44 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:33215 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752311AbaJQMpm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 08:45:42 -0400
Date: Fri, 17 Oct 2014 14:45:12 +0200
From: Mark Brown <broonie@kernel.org>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Lee Jones <lee.jones@linaro.org>, Doug Anderson <dianders@chromium.org>,
        Chanwoo Choi <cw00.choi@samsung.com>, Olof Johansson <olof@lixom.net>,
        Chris Zhong <zyw@rock-chips.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Abhilash Kesavan <kesavan.abhilash@gmail.com>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Message-ID: <20141017124512.GO1820@sirena.org.uk>
References: <1413478133-2577-1-git-send-email-javier.martinez@collabora.co.uk>
 <1413478133-2577-5-git-send-email-javier.martinez@collabora.co.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0lsrIB+s628ok5gC"
Content-Disposition: inline
In-Reply-To: <1413478133-2577-5-git-send-email-javier.martinez@collabora.co.uk>
X-Cookie: Excellent day to have a rotten day.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 62.156.150.204
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 4/7] regulator: max77802: Add header for operating
 modes
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--0lsrIB+s628ok5gC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Oct 16, 2014 at 06:48:50PM +0200, Javier Martinez Canillas wrote:
> Add a header file for the max77802 constants that could be shared between
> the regulator driver and Device Tree source files. Also, remove standby
> and off opmodes since only normal and low power are valid operating modes.

Applied, thanks.

--0lsrIB+s628ok5gC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUQQ9XAAoJECTWi3JdVIfQlEgH/3t4R1WdBLi+2N663JtHJIUn
/lg6h/IQ0ruI/qJuhOmPmM8cJLd9z7rYHrClRH1Jr+jyHqbeTsPk0b7XSty9wwcN
Y0+LKHNNlDvuoj1Cys8IVe/fhJ24366OeGv2TfKfleVvaOXP+y8QUeBlyMlTPhat
+kS+EVEONHxAAHP97GS+klfIh55zX0F4MCPXObdPXqn5slOUYH1jVGG4YAExCbxz
BUd2kGrWmSnppT9hN8+SNZx0cVOBjI2YxLhQlP+yw+sZcqK1pcinYp62mxpRdtmc
Gm13LJpMddYnWtuUjkWbUy3j7aXxR6iESfUmosbqUqoum9vKgPcL87p3A7qFIEs=
=3ocm
-----END PGP SIGNATURE-----

--0lsrIB+s628ok5gC--

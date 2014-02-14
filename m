Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751965AbaBNRks (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 12:40:48 -0500
Received: from ring0.de ([5.45.105.125]:59565 "EHLO smtp.ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751242AbaBNRkq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 12:40:46 -0500
X-Spam-Report: * -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	* -1.9 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 NO_RECEIVED Informational: message has no Received headers
Date: Fri, 14 Feb 2014 18:40:41 +0100
From: Sebastian Reichel <sre@ring0.de>
To: Marek Belisko <marek@goldelico.com>
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org, rob@landley.net,
        linux@arm.linux.org.uk, grant.likely@linaro.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        hns@goldelico.com
Subject: Re: [PATCH 1/2] mfd: twl4030-madc: Add devicetree support.
Message-ID: <20140214174040.GB26969@earth.universe>
References: <1392383861-14169-1-git-send-email-marek@goldelico.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="qlTNgmc+xy1dBmNv"
Content-Disposition: inline
In-Reply-To: <1392383861-14169-1-git-send-email-marek@goldelico.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qlTNgmc+xy1dBmNv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Marek,

I have prepared a patchset, which adds DT bindings for twl4030-madc
using the standard IIO DT API. I have not yet send the patchset,
since I have not yet found the time to test the patchset. I will
send them as RFC now.

-- Sebastian

--qlTNgmc+xy1dBmNv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJS/lUYAAoJENju1/PIO/qaUAEP/RBb578AA3HvCH/hPWreoCsN
mmuubhoY6uxHOtcfL4i9pA3JGMxf6tuZbZ4U+crHiqNY+t1chk/yucbPBLntswvR
RQdOkZN1IzPGacJM/jlzOCPCMhHc8CNrVGdoJNm+YsVGExsR7l/myHnoucF72VhV
4y0O1thkjQFORF20dGdjucasaC53ZKQ0V+CcWMubYfGfnl8SqzuOWOBjg21XUmK6
V/McXL/Nx1Jz5Z3+yRvumZRU/3QLcV0ExOJ4oYEsftWo5GSzPITMUrRHqettX62N
f3SGCXckdx4jVhya1jHW6gz3hjjh/g7JJt5rZwARyJ9mN8sUx12Rg1spAptd5uKR
PsZHJpWBwQ/1JMDTjf9MtKIo9ctg1nWgBSNu2oWuA8jXSLXQJ9swhc1JvgFSOFgB
/qDWjLa/JjxBe7hUAqSVU9pmsaGlaOg9uTDDXPR2UMe999ouCxC+LZCX4JOrHkZc
dlPSdruMUyYJ4bp+jeXcdvCPC+vOEseTGQNWljndHPELf8UCOQq1S9ixsbvfl87R
rwuubvZxhagkgRo3DlhKixZszvH9IBtHYT2iUfSLqNuoMPppYHoA78WpZxMyAuZ+
l3qkqVPUb1G+3JDwR1uMy/ZfYZB8wMWxuSbYm/OIwrMRU2A8Z16IaxnOSrQYyO7O
/x6eG+uPb9MvehhQZHOE
=wTH8
-----END PGP SIGNATURE-----

--qlTNgmc+xy1dBmNv--

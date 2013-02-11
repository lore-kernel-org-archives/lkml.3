Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755809Ab3BKL0s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 06:26:48 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60900 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755185Ab3BKL0r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 06:26:47 -0500
Date: Mon, 11 Feb 2013 11:26:45 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Subject: Re: [PATCH 2/2 v2] regmap: debugfs: Optimize seeking within blocks
 of registers
Message-ID: <20130211112644.GD4607@opensource.wolfsonmicro.com>
References: <1360327640-16705-1-git-send-email-dp@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="fXStkuK2IQBfcDe+"
Content-Disposition: inline
In-Reply-To: <1360327640-16705-1-git-send-email-dp@opensource.wolfsonmicro.com>
X-Cookie: It's all in the mind, ya know.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--fXStkuK2IQBfcDe+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Feb 08, 2013 at 12:47:20PM +0000, Dimitris Papastamos wrote:
> Optimize this so that we can better guess where to start scanning
> from.  We know the length of the register field format, therefore
> given the file pointer position align to the nearest register
> field and scan from there onwards.  We round down in this calculation
> and we let the rest of the code figure out where to start scanning
> from.

Applied, thanks.

--fXStkuK2IQBfcDe+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRGNVOAAoJELSic+t+oim9VZAP/ji20rH5E8VmebVSMfo467xU
2cIehz5/IBPUs4QmQ+DwWuV8aJMtnlTltUm0G7hfX5V0oxz0jVtmiRWsu13eTvWL
ewkRGFVw70RbIkOGfHB2i7Mq7xUDjM7iCPqkLWZMGRiUo/uVz/FiOYGt3hAS6b5U
OLmz5uUEbWnoCkEvetQNTteitZZK/kp3PmXNKRHmZBL353P6BoDizOHOAYpojZt/
Bs9pmW4767zVBoJufmMYU7gbLOEtGrXYaBehfk+AFVjzvvMII2ZPrVTW+tK7lty8
jJ1LAbHely3HwQeMQ7fVmu+J3PXeZEc5SyjpZoad7qwhIMTF6CJFlVqXcLeURa4j
H+UvKcclFrI17I0BT/c9rQKjiRBs/ggzHJCO+y0MzvVlams7UsM3q6ZWnJfKnnbA
mZ218aU3b1wIknyPecETp5Gsw9RD5lPXZ1BMgXVls/Zynx/YWaf5S+oqHxzszH6I
hz3sqC3avmIxGsaBeN4RkT3D52vchluAEvr4bqJU6ZDx02d+2IlTOaV9Wo3qy/5r
MHsh91frPHVQ56y5k0t0PRQGuJSB/zKshGgLxITjY4Gxg4U3gaINgikbkcgG8gft
B44TDU7iqdgaUu/47EymXcKfIdAB5M4XMrIgsgNNDFrn8fuoEHyEnY7ACtiN5pmJ
RV01521I0sg38NYT5jHw
=tqku
-----END PGP SIGNATURE-----

--fXStkuK2IQBfcDe+--

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752764AbaG2S4D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 14:56:03 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:33404 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862AbaG2S4A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 14:56:00 -0400
Date: Tue, 29 Jul 2014 19:55:29 +0100
From: Mark Brown <broonie@kernel.org>
To: Andrea Adami <andrea.adami@gmail.com>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>, chiau.ee.chew@intel.com,
        Kweh Hock Leong <hock.leong.kweh@intel.com>,
        Russell King <linux@arm.linux.org.uk>,
        Darren Hart <dvhart@linux.intel.com>, chiauee85@gmail.com,
        linux-kernel@vger.kernel.org,
        Haojian Zhuang <haojian.zhuang@gmail.com>, linux-spi@vger.kernel.org,
        Eric Miao <eric.y.miao@gmail.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Message-ID: <20140729185529.GG17528@sirena.org.uk>
References: <1406221854-12828-1-git-send-email-chiau.ee.chew@intel.com>
 <20140725053230.GT1857@lahna.fi.intel.com>
 <CAAQYJAtM79NJJtfNYda-yFk113nm-2D8gZE5x=gbnLt2_eUdzQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2nOmHLaPfT8qBXnP"
Content-Disposition: inline
In-Reply-To: <CAAQYJAtM79NJJtfNYda-yFk113nm-2D8gZE5x=gbnLt2_eUdzQ@mail.gmail.com>
X-Cookie: 98% lean.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2] spi/pxa2xx-pci: Add common clock framework support in
 PCI glue layer
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2nOmHLaPfT8qBXnP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 29, 2014 at 06:13:06PM +0200, Andrea Adami wrote:

> note that a previous version of the patch breaks spi on pxa machines:
> tested on pxa250 poodle and pxa255 corgi.
> The patch is included in linux-Yocto since 3.14.

The interesting question is if this version works...

--2nOmHLaPfT8qBXnP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT1+4eAAoJELSic+t+oim9S5IP/jAaQN7VwVpQdUASIZ0FSriR
KHUqozON8uhXNUojcpy4PbLiXe5q0xyVYkv2Cucm+s0DDXl8xBOOVgg56LjLBgdZ
HM/zuGRJ3ziRm4XeemPRm8F+YTBm4cYz1wzgJDCWjiGa8xM96u0OVKztIGKdMLbF
lDqO1rFSOs3TCIPG74MPKiVTlyj5lkf6djU0Ced48ScLFeHYYNsGMJSVi2rS8MTo
UMdhlZInLpmYZ6X0rVXZH9yNZ0/AS9UKUuq/48rQidW3xiiYLm0FiaZEHKV2v4mU
btbQlD+kBCltyfMeZi6Ne4x3OpIgPZpSawSM6Fx75xDxx+6OweI5TIbuZ5TxzbrY
B2N2LblzHA4vL14Y6zVFKVPLUvqGMXjsG1rWafvUGFQcV8drUeLWRextVzD7Aur4
E667hUMQLLSWt8bnO6OKFOSD1869ZkIUgoG4BhOI1FlX8Oms2ZcUpUbJaJ0e/Iph
1KQCpDuQU6gP3gNe6QDJ7CJZq/80FxfYXHGgBHVQtWH9KhnL2+wft2vuBrF+dSxl
QENDFJpl+JTAzE3MlBt7AlaRNMd/2pvGGY5X7ApiAaE+4j3ZLcVUsRv8g4Rn0wDb
WwhXKFMUrAEN7kPRV+1TlndRgPU9vA24DVpibDhG1w0/f5qTjculpIqSOvmMAw8o
l7CeaMXCVDJXwO6/S7HU
=H/Cm
-----END PGP SIGNATURE-----

--2nOmHLaPfT8qBXnP--

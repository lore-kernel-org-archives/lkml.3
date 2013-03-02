Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752455Ab3CBDgC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 22:36:02 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:48939 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751381Ab3CBDgA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 22:36:00 -0500
Date: Sat, 2 Mar 2013 11:35:27 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Laxman Dewangan <ldewangan@nvidia.com>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "gg@slimlogic.co.uk" <gg@slimlogic.co.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stephen Warren <swarren@nvidia.com>,
        "ian@slimlogic.co.uk" <ian@slimlogic.co.uk>
Subject: Re: [PATCH] mfd: palmas: provide irq flags through DT/platform data
Message-ID: <20130302033525.GD6610@opensource.wolfsonmicro.com>
References: <1362141296-15321-1-git-send-email-ldewangan@nvidia.com>
 <20130301124350.GA25302@opensource.wolfsonmicro.com>
 <5130A53C.1000600@nvidia.com>
 <20130301131633.GB25302@opensource.wolfsonmicro.com>
 <513102D0.5030609@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VV4b6MQE+OnNyhkM"
Content-Disposition: inline
In-Reply-To: <513102D0.5030609@wwwdotorg.org>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--VV4b6MQE+OnNyhkM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Mar 01, 2013 at 12:34:40PM -0700, Stephen Warren wrote:

> Is Palmas a family of chips rather than a single chip then? That
> implies that the DT would need two compatible values, e.g.:

Yes.

> compatible = "ti,12345", "ti,palmas";

> ... where "12345" is the actual chip name.

> ... rather than just the following which IIRC was in the example in
> the DT binding document in another patch series:

> compatible = "ti,palmas";

Indeed, and in fact this has already been done for the I2C device ID
table.  We should have the same list of devices in the OF IDs.

--VV4b6MQE+OnNyhkM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRMXNtAAoJELSic+t+oim9JTcP/0B0rUG063LopyPIYMN72O9k
G5A6pxbXVJZSyfsyfYy568yuC8WtXSHv4UQRpekb1OP7or0+AedRmRsbQLID54tc
Pdu2D8oOmNU8CdR0dttZojEIuXtt40Z0GNG+KNunq0qyO1a5tGZtKenYG6Cui+MK
U4qk9NT5z/VeOq9WhzzA6j2iv9AyVU4aYzrT2tGT7BC85Y/boFlHNEAIpa2sI3qc
cOFnxCEAKFldGs/+Qlzdj3qHZv1wjspHVTXRZ57vCW4x0Y9r6FTL5/QU8Virnsog
97+8acvFRfUVVdUxMHjzA/Dfm6lJTTEX4OT86ZF0vZmr4wjDjVPspwdKmmTu2o8D
Xeem8EoNSGugMbJ4nS5g1Ec7lkDu5XzT0eRniwVgFro2biUR6FEqlqNThtyGbOy8
sA4VdrzCvSMm1NLOvKrONhX3A2kmwLQW2i77L4lM8zQ4oqrE3D2R6oyZqmENJR56
pmnDqMP7k/XMR5Sy/QWdow9EI8UCGMHHzNZOfnmgaaRFUbS+ISvxuiOrcSgT+RVP
crusm3J/Ug3AhYCPmATLgWdZ7uXRVfbaJyyG6thtHrhGQcIMHZoyyeqfPn7nCjK6
OXVOOXujXqtUTt0h1+9+oYrjqLnKfd9yhjTfiw02RJXBsQ966I/1Ol7dWfXpGy1N
hnbZq856Pi82oOK8peV0
=q7Ho
-----END PGP SIGNATURE-----

--VV4b6MQE+OnNyhkM--

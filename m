Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423061Ab3FUOb7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 10:31:59 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:59722 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422890Ab3FUOb5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 10:31:57 -0400
Date: Fri, 21 Jun 2013 15:31:50 +0100
From: Mark Brown <broonie@kernel.org>
To: Tomasz Figa <t.figa@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Kukjin Kim <kgene.kim@samsung.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Grant Likely <grant.likely@linaro.org>, Jiri Kosina <jkosina@suse.cz>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Masanari Iida <standby24x7@gmail.com>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        rtc-linux@googlegroups.com, Russell King <linux@arm.linux.org.uk>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Message-ID: <20130621143150.GU27646@sirena.org.uk>
References: <1371818017-5215-1-git-send-email-t.figa@samsung.com>
 <1371818017-5215-2-git-send-email-t.figa@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UC+RhZhEc8lcmajv"
Content-Disposition: inline
In-Reply-To: <1371818017-5215-2-git-send-email-t.figa@samsung.com>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 1/3] mfd: Add irq domain support for max8998 interrupts
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--UC+RhZhEc8lcmajv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jun 21, 2013 at 02:33:35PM +0200, Tomasz Figa wrote:

> The reverse mapping method used is linear mapping since the sub-drivers
> of max8998 such as regulator and charger drivers can use the max8998
> irq_domain to get the virtual irq number for max8998 interrupts.

> All uses of irq_base in platform data and max8997 driver private data
> are removed.

Can you use a simple IRQ domain in order to continue to support non-DT
systems (not all architectures use DT...)?

--UC+RhZhEc8lcmajv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRxGPTAAoJELSic+t+oim9jT4P/141sR6wV2nvrzcmM/7ODAQF
WUQV9LD74yLxtKb2bJPUo6JCYMRlxdNZvwgEdOxoOi0UnlmCix+2L0Q8zCpHIN35
mq68vurLQddlkdrNX1rrkXV5NaLkidP789osbe35xDxsQHD1oIISKUGV8UCeshh1
bc4rm1MbblrRxh7H0O3oKy220Cep7M013Z8Kd2QG4HGuFNYBMHQpjqC7uFyrGzpe
nzr+8rhtJdJVNg++wOoXBryEcbZK0DBZJVHyNpmqa+fSEio7UqIg4hv7QYUaxq5s
XsN3QaPLQTtqrfQZZZ9lD8TfYeQPAFMYM+NDcx/EBXiWLrF8qkowDTwLj/namAP7
QJtk1ATbBLe2uj0dFY3PX2AEwfZMAJa9CIVjStdE4TXhiXqVMuoaGVwfw5tGWsCN
tC5ZfYy4BI/1mdTRh9BXI1MWBszOwTxjztlIoztslK/+JWbjnKzEXDyYb5yjOSI/
MbbZC+VNVrP0jysCpnXjZ7n1/Zfet/7MvfdOfNpvV23dHHmVxxdoo3YUjIyWgf2k
tg//G9nNY+vLSvDly+w+BUI6JK58GmASdSsodfU/n9ZFUZHnVoPFV5GvqSscy/RK
HePMKf4eANt07nrOZUcYJuK1S+LMwvfUsucVsGLzhbYS0mMmZHkG/SiRA4fwvTLS
tDBpYsdIxuCmn9/JzzB2
=VhSb
-----END PGP SIGNATURE-----

--UC+RhZhEc8lcmajv--

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752881Ab3AWCvm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 21:51:42 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42759 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751263Ab3AWCvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 21:51:39 -0500
Date: Wed, 23 Jan 2013 10:51:27 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC] regulator: Display in use regulators in sysfs
Message-ID: <20130123025125.GB5727@opensource.wolfsonmicro.com>
References: <20130122094624.GJ6857@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="CUfgB8w4ZwR/yMy5"
Content-Disposition: inline
In-Reply-To: <20130122094624.GJ6857@gmail.com>
X-Cookie: Advancement in position.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--CUfgB8w4ZwR/yMy5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jan 22, 2013 at 09:46:24AM +0000, Lee Jones wrote:

> To locate a consumer that currently holds a regulattor, a new sysfs
> entry is created. The consumer are published in
> /sys/class/regulator/regulator.<#>/use.

We call our reference counts use count but this was in fact the original
design, the local reference counts got dropped due to David Brownell's
forceful insistance :/

--CUfgB8w4ZwR/yMy5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQ/1AmAAoJELSic+t+oim9YlwQAICAq1qVkk3EadgpAXaR7uua
+sOhR89SC/x5c0w8CcCwkq2vfemEW9Axy85Cn0pWif45ngU+f8zeI1WvbJPD3yAQ
DGYi8FU8G3F0Ge2JGaUDxMfI//XToxn7GAxyJ5xMnSoNCIpTC+Gh0GDkPtuiZeeF
UgTFM5D0/lihzCz9HASzhc36SpTNOWlcjdMQVQDfZbjVALvrctuWe/0GPtpl8h4k
Lpgr/qoLlyynhSqI6mRNfGLKlsFymdrGwCf3/lD0FsH46ZxDnnRTyzfWZYzfUq2S
yY5lQLWlW0OL/qHpZ+P1FazCvgi3XyYsuE18DAvcSFuxgj1F9k8VCZBc59W5jsNf
GshFSkTP2N8JzWbSf8SL6SqDUFYKwO9v/fHeTdsehL7B3Cszuc3fhCyNGi/nMVUG
OagiqNI6Ptqm256STFHkTSCfvcM2FjXHsHGb7O2O8cK6LHQhz/H3Ax+yeSibTmCU
YOiM0MN8NAiBKo4Cm+pj9loum6zy6rapRUuIg5pOX0eAoJ4lLeB2bvm4Bu3U0UaI
s8kZK2Zscl+MxLLVT7Q1MtRIinEj8d5jrgjmrLIHShmqy8r09uFQtb2YdqQBq8br
B3yWIrJ8obzkupGEP6pxcAJ46TaRjHpHnfkULXLSH4YQlBb4GcekuVABFrDefhwh
m/C3LWdHxmpFH6OyXwdo
=UU1f
-----END PGP SIGNATURE-----

--CUfgB8w4ZwR/yMy5--

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751371Ab3CANRO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 08:17:14 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:40225 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750721Ab3CANRM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 08:17:12 -0500
Date: Fri, 1 Mar 2013 21:16:37 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "gg@slimlogic.co.uk" <gg@slimlogic.co.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stephen Warren <swarren@nvidia.com>,
        "ian@slimlogic.co.uk" <ian@slimlogic.co.uk>
Subject: Re: [PATCH] mfd: palmas: provide irq flags through DT/platform data
Message-ID: <20130301131633.GB25302@opensource.wolfsonmicro.com>
References: <1362141296-15321-1-git-send-email-ldewangan@nvidia.com>
 <20130301124350.GA25302@opensource.wolfsonmicro.com>
 <5130A53C.1000600@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="JK5NARynUCwOaxbc"
Content-Disposition: inline
In-Reply-To: <5130A53C.1000600@nvidia.com>
X-Cookie: Condense soup, not books!
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--JK5NARynUCwOaxbc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Mar 01, 2013 at 06:25:24PM +0530, Laxman Dewangan wrote:
> On Friday 01 March 2013 06:13 PM, Mark Brown wrote:

> >This can't be a generic problem on ARM systems, I'm pretty sure the
> >primary users of palmas would've noticed, this is more of a new feature
> >isn't it?

> I think it is tested with eval board and connected to gpio interrupt
> and hence it is not noticed.

One of the palmas chips is the default PMIC for OMAP5 isn't it?

--JK5NARynUCwOaxbc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRMKopAAoJELSic+t+oim9THgP+wfBQrzJ4tj4Aj7JfSZeYps2
cW7i7ib1/WMwRFrZpNbeaRnOq3MTuVagjEoeKuSAUqFyvqrZaGbjGU2GLcuoEHQE
ci6ZUZ/cEj4AevZpMkl7WqMp39sVRGbX8nvNZvrWmf3fdjuE+BWueR8lUt/gQWSz
UACTOf2fSh4wF8sem+5AL2VJfWdHZ7bjDAvD6t2Y4kwtRKZjY1GdgKu4ByzaCKLW
2FOaKNikI8hf5K2X/QRMNFLonV4nGCiJhs5DApChHABups5MaPurTJggHZ3HQ3Hj
I3OQN8Cym4scDHWC96ORczS4D6lWK0Ft5N9q38Gaul/NogocUb3g2o7iUve91Sa3
vuGPaFcTdMzfQ6Z3iS5F7obR9oSIlwoJqMyrbeJcyEhRXkWaMe/APNHFZuYgbSCU
n0mMMuK6ENs4VTQZGSfkxMXGdwEHfET+uDyk6Hz1ZkKmPLhAfA2RKxOJpv/PkK1J
IZSfBAHczKVy7tlkgoRlmgQVbxhp9lPlx+oumajWb+VVMWwlYTcPmIABEKkUuPHK
G7+7C59hb9bt6k/uj412yhwuEz971lD5ZQSrceNlfRpme4N5VtfuXzTmTACQ61m8
TUf3adA5FZXkLL9yPvZtM5y7efg4aDcGsQLaA5aJu4a44ZY7zDy386N6km8ckA1R
b+rdZFbVctAMbNYhUMLZ
=fr2E
-----END PGP SIGNATURE-----

--JK5NARynUCwOaxbc--

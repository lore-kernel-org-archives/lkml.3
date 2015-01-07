Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754483AbbAGUGY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 15:06:24 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:42037 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753229AbbAGUGW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 15:06:22 -0500
Date: Wed, 7 Jan 2015 20:05:30 +0000
From: Mark Brown <broonie@kernel.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Jon Masters <jcm@redhat.com>, linux-arm-kernel@lists.infradead.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Rob Herring <robh@kernel.org>, Randy Dunlap <rdunlap@infradead.org>,
        Robert Richter <rric@kernel.org>, Jason Cooper <jason@lakedaemon.net>,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Robert Moore <robert.moore@intel.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Lv Zheng <lv.zheng@intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Olof Johansson <olof@lixom.net>
Message-ID: <20150107200530.GK2634@sirena.org.uk>
References: <1413553034-20956-1-git-send-email-hanjun.guo@linaro.org>
 <20150107172741.GY2634@sirena.org.uk>
 <54AD7098.5010700@redhat.com>
 <1610983.9vqJdsL27R@wuerfel>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lAj5KC0HpR6BT8lj"
Content-Disposition: inline
In-Reply-To: <1610983.9vqJdsL27R@wuerfel>
X-Cookie: What's so funny?
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [Linaro-acpi] [PATCH v5 18/18] Documentation: ACPI for ARM64
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--lAj5KC0HpR6BT8lj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jan 07, 2015 at 08:48:48PM +0100, Arnd Bergmann wrote:
> On Wednesday 07 January 2015 12:44:56 Jon Masters wrote:
> > On 01/07/2015 12:27 PM, Mark Brown wrote:

> > > That level of hardware compatibility does partly come from the need to
> > > run existing software.  I'd expect that similar effects will start to
> > > come into play with ARMv8 ACPI systems if they become successful; people
> > > will do things like ensure compatibility with common IPs that have
> > > existing Linux drivers that distros tend to include as standard.

> > Agreed.

> There are two problems I see in trying to do the same thing on ARM:

> * we don't have a single vendor that makes de-facto standards that
>   everyone else has to copy in the way that the few remaining x86
>   vendors copy everything that Intel does. In fact, we prefer to
>   have a large number of independent vendors.

Right, I'd guess that (modulo any standards being defined and becoming
successful) it'll more be a case of vendors keeping compatibility with
their own stuff.  We *are* seeing greater reliance on off the shelf IPs
for more boring things like DMA and basic bus controllers but there's
plenty of other areas that still affect servers.

> * There is a general mindset about deprecating unwanted features
>   early. ARMv8 aarch32 bit mode removes support for older instructions
>   or makes them optional. Even the virtualization mode doesn't allow
>   to trap on architecture version specific differences, so you can't
>   completely emulate an older architecture level.
>   This is nice for implementers but not so much for users that rely
>   on old (mis-)features. It's also not just the CPU core, other
>   components also get easily replaced, like a GICv3 that is not
>   a strict superset of GICv2.

This is indeed worrying, though hopefully the fact that we're already
seeing negative impacts in the app ecosystem for Android will have
focused some minds - once you're talking about full system images it
gets even more fun.

--lAj5KC0HpR6BT8lj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUrZGJAAoJECTWi3JdVIfQwDsIAIKQvB2wIDZg0V3EuvWCvzEc
GUYiujqZtG6hjCbkNpx4Afq9bRCu/0BfTjnCF8SCgJf51RQUqzZj2BFXFd6nJQEu
HbgjNqNY4kkswMVGc85LQUT87CHeAzI2IcetVHHm82KMtTE2WXU/rcNWU4BCF+Vz
fUJ079xrvZ7yV2zlIj/YkpUtlOrOD16nlQhoWN1+Ox/AVqCG5Ymj1kWeDSj9i00+
rAxNpyRDVFJ3tL5mcf7kmrEtQ5q9NCLtWPXKj57lzUDRfSYL0h5eFC0iZt6SiWJh
tyPh82nFAi4aQ8wlaDtZYf258Km+OB5NNnhYAlEbgQNq46cVw9bfeRNsWHjGGls=
=nN2H
-----END PGP SIGNATURE-----

--lAj5KC0HpR6BT8lj--

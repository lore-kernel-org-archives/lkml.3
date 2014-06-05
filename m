Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751401AbaFEGz0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 02:55:26 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:33737 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750827AbaFEGzZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 02:55:25 -0400
Date: Thu, 5 Jun 2014 08:55:20 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: rafael.j.wysocki@intel.com, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, lenb@kernel.org, mingo@kernel.org,
        tglx@linutronix.de, hpa@zytor.com, arjan@linux.intel.com,
        rui.zhang@intel.com, luto@amacapital.net
Subject: Re: [PATCH] idle, thermal, acpi: Remove home grown idle
 implementations
Message-ID: <20140605065520.GB3213@twins.programming.kicks-ass.net>
References: <20140604085418.GA11096@twins.programming.kicks-ass.net>
 <20140604015812.140a00d1@jacob-desktop>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dc+cDN39EJAMEtIO"
Content-Disposition: inline
In-Reply-To: <20140604015812.140a00d1@jacob-desktop>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--dc+cDN39EJAMEtIO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 04, 2014 at 01:58:12AM -0700, Jacob Pan wrote:
> On Wed, 4 Jun 2014 10:54:18 +0200
> Peter Zijlstra <peterz@infradead.org> wrote:
>=20
> >=20
> > I'm still sitting on this patch. Jacub you were going to make it play
> > nice with QoS?
> >=20
> I had a patchset to work through system PM QOS and still maintain the
> idle injection efficiency. When I saw you did not merge the patch
> below, I thought you have abandoned it :)

I was waiting for you to do the QoS bits :-)

> The only issue as per our last discussion is the lack of notification
> when PM QOS cannot be met. But that is intrinsic to PM QOS itself.
>=20
> I also consulted with Arjan and looked at directly intercept with
> intel_idle since both intel_powerclamp and intel_idle are arch specific
> drivers. But I think that is hard to do at per idle period basis,
> since we should still allow "natural" idle during the forced idle time.
>=20
> So, I think we can take a two stepped approach,
> 1. integrate your patch with a
> updated version of https://lkml.org/lkml/2013/11/26/534 such that there
> is no performance/efficiency regression.
> 2. add notification mechanism to system qos when constraints cannot be
> met.

That's fine with me; can you respin those bits?

--dc+cDN39EJAMEtIO
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTkBRYAAoJEHZH4aRLwOS6TIIP/2/7HhMzsqEM3xiEKstX/x+W
NjtcrqB0DhqhSR4Wgxzj6/dAV5mFMMbPfFFTIv3vfadK5IY8LvdvfdPkF6N87iqI
kx4iemZbeqTzdO6MKVymmn0wHSL7DWET/mJrEY7nGu70KshwQotJJWGlrsdXGwGP
B7i1Zn01T2SnxZGhcvLn8zBfhyptoW9Xa/BVLNWOn0Pk3QUh8J9h6Fv96fWfpaYN
J775KzU7HAOXkR84HBqAIUiotpE8836j5yl6ed4TiUfil3mWp5h+9+RCWAa2NnqJ
k/Ukr1xeUP/8YInfvr1k+cZzRADoRQa5B55mpPrHLesfS9gWtr8M3mfn1aAvkzLb
dTzHc/Xwe5lG/lAZ/8a1m1+vHF9iU8hEF43zmkTFZjg6wMTV3iqPEkNTMW48v0ZJ
ONB1Ci7/pfJAlMZMhaMSQeHekFmaWkg1BX3LyikZktvijV5JrtIwdsjJWTwQPS3j
3FJz1tty5H2FB+htArjDTX4EsmsH1qdomIWyIiGhBEpbLg6ejiBmVRHOQJZ3OEmr
KoFQYeTa1TrsH0Rvi65r40F1M0sA5IXtBe2xyZzw7iTpyr6XrNvW5HdFO7YIylm3
AjNVufP+DKnaN3AzKJkmAuG/ysXE6p98X/juhiFTXt40cBRnDApPYFrQCIc3to1G
feRrKPUemtQaqJua47BB
=YgC3
-----END PGP SIGNATURE-----

--dc+cDN39EJAMEtIO--

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751352AbaGaPZ5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 11:25:57 -0400
Received: from casper.infradead.org ([85.118.1.10]:48724 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774AbaGaPZ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 11:25:56 -0400
Date: Thu, 31 Jul 2014 17:25:43 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: "Yan, Zheng" <zheng.z.yan@intel.com>, linux-kernel@vger.kernel.org,
        mingo@kernel.org, acme@infradead.org, eranian@google.com
Subject: Re: [PATCH v3 6/9] perf, x86: handle multiple records in PEBS buffer
Message-ID: <20140731152543.GX19379@twins.programming.kicks-ass.net>
References: <1406016602-31845-1-git-send-email-zheng.z.yan@intel.com>
 <1406016602-31845-7-git-send-email-zheng.z.yan@intel.com>
 <20140725081033.GV3935@laptop>
 <53D216A4.3090600@intel.com>
 <20140725140652.GA6758@twins.programming.kicks-ass.net>
 <53D5B45E.4030403@intel.com>
 <20140728065255.GI6758@twins.programming.kicks-ass.net>
 <53D9F0D7.7030002@intel.com>
 <87a97pr3k3.fsf@tassilo.jf.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="itXlm6KT/9NFvrz/"
Content-Disposition: inline
In-Reply-To: <87a97pr3k3.fsf@tassilo.jf.intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--itXlm6KT/9NFvrz/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 31, 2014 at 07:44:12AM -0700, Andi Kleen wrote:
> "Yan, Zheng" <zheng.z.yan@intel.com> writes:
> >>=20
> >> Please lock yourselves in room and do not come out until you can give a
> >> straight and coherent answer.
> >>=20
> >
> > Andi,
> >
> > please confirm this
>=20
> The hardware can merge PEBS events that happen nearby each other.=20
> I was wrong earlier in stating the opposite.

OK, thanks!

--itXlm6KT/9NFvrz/
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJT2l/2AAoJEHZH4aRLwOS6byQP/i8bQohZ5dRaOBY+hKTXdHa1
Pc4OCXkG3rMcw4EpRObmi5Vs9q2bpoNcY374UqNnx7ryHCz87xZzk6xLOh4GYaB2
eHUqSWC1ERTLcGs/owQ6gbekafgCBBsqKn+mx8jnvjvKr9uktRt6j8tIRiWd6m7a
Qje1MtTZtY4Ph8QGleoUUsSJefeI9wepyzSQ9Clwp5bPrOopZqa86m0bnVSEFhFw
8sS/FiAaJ5uQEo3AVAwh5K+DcCn0/s9O9DSQkhatLsDth8lSqkQALVVK2l6ujcY0
Tcq+LLe7EuVEsgNY6jv44vL3FKnOsHUX7PeiSNYNBPdOIiCh742DMuVjfxFwvfdf
q+Zuo/UBSHhzB6r6ZvJ2iSTgGXfUJH1oa/ZNJ2SW+KinZStCuOhBXP5apkLlVXsZ
Enk2FqJLrUV7oT2dtKHfxRbPo73h+aiS+CEibs/slZcsrzDGjq8OdUaSULVxS6Sz
IEQnH1TZIvCyPQDsZ1LNBr8AmvuBSoMBbrwoAIFqT8Zch9OEiRcCy7l0WlUY4dpd
YWvH3tAIX5dSkOQTTBCJYAcK0sUvOtWqr/C2JB9RrmEwLZUBO9FzbT2ix9cmrhg3
Han+GvHz6Y5K9Mbt9fTis1vMLayS/yFdOdyvlMcgYVkw4UorM6woPocXneFOeJh0
Ufz9ZY+8piAYn6JKJ0L/
=aFlB
-----END PGP SIGNATURE-----

--itXlm6KT/9NFvrz/--

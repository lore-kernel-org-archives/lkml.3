Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755034AbaEOP45 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 11:56:57 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:45722 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754921AbaEOP4y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 11:56:54 -0400
Date: Thu, 15 May 2014 17:56:47 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Dave Jones <davej@redhat.com>, Mateusz Guzik <mguzik@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org
Subject: Re: WARN in do_rt_tgsigqueueinfo()
Message-ID: <20140515155647.GG11096@twins.programming.kicks-ass.net>
References: <20140515133834.GN13658@twins.programming.kicks-ass.net>
 <20140515142723.GB22041@mguzik.redhat.com>
 <20140515150412.GP30445@twins.programming.kicks-ass.net>
 <20140515155415.GA326@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TJXgsAvz6ds/es3G"
Content-Disposition: inline
In-Reply-To: <20140515155415.GA326@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--TJXgsAvz6ds/es3G
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 15, 2014 at 11:54:15AM -0400, Dave Jones wrote:
> There's a ton of 'noise' like this that fuzzing turns up.
> I've been collecting some of the stuff to shut it up..
>=20
> http://codemonkey.org.uk/junk/silence-fuzz-testing-noise.patch
> http://codemonkey.org.uk/junk/silence-noisy-deprecated-warnings-while-fuz=
zing.patch
>=20
> I'm of the opinion that a user-triggerable WARN is a bug, but aparently
> not everyone else feels that way.

Awesome, thanks!

--TJXgsAvz6ds/es3G
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTdOO/AAoJEHZH4aRLwOS6kNQP/R4osGFjliysWtT8D08NSKdk
9/WbStL3+84UZ5gRGoPn6m+pEfEfqfVFx8Y9UL2/Lu4BK/jSI20pCgZwEf8xGoMx
42TFUVzvuqpAdcHZHIvJYtS3psKv2Qi4FXbJ+wewisEIHSPke0qaOPDnUpqlaLm0
iIu2hQNtbzMwbynewlxvf+n3N3E62HxWMC1LWNbniXymPaRVhVM0buRnxdeH0B66
c/owBcaC1DvYYl7tCAVL4PaZoXSlxjn3adzzMaMczpHhPqRUWmsdQtZv4E/VgaNA
J4d/70r/2BFdSgeL7k9QofFlSKKjAdW5jmwaV1NoApVOPS6HA3Hjt7R/hhnuouVq
3j8psWu6Rj+F0kLIJfvtN2md3/qXo/sTCzU3D/vCGWYgo8Y3vg+TDJY746em4eP5
CgCBjYB6kaD1ZHRn0LFtKiFGb7zezlmVx5Bg1izrVv7whoDaJ3vDf/nmENwDQ1yX
N/vIRkHhm9IX+0A7BrXMH/oCbqCRO5SEV26aMqGQ3baWDUzdYHzx/GX6Rn5RNB8A
yh9QBxc5LdL+zsCfHPxvomz6+rVpbQG/HZT06QD6Z5buKmjB+g0m2g/4RusvQofr
yEsnxbT3vkVTjW/dTOv+IPKXZo5PFQjvgJBTEoOxHftEEG77Fuf5CUSI4j9BX1SJ
C3EvwaBRvoqMTQKMxeuM
=6TvW
-----END PGP SIGNATURE-----

--TJXgsAvz6ds/es3G--

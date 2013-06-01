Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755748Ab3FAVFW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jun 2013 17:05:22 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:39591 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754901Ab3FAVFS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jun 2013 17:05:18 -0400
Date: Sat, 1 Jun 2013 22:05:11 +0100
From: Mark Brown <broonie@kernel.org>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: Kishon Vijay Abraham I <kishon@ti.com>,
        "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gg@slimlogic.co.uk" <gg@slimlogic.co.uk>,
        "ian@slimlogic.co.uk" <ian@slimlogic.co.uk>,
        "balbi@ti.com" <balbi@ti.com>
Message-ID: <20130601210511.GT16790@sirena.org.uk>
References: <1369911393-25747-1-git-send-email-kishon@ti.com>
 <20130530113247.GI5180@sirena.org.uk>
 <51A74D70.5060303@nvidia.com>
 <20130601184511.GC16790@sirena.org.uk>
 <51AA456E.3030307@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8+OS07CeIgZ706fH"
Content-Disposition: inline
In-Reply-To: <51AA456E.3030307@nvidia.com>
X-Cookie: Advancement in position.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 82.42.102.178
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [RFC PATCH] regulator: palmas: enable all modes for SMPS10
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--8+OS07CeIgZ706fH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Jun 02, 2013 at 12:33:10AM +0530, Laxman Dewangan wrote:
> On Sunday 02 June 2013 12:15 AM, Mark Brown wrote:

> >No, that makes no sense at all to me.  Why do you think this maps onto
> >the set mode API?  Modes are all about accuracy of regulation.

> I mapped this to the regulation under different load, Fast mode is
> in heavy load and so boost enable, normal/idle mode for normal load
> and so bypass.

This is still not making any sense.  The quality of regulation and
output voltage are essentially orthogonal, and obviously there's a
specific API for bypass which is something different again to both
mode and output voltage selection.

--8+OS07CeIgZ706fH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRqmH+AAoJELSic+t+oim9/UkP/2YPrI6H2LBdEhNxiXj1Ao0V
4k5qIC+32XaqCNrMcD9Ly+Uur7heDe4LJQ9s5vvNVuk1WllCrluLYarolHQLkZ/a
VsL/8TttJEZWvww3CVS17czyRwE6qgrTIDmHBQr+guQYfVVA4Nt+zbygq5Zdy0c1
DwGtd1r3HOiyJ0jPEq9zely7wJF9pMKJj7Gc79QMaCZtqAyCCLg/Wb+0pRh6hTDg
AmWzmIBkC9R+ZBJQ0T3Hvn+kwCVRxvVnMpq1BNhlevD5MGYPPbrHLSF1oV32WRmb
E6/n/nJg0vkOOPhCGV6n4YPzJdYI4H7M34m2EBTOTWKqEIuqNkFp7fqsKFuejdFP
A+lU9d7LMAlah/RaAB0VaMNCP/l0klRTpj6dxGmgpjqwzGmJ+aIIrwcNbXldv2Hq
Etje/6ugVjK0sf1L3w/Q4a3EVdUhGmLMhnVjc9+/VcsshhQ58PL0tTX/Z1SHjU3f
ackahCPaH/cm42dG0LMDks2tJbpW2+kWzuD0f7VHGPnupdkUThcvgWAgWmOImtcM
+JGks+C8AWuM9R/3QrryR+em2pulAHKNmtOrIQ7WRIIZYg5mtBVNgBdDXHzLNmEA
PzojtWcbX/J8ijiUwCRtW5dWxhrlZbeCthTHT+UvIJnBKefGRdvDLWVB10ACaZed
a/4r193GhfoPJcUykaTQ
=EJyi
-----END PGP SIGNATURE-----

--8+OS07CeIgZ706fH--

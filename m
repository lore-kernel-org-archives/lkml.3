Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755673AbaBFIfZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 03:35:25 -0500
Received: from top.free-electrons.com ([176.31.233.9]:39386 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755232AbaBFIfX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 03:35:23 -0500
Date: Thu, 6 Feb 2014 09:31:53 +0100
From: "'Maxime Ripard'" <maxime.ripard@free-electrons.com>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'Andrew Morton'" <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        "'Alexandre Belloni'" <alexandre.belloni@free-electrons.com>
Subject: Re: [PATCH 05/12] backlight: hx8357: Remove unnecessary OOM messages
Message-ID: <20140206083153.GE3192@lukather>
References: <000101cf2313$6ef38e80$4cdaab80$%han@samsung.com>
 <000601cf2314$4f66a9c0$ee33fd40$%han@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FN+gV9K+162wdwwF"
Content-Disposition: inline
In-Reply-To: <000601cf2314$4f66a9c0$ee33fd40$%han@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--FN+gV9K+162wdwwF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 06, 2014 at 05:20:35PM +0900, Jingoo Han wrote:
> The site-specific OOM messages are unnecessary, because they
> duplicate the MM subsystem generic OOM message.
>=20
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>

Acked-by: Maxime Ripard <maxime.ripard@free-electrons.com>

Thanks!

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--FN+gV9K+162wdwwF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJS80h4AAoJEBx+YmzsjxAgKVgP/j6OQ44jpw7ZdOsy/BluTie1
lPfjGhs+MOaRZ9F7XfzxAxfNK7iNMjgIzZz8rTqor4JH+CUSETmlWvHC/R6rzKk0
jjS78bJAMnmIQ7rsb5vyQquEydXFSEH3RaMvqTBCaB5GRPe/Enc8tWtVLrIAEePq
Da60cGR6q1kHbSQub7nQyaSMlsE5CpLUgKMgC9tWAi+xH6LuVlSidsrk8AB/Z6TD
J+ixtPT44K8LEQd3CWgvAA3oW9AVWoPv/edbyB/K5dXTEuDJwLiW50Ach2cjW/YF
OwCaJIFwFnRMY8n7AN6ZoWEJrJnIu1yy/EMCUrLeqdlpRdhIn2wMROT+J0/lDPI8
Exlbrkytj5f6CS5dKDCqClfRtF4aUf5BexEuTIvA+gZOM1We7q264l/kbSRGRNAj
UtnaBbsG5JtUX36O+ttNLO6+0HLtLmJBDgUAGVRhq4WyMka8T6F7KyOpx+9xuL2r
NJCQIe+VF6FCImWDd38O8vhx54TP6w/+vt0PsWo2dQpI1u0iaSNX39wzZ1ZI4gbg
OvY2AH7Vow4U9LMZj8/tkyF2KtvUNVfvsmGFqdQd/Te49t0LDctCK7uXOl82G+nI
7IJlnienfSrzYNKJHgmKf/gcusx3VebUSrirzaMumLkPwycT/C4ih2gV+bfuwiR3
oux4jKqR9x1M1I/8zUuQ
=N0V4
-----END PGP SIGNATURE-----

--FN+gV9K+162wdwwF--

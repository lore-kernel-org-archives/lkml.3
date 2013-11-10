Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751053Ab3KJJzH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Nov 2013 04:55:07 -0500
Received: from top.free-electrons.com ([176.31.233.9]:60180 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750939Ab3KJJzD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Nov 2013 04:55:03 -0500
Date: Sun, 10 Nov 2013 10:52:52 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: tglx@linutronix.de, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, sboyd@codeaurora.org
Subject: Re: [PATCH 2/2] clocksource: sun4i: change CPU mask to
 cpu_possible_mask
Message-ID: <20131110095252.GH26440@lukather>
References: <1382699771-4396-1-git-send-email-maxime.ripard@free-electrons.com>
 <1382699771-4396-3-git-send-email-maxime.ripard@free-electrons.com>
 <527B693D.9010304@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Ry3qE+viRNtbc3l7"
Content-Disposition: inline
In-Reply-To: <527B693D.9010304@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Ry3qE+viRNtbc3l7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Daniel,

On Thu, Nov 07, 2013 at 11:19:41AM +0100, Daniel Lezcano wrote:
> On 10/25/2013 01:16 PM, Maxime Ripard wrote:
> >The interrupt for the timer is a shared processor interrupt, so any CPU
> >found in the system can handle it. Switch to our cpumask to
> >cpu_possible_mask instead of cpumask_of(0).
> >
> >Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
>=20
> Applied to my tree for 3.14

Thanks!

> sidenote: did you look at the CLOCK_EVT_FEAT_DYNIRQ flag ? It may
> reduce the number of wakeup for your system.

Not yet, but I'll give it a look for sure :)

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--Ry3qE+viRNtbc3l7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSf1d0AAoJEBx+YmzsjxAgPYIP/i9sWBsWPoaXTMAIOoiHK7h/
/8XxxNKZj7EhFX8ggMnkzzEy9N24PD0WWSSnDELlWjoq2e7rC2JIQjXzN7zTdjTj
NjB3pSXCTeaW7iXYFYrByqecI8qDtwpHMUmgB2ul/HL6A9tIQeybSk/GNzbZXkP0
md3PTNgifHHAigpcBDbNbveCR9UPAtiS+rztzfpZhT6x/Md7JGc7EChw4+IpdGSV
OZSZNxemv1ak3iv/orTs5hLph7L8gv7kjZL6apzmkJD6/beCKnI8SVOJL+bUd+ZT
f10aqpG/QcdsjYLXm5N/KLKVgcuv2XLC+j+C+WOsGZlEpA09JMXyjgSdMk7oJ37P
KYNfxhzdXlR4iGN3WCmpZ9Z5y/wwf/cxTLfYgZi1qI6rgOwYVr/oYdqncBf/p5aE
e3D20OWVG31xn69yYFF1wCxEWPV2gxHQrza4TdRJqQ2dBXqqSRQurGT6oAu8wXcV
iQmq+gYpebG0vTPU1v3kEO8WCfIN/emkWXf6xjmJYVi/cYhyPQlO161Hd+N1H6nY
8vFDnODFCywaL8pvXmqX6IloxLCFInPUkEQsVXTHUzyBjMuODDdOLjh5NAxWg7K7
YcgK8/wVafiOd/Dij0+Hk3MDQkAGbljtHR3Gm7UOmpCS7z+nlnJQcvZ8uJFdkr5x
kSyDOXN/uX3hWqEebfcq
=QS5/
-----END PGP SIGNATURE-----

--Ry3qE+viRNtbc3l7--
